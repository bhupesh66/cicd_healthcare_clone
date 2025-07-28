import logging
import os
from azure.storage.blob import BlobServiceClient
from azure.servicebus import ServiceBusClient, ServiceBusMessage
import azure.functions as func

# Environment variables (configured in Function App settings)
STORAGE_CONN = os.getenv("STORAGE_CONN")
SERVICEBUS_CONN = os.getenv("SERVICEBUS_CONN")
QUEUE_NAME = "data-ready-queue"
CONTAINER_NAME = "your-container"  # Change to your actual container name

def main(event: func.EventGridEvent):
    logging.info('Event received: %s', event.get_json())
    data = event.get_json()
    blob_url = data['url']  # full URL of the new blob

    # Extract blob name from URL
    # Example URL: https://<account>.blob.core.windows.net/container/incoming/dassscrub/demo/xyz/xyzdemo202507.csv
    blob_name = blob_url.split("/")[-1]  # e.g., xyzdemo202507.csv
    company = blob_name[:3]               # 'xyz'
    dataset_type = blob_name[3:7]         # 'demo', 'phar', 'medi', 'elig' etc.
    period = blob_name[7:13]               # '202507'

    blob_client = BlobServiceClient.from_connection_string(STORAGE_CONN)
    container_client = blob_client.get_container_client(CONTAINER_NAME)

    # Define expected file paths
    pharmacy_file = f"incoming/dassscrub/pharmacy/{company}/{company}pharmacy{period}.csv"
    medical_file  = f"incoming/dassscrub/medical/{company}/{company}medical{period}.csv"
    demo_file    = f"incoming/dassscrub/demo/{company}/{company}demo{period}.csv"
    elig_file    = f"incoming/dassscrub/elig/{company}/{company}elig{period}.csv"

    # Determine dependencies based on the dataset_type of incoming file
    if dataset_type == "phar":   # pharmacy file
        dependencies = [pharmacy_file, medical_file, demo_file]
    elif dataset_type == "medi":  # medical file
        dependencies = [medical_file, elig_file, pharmacy_file]
    elif dataset_type == "demo":  # demo file
        dependencies = [demo_file, pharmacy_file, medical_file]
    elif dataset_type == "elig":  # elig file
        dependencies = [elig_file, pharmacy_file, medical_file]
    else:
        # If file type unknown, consider only that file itself (optional)
        dependencies = [f"incoming/dassscrub/{dataset_type}/{company}/{blob_name}"]

    # Check if all dependencies exist
    all_exist = True
    missing_files = []
    for dep in dependencies:
        blob_dep_client = container_client.get_blob_client(dep)
        if not blob_dep_client.exists():
            all_exist = False
            missing_files.append(dep)

    if all_exist:
        # All dependency files are present, send message to Service Bus
        sb_client = ServiceBusClient.from_connection_string(SERVICEBUS_CONN)
        with sb_client:
            sender = sb_client.get_queue_sender(queue_name=QUEUE_NAME)
            with sender:
                msg_body = f"{company}:{period}:ready"
                msg = ServiceBusMessage(msg_body)
                sender.send_messages(msg)
        logging.info(f"All files found for {company} period {period}. Sent message to Service Bus.")
    else:
        logging.warning(f"Missing dependency files for {company} period {period}: {missing_files}")
