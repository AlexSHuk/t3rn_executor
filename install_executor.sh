#!/bin/bash

set -e

# 1. Getting the latest version
echo "Fetching the latest version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)
EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/executor-linux-${LATEST_VERSION}.tar.gz"
EXECUTOR_WORKDIR="/opt"
SERVICE_TEMPLATE="t3rn-executor.service.template"
SERVICE_FILE="/etc/systemd/system/t3rn-executor.service"

echo "Latest version: $LATEST_VERSION"
echo "Download URL: $EXECUTOR_URL"

# 2. Downloading and extracting the binary
echo "Downloading and extracting executor..."
mkdir -p $EXECUTOR_WORKDIR
curl -L -o executor-linux-${LATEST_VERSION}.tar.gz $EXECUTOR_URL
tar -xzf executor-linux-${LATEST_VERSION}.tar.gz -C $EXECUTOR_WORKDIR
rm executor-linux-${LATEST_VERSION}.tar.gz

# 3. Searching for the binary inside the unpacked directory
EXECUTOR_BINARY=$(find "$EXECUTOR_WORKDIR" -type f -name "executor" -executable)

if [ -n "$EXECUTOR_BINARY" ]; then
    echo "Found executor binary at: $EXECUTOR_BINARY"
    chmod +x "$EXECUTOR_BINARY"
else
    echo "Error: Executor binary not found in $EXECUTOR_WORKDIR."
    exit 1
fi

# 4. Creating a service file
echo "Copying and replacing the service file..."
if [ -f "$SERVICE_TEMPLATE" ]; then
    REAL_USER=$(whoami)
    sudo sed -e "s|{{EXECUTOR_BINARY_PATH}}|$EXECUTOR_BINARY|g" \
             -e "s|{{EXECUTOR_WORKDIR}}|$EXECUTOR_WORKDIR|g" \
             -e "s|\$(whoami)|$REAL_USER|g" \
             "$SERVICE_TEMPLATE" > "$SERVICE_FILE"
    echo "Service file replaced successfully."
else
    echo "Error: Service template not found ($SERVICE_TEMPLATE)."
    exit 1
fi
# 5. Restart systemd and start the service
echo "Reloading systemd and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable t3rn-executor.service
sudo systemctl start t3rn-executor.service

# 6. Checking status and logs
echo "Checking service status and logs..."
sudo systemctl status t3rn-executor.service
sudo journalctl -u t3rn-executor -f -o cat
echo "Installation completed. The executor is running as a service."