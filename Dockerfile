FROM amazon/aws-cli:2.17.24

# Optional: set a working directory
WORKDIR /app

# Copy your sync script (defined below)
COPY sync.sh /app/sync.sh
RUN chmod +x /app/sync.sh

ENTRYPOINT ["/app/sync.sh"]
