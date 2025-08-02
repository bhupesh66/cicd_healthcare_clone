import logging
import os
from azure.storage.blob import BlobServiceClient
from azure.servicebus import ServiceBusClient, ServiceBusMessage
import azure.functions as func

# Environment variables
STORAGE_CONN = os.getenv("STORAGE_CONN")
SERVICEBUS_CONN = os.getenv("SERVICEBUS_CONN")
QUEUE_NAME = "data-ready-queue"
CONTAINER_NAME = "incoming"

def main(event: func.EventGridEvent):
    # First handle Event Grid validation request
    if 'validationCode' in event.get_json():
        logging.info("Handling validation request")
        return {
            "validationResponse": event.get_json()['validationCode']
        }

    try:
        logging.info('Event received: %s', event.get_json())
        data = event.get_json()
        
        # Validate required fields
        if 'url' not in data:
            raise ValueError("Missing 'url' in event data")
            
        blob_url = data['url']
        parts = blob_url.split("/")
        
        # More robust path parsing
        if len(parts) < 6:
            raise ValueError(f"Invalid blob URL format: {blob_url}")
            
        blob_name = parts[-1]
        if len(blob_name) < 13:
            raise ValueError(f"Invalid blob name format: {blob_name}")

        company = blob_name[:3]
        dataset_type = blob_name[3:7]
        period = blob_name[7:13]

        # Initialize clients
        blob_client = BlobServiceClient.from_connection_string(STORAGE_CONN)
        container_client = blob_client.get_container_client(CONTAINER_NAME)

        # Define file paths
        file_types = {
            "phar": "pharmacy",
            "medi": "medical",
            "demo": "demo",
            "elig": "elig"
        }
        
        if dataset_type not in file_types:
            raise ValueError(f"Unknown dataset type: {dataset_type}")

        # Check dependencies
        dependencies = []
        for dtype, dname in file_types.items():
            if dtype != dataset_type:  # Skip current file type
                dep_path = f"incoming/dassscrub/{dname}/{company}/{company}{dtype}{period}.csv"
                dependencies.append(dep_path)

        missing_files = []
        for dep in dependencies:
            if not container_client.get_blob_client(dep).exists():
                missing_files.append(dep)

        if not missing_files:
            # Send to Service Bus if all files exist
            with ServiceBusClient.from_connection_string(SERVICEBUS_CONN) as sb_client:
                with sb_client.get_queue_sender(QUEUE_NAME) as sender:
                    msg = ServiceBusMessage(f"{company}:{period}:ready")
                    sender.send_messages(msg)
            logging.info(f"Processed {blob_name} successfully")

    except Exception as e:
        logging.error(f"Error processing event: {str(e)}")
        raise  # Re-raise to ensure Event Grid knows the delivery failed
# import logging
# import azure.functions as func
# import json

# def main(event: func.EventGridEvent):
#     logging.info("Event received!")
#     event_data = event.get_json()
#     logging.info(f"Event data: {json.dumps(event_data)}")
