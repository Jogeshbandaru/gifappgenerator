import boto3
import sys

AWS_REGION = "us-east-1"  # Update this as needed
BUCKET_NAME = "secure-app-bucket"  # Change if necessary

def check_s3_bucket():
    s3 = boto3.client("s3", region_name=AWS_REGION)

    # Check if the bucket exists
    try:
        s3.head_bucket(Bucket=BUCKET_NAME)
        print(f"✅ S3 Bucket '{BUCKET_NAME}' exists.")
    except Exception as e:
        print(f"❌ S3 Bucket '{BUCKET_NAME}' does not exist: {str(e)}")
        sys.exit(1)

    # Check if the bucket is private
    acl = s3.get_bucket_acl(Bucket=BUCKET_NAME)
    for grant in acl["Grants"]:
        if grant["Grantee"].get("URI") == "http://acs.amazonaws.com/groups/global/AllUsers":
            print(f"❌ S3 Bucket '{BUCKET_NAME}' is publicly accessible!")
            sys.exit(1)
    print(f"✅ S3 Bucket '{BUCKET_NAME}' is private.")

    # Check if encryption is enabled
    try:
        encryption = s3.get_bucket_encryption(Bucket=BUCKET_NAME)
        rules = encryption["ServerSideEncryptionConfiguration"]["Rules"]
        for rule in rules:
            algo = rule["ApplyServerSideEncryptionByDefault"]["SSEAlgorithm"]
            if algo == "AES256":
                print(f"✅ Encryption is enabled with '{algo}'.")
                return
        print("❌ Encryption is not enabled with AES256.")
        sys.exit(1)
    except s3.exceptions.ClientError as e:
        print(f"❌ No encryption policy found: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    check_s3_bucket()
