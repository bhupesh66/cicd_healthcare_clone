# import logging
# import os
# from azure.storage.blob import BlobServiceClient
# from azure.servicebus import ServiceBusClient, ServiceBusMessage
# import azure.functions as func

# # Environment variables (configured in Function App settings)
# STORAGE_CONN = os.getenv("STORAGE_CONN")
# SERVICEBUS_CONN = os.getenv("SERVICEBUS_CONN")
# QUEUE_NAME = "data-ready-queue"
# CONTAINER_NAME = "your-container"  # Change to your actual container name

# def main(event: func.EventGridEvent):
#     logging.info('Event received: %s', event.get_json())
#     data = event.get_json()
#     blob_url = data['url']  # full URL of the new blob

#     # Extract blob name from URL
#     # Example URL: https://<account>.blob.core.windows.net/container/incoming/dassscrub/demo/xyz/xyzdemo202507.csv
#     blob_name = blob_url.split("/")[-1]  # e.g., xyzdemo202507.csv
#     company = blob_name[:3]               # 'xyz'
#     dataset_type = blob_name[3:7]         # 'demo', 'phar', 'medi', 'elig' etc.
#     period = blob_name[7:13]               # '202507'

#     blob_client = BlobServiceClient.from_connection_string(STORAGE_CONN)
#     container_client = blob_client.get_container_client(CONTAINER_NAME)

#     # Define expected file paths
#     pharmacy_file = f"incoming/dassscrub/pharmacy/{company}/{company}pharmacy{period}.csv"
#     medical_file  = f"incoming/dassscrub/medical/{company}/{company}medical{period}.csv"
#     demo_file    = f"incoming/dassscrub/demo/{company}/{company}demo{period}.csv"
#     elig_file    = f"incoming/dassscrub/elig/{company}/{company}elig{period}.csv"

#     # Determine dependencies based on the dataset_type of incoming file
#     if dataset_type == "phar":   # pharmacy file
#         dependencies = [pharmacy_file, medical_file, demo_file]
#     elif dataset_type == "medi":  # medical file
#         dependencies = [medical_file, elig_file, pharmacy_file]
#     elif dataset_type == "demo":  # demo file
#         dependencies = [demo_file, pharmacy_file, medical_file]
#     elif dataset_type == "elig":  # elig file
#         dependencies = [elig_file, pharmacy_file, medical_file]
#     else:
#         # If file type unknown, consider only that file itself (optional)
#         dependencies = [f"incoming/dassscrub/{dataset_type}/{company}/{blob_name}"]

#     # Check if all dependencies exist
#     all_exist = True
#     missing_files = []
#     for dep in dependencies:
#         blob_dep_client = container_client.get_blob_client(dep)
#         if not blob_dep_client.exists():
#             all_exist = False
#             missing_files.append(dep)

#     if all_exist:
#         # All dependency files are present, send message to Service Bus
#         sb_client = ServiceBusClient.from_connection_string(SERVICEBUS_CONN)
#         with sb_client:
#             sender = sb_client.get_queue_sender(queue_name=QUEUE_NAME)
#             with sender:
#                 msg_body = f"{company}:{period}:ready"
#                 # msg = ServiceBusMessage(msg_body)
#                 # sender.send_messages(msg)
#         logging.info(f"All files found for {company} period {period}. Sent message to Service Bus.")
#     else:
#         logging.warning(f"Missing dependency files for {company} period {period}: {missing_files}")


# import logging
# import azure.functions as func
# import json

# def main(event: func.EventGridEvent) -> None:
#     logging.info("Event received!")
    
#     try:
#         event_data = event.get_json()
#         logging.info(f"Event data: {json.dumps(event_data)}")
#     except Exception as e:
#         logging.error(f"Failed to process event: {e}")
#         raise e  # This will tell Event Grid the delivery failed

    # Nothing needs to be returned for EventGrid triggers (no HTTP response),
    # but raising an exception will mark it as failure, and no exception = success
# sure code 

# import logging
# import os
# from azure.storage.blob import BlobServiceClient
# import azure.functions as func

# # Environment variables
# STORAGE_CONN = os.getenv("STORAGE_CONN")
# CONTAINER_NAME = "your-container"  # Replace with your actual container name

# def main(event: func.EventGridEvent):
#     try:
#         logging.info('Event received: %s', event.get_json())
#         data = event.get_json()
#         blob_url = data['url']

#         # Extract blob info
#         blob_name = blob_url.split("/")[-1]  # e.g., xyzphar202502.csv
#         company = blob_name[:3]              # e.g., xyz
#         dataset_type = blob_name[3:7]        # e.g., phar
#         period = blob_name[7:13]             # e.g., 202502

#         # Mapping short dataset types to folders and filenames
#         expected_files = {
#             "phar": f"pharmacy/{company}/{company}phar{period}.csv",
#             "medi": f"medical/{company}/{company}medi{period}.csv",
#             "demo": f"demo/{company}/{company}demo{period}.csv"
#         }

#         # All 3 dependencies regardless of which file triggered the function
#         dependencies = list(expected_files.values())

#         # Check blob existence
#         blob_client = BlobServiceClient.from_connection_string(STORAGE_CONN)
#         container_client = blob_client.get_container_client(CONTAINER_NAME)
        

#         missing = []
#         for path in dependencies:
#             full_path = f"incoming/dassscrub/{path}"
#             try:
#                 if not container_client.get_blob_client(full_path).exists():
#                     missing.append(full_path)
#             except Exception as check_err:
#                 logging.warning(f"Error checking blob {full_path}: {check_err}")
#                 missing.append(full_path)

#         if not missing:
#             logging.info(f" All dependencies exist for {company} - {period}.")
#             # Optionally trigger further downstream logic here
#         else:
#             logging.warning(f" Missing dependencies for {company} - {period}: {missing}")

#     except Exception as e:
#         logging.error(f"Error processing event: {e}")
#         raise  # Re-raise to notify Event Grid of failure
import logging
import os
from azure.storage.blob import BlobServiceClient
from azure.identity import DefaultAzureCredential
import azure.functions as func

# Configuration - get from environment variables
STORAGE_CONN = os.getenv("STORAGE_CONN")
STORAGE_ACCOUNT = os.getenv("STORAGE_ACCOUNT")  # Add this to your config
CONTAINER_NAME = os.getenv("CONTAINER_NAME", "incoming")  # Default to "incoming"

def get_blob_service_client():
    """Create a blob service client with fallback authentication"""
    try:
        if STORAGE_CONN:
            logging.info("Authenticating with connection string")
            return BlobServiceClient.from_connection_string(STORAGE_CONN)
        
        # Fallback to Managed Identity
        logging.info("Authenticating with DefaultAzureCredential")
        account_url = f"https://{STORAGE_ACCOUNT}.blob.core.windows.net"
        return BlobServiceClient(account_url, credential=DefaultAzureCredential())
    except Exception as e:
        logging.error(f"Failed to create BlobServiceClient: {str(e)}")
        raise

def build_full_path(dataset_type: str, company: str, period: str) -> str:
    """Builds the complete blob path matching your actual storage structure"""
    folder_map = {
        "phar": "pharmacy",
        "medi": "medical",
        "demo": "demo"
    }
    filename = f"{company}{dataset_type}{period}.csv"
    return f"incoming/dassscrub/{folder_map[dataset_type]}/{company}/{filename}"

def check_blob_exists(container_client, blob_path: str) -> bool:
    """Enhanced blob existence check with better error handling"""
    try:
        blob_client = container_client.get_blob_client(blob_path)
        exists = blob_client.exists()
        logging.info(f"Checked {blob_path} - {'Exists' if exists else 'Missing'}")
        return exists
    except Exception as e:
        if "AuthenticationFailed" in str(e):
            logging.error("Authentication failed. Please verify:")
            logging.error("1. Storage connection string is valid")
            logging.error("2. Managed Identity has 'Storage Blob Data Reader' role")
            logging.error("3. Storage firewall allows access")
        else:
            logging.error(f"Error checking blob: {str(e)}")
        return False

def main(event: func.EventGridEvent):
    try:
        # Parse the triggering file
        data = event.get_json()
        blob_url = data['url']
        blob_name = blob_url.split("/")[-1]
        
        company = blob_name[:3]       # xyz
        dataset_type = blob_name[3:7] # phar/medi/demo
        period = blob_name[7:13]      # YYYYMM
        
        logging.info(f"Processing {dataset_type} file for {company}-{period}")

        # Initialize clients with proper auth
        blob_service = get_blob_service_client()
        container_client = blob_service.get_container_client(CONTAINER_NAME)

        # Verify triggering file using exact path from event
        triggering_path = blob_url.split(f"{CONTAINER_NAME}/")[-1]
        if not check_blob_exists(container_client, triggering_path):
            logging.error(f"Triggering file not found: {triggering_path}")
            return

        # Check companion files
        other_types = {"phar", "medi", "demo"} - {dataset_type}
        missing = []
        present = [triggering_path]

        for other_type in other_types:
            path = build_full_path(other_type, company, period)
            if check_blob_exists(container_client, path):
                present.append(path)
            else:
                missing.append(path)

        # Determine action
        if not missing:
            logging.info(f"✅ ALL FILES PRESENT: {company}-{period}")
            logging.info("Present files:\n- " + "\n- ".join(present))
            # Add your downstream processing here
        else:
            logging.warning(f"⏳ WAITING FOR FILES: {company}-{period}")
            logging.info("Present:\n- " + "\n- ".join(present))
            logging.info("Missing:\n- " + "\n- ".join(missing))

    except Exception as e:
        logging.error(f"🚨 PROCESSING FAILED: {str(e)}", exc_info=True)
        raise