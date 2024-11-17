#!/bin/bash

# Prompt the user for the proxy URL
read -p "Enter the proxy URL (e.g., http://172.28.110.43:10811): " PROXY_URL

# Create or modify Docker daemon configuration
echo "Creating Docker daemon proxy configuration..."
sudo mkdir -p /etc/systemd/system/docker.service.d
cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=$PROXY_URL/"
Environment="HTTPS_PROXY=$PROXY_URL/"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF

# Reload systemd and restart Docker
echo "Reloading systemd and restarting Docker service..."
sudo systemctl daemon-reload
sudo systemctl restart docker

# Create or modify Docker CLI configuration
echo "Creating Docker CLI proxy configuration..."
mkdir -p ~/.docker
cat <<EOF > ~/.docker/config.json
{
  "proxies": {
    "default": {
      "httpProxy": "$PROXY_URL",
      "httpsProxy": "$PROXY_URL",
      "noProxy": "localhost,127.0.0.1"
    }
  }
}
EOF

# Verify Docker daemon proxy settings
echo "Verifying Docker daemon proxy settings..."
sudo systemctl show --property=Environment docker

# Test Docker CLI proxy configuration
echo "Testing Docker CLI proxy configuration by pulling a test image..."
docker pull busybox

echo "Proxy configuration for Docker has been completed."

