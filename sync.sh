#!/bin/bash
set -e

echo "Starting Hetzner S3 sync..."

# Validate variables
: "${SRC_ACCESS_KEY?Need to set SRC_ACCESS_KEY}"
: "${SRC_SECRET_KEY?Need to set SRC_SECRET_KEY}"
: "${SRC_ENDPOINT?Need to set SRC_ENDPOINT}"
: "${SRC_BUCKET?Need to set SRC_BUCKET}"

: "${DST_ACCESS_KEY?Need to set DST_ACCESS_KEY}"
: "${DST_SECRET_KEY?Need to set DST_SECRET_KEY}"
: "${DST_ENDPOINT?Need to set DST_ENDPOINT}"
: "${DST_BUCKET?Need to set DST_BUCKET}"

# Temporary credentials files
mkdir -p ~/.aws

# Configure source
cat > ~/.aws/config <<EOF
[profile src]
region = eu-central-1
output = json
s3 =
    addressing_style = path
EOF

cat > ~/.aws/credentials <<EOF
[src]
aws_access_key_id = ${SRC_ACCESS_KEY}
aws_secret_access_key = ${SRC_SECRET_KEY}

[dst]
aws_access_key_id = ${DST_ACCESS_KEY}
aws_secret_access_key = ${DST_SECRET_KEY}
EOF

# Perform sync
echo "Syncing from ${SRC_BUCKET} to ${DST_BUCKET}..."
aws s3 sync s3://${SRC_BUCKET} s3://${DST_BUCKET} \
    --profile src \
    --source-region eu-central-1 \
    --region eu-central-1 \
    --endpoint-url https://${SRC_ENDPOINT} \
    --profile dst \
    --endpoint-url https://${DST_ENDPOINT} \
    --delete \
    --exact-timestamps

echo "✅ Sync completed successfully."
