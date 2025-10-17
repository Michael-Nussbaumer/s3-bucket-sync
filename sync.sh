#!/bin/bash
set -e

echo "Starting Hetzner S3 → Hetzner S3 sync using AWS CLI"

# Check required vars
: "${SRC_ACCESS_KEY?Missing SRC_ACCESS_KEY}"
: "${SRC_SECRET_KEY?Missing SRC_SECRET_KEY}"
: "${SRC_ENDPOINT?Missing SRC_ENDPOINT}"
: "${SRC_BUCKET?Missing SRC_BUCKET}"
: "${DST_ACCESS_KEY?Missing DST_ACCESS_KEY}"
: "${DST_SECRET_KEY?Missing DST_SECRET_KEY}"
: "${DST_ENDPOINT?Missing DST_ENDPOINT}"
: "${DST_BUCKET?Missing DST_BUCKET}"

# Temporary local folder
TMP_DIR=/tmp/hetzner_sync
mkdir -p "$TMP_DIR"

# 1️⃣ Download from source bucket to temp
echo "Downloading from source: $SRC_BUCKET..."
AWS_ACCESS_KEY_ID="$SRC_ACCESS_KEY" \
AWS_SECRET_ACCESS_KEY="$SRC_SECRET_KEY" \
aws s3 sync s3://"$SRC_BUCKET" "$TMP_DIR" \
    --endpoint-url "https://$SRC_ENDPOINT" \
    --no-progress

# 2️⃣ Upload to destination bucket
echo "Uploading to destination: $DST_BUCKET..."
AWS_ACCESS_KEY_ID="$DST_ACCESS_KEY" \
AWS_SECRET_ACCESS_KEY="$DST_SECRET_KEY" \
aws s3 sync "$TMP_DIR" s3://"$DST_BUCKET" \
    --endpoint-url "https://$DST_ENDPOINT" \
    --delete \
    --no-progress

echo "✅ Sync completed successfully"
