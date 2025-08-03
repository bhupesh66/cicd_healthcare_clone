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