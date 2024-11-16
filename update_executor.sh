#!/bin/bash

set -e

# 1. Variables
EXECUTOR_WORKDIR="/opt"
SERVICE_NAME="t3rn-executor.service"
LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)
EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/executor-linux-${LATEST_VERSION}.tar.gz"

echo "Updating t3rn Executor to version $LATEST_VERSION..."

# 2. Stop the service
echo "Stopping the $SERVICE_NAME..."
sudo systemctl stop "$SERVICE_NAME"

# 3. Download the latest version
echo "Downloading the latest version..."
curl -L -o executor-linux-${LATEST_VERSION}.tar.gz $EXECUTOR_URL

# 4. Extract and replace the binary
echo "Extracting and replacing the binary..."
tar -xzf executor-linux-${LATEST_VERSION}.tar.gz -C "$EXECUTOR_WORKDIR"
rm executor-linux-${LATEST_VERSION}.tar.gz

# Find the new binary
EXECUTOR_BINARY=$(find "$EXECUTOR_WORKDIR" -type f -name "executor" -executable)

if [ -n "$EXECUTOR_BINARY" ]; then
    echo "Found executor binary at: $EXECUTOR_BINARY"
    chmod +x "$EXECUTOR_BINARY"
else
    echo "Error: Executor binary not found after extraction."
    exit 1
fi

# 5. Restart the service
echo "Reloading and restarting the $SERVICE_NAME..."
sudo systemctl daemon-reload
sudo systemctl restart "$SERVICE_NAME"

# 6. Check the status
echo "Checking the service status..."
sudo systemctl status "$SERVICE_NAME"

echo "Update completed successfully!"
