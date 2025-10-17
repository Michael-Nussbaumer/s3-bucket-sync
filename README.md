# 🪣 Multi-Cloud S3 Sync (Hetzner ↔ AWS) with Docker & rclone

Easily sync files between **Hetzner Object Storage** and **AWS S3** buckets — in either direction — using a single Docker Compose configuration.

---

## 🚀 Quick Start

### 1️⃣ Clone & prepare
```bash
git clone <your-repo>
cd <your-repo>
````

### 2️⃣ Create `.env`

Fill in credentials and endpoints for your **source** and **destination** buckets.

```env
# --- Source bucket ---
SRC_PROVIDER=AWS                # or "Other" for Hetzner
SRC_REGION=eu-central-1
SRC_ENDPOINT=https://s3.amazonaws.com
SRC_ACCESS_KEY=your-source-access-key
SRC_SECRET_KEY=your-source-secret-key
SRC_BUCKET=your-source-bucket

# --- Destination bucket ---
DST_PROVIDER=Other              # "AWS" for AWS, "Other" for Hetzner
DST_REGION=eu-central-1
DST_ENDPOINT=https://hel1.your-object-storage.cloud
DST_ACCESS_KEY=your-destination-access-key
DST_SECRET_KEY=your-destination-secret-key
DST_BUCKET=your-destination-bucket
```

> 💡 Add `.env` to `.gitignore` to keep secrets private.

---

### 3️⃣ Use the provided `docker-compose.yml`

```yaml
version: "3.8"

services:
  bucket-sync:
    image: rclone/rclone:latest
    container_name: bucket-sync
    env_file:
      - .env
    environment:
      RCLONE_CONFIG_SRC_TYPE: s3
      RCLONE_CONFIG_SRC_PROVIDER: ${SRC_PROVIDER}
      RCLONE_CONFIG_SRC_ACCESS_KEY_ID: ${SRC_ACCESS_KEY}
      RCLONE_CONFIG_SRC_SECRET_ACCESS_KEY: ${SRC_SECRET_KEY}
      RCLONE_CONFIG_SRC_REGION: ${SRC_REGION}
      RCLONE_CONFIG_SRC_ENDPOINT: ${SRC_ENDPOINT}

      RCLONE_CONFIG_DST_TYPE: s3
      RCLONE_CONFIG_DST_PROVIDER: ${DST_PROVIDER}
      RCLONE_CONFIG_DST_ACCESS_KEY_ID: ${DST_ACCESS_KEY}
      RCLONE_CONFIG_DST_SECRET_ACCESS_KEY: ${DST_SECRET_KEY}
      RCLONE_CONFIG_DST_REGION: ${DST_REGION}
      RCLONE_CONFIG_DST_ENDPOINT: ${DST_ENDPOINT}

    command: >
      sync SRC:${SRC_BUCKET} DST:${DST_BUCKET}
      --progress
      --fast-list
      --create-empty-src-dirs
      --s3-no-check-bucket
      --s3-acl private
      --delete-during
```

---

### 4️⃣ Run a one-time sync

```bash
docker compose up
```

### 5️⃣ (Optional) Schedule automatic sync

Add a cron job on the host:

```bash
0 3 * * * docker compose run --rm bucket-sync >> /var/log/bucket-sync.log 2>&1
```

→ Runs every day at **3 AM**.

---

## ✅ Features

* 🔄 **Direct cross-cloud sync** (no local temp files)
* ☁️ **AWS S3 ↔ Hetzner Object Storage** in any direction
* 🔐 Credentials managed via `.env`
* ⚡ Fast, multi-threaded transfers (`--fast-list`, `--delete-during`)
* 🧰 Uses official `rclone` image — no custom builds

---

## 🧪 Examples

| Source → Destination | Example `.env` Values                    |
| -------------------- | ---------------------------------------- |
| Hetzner → AWS        | `SRC_PROVIDER=Other`, `DST_PROVIDER=AWS` |
| AWS → Hetzner        | `SRC_PROVIDER=AWS`, `DST_PROVIDER=Other` |
| Hetzner → Hetzner    | both `Other`                             |
| AWS → AWS            | both `AWS`                               |

---

## 🧹 Cleanup

Stop and remove the container:

```bash
docker compose down
```

---

Enjoy your simple, secure, multi-cloud S3 sync! ☁️⚡