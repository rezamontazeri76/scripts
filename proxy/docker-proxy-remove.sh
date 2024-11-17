#!/bin/bash

# Script to remove Docker proxy configuration

# Function to remove proxy configuration
remove_proxy_config() {
    # Define the proxy configuration file paths
    PROXY_CONF="/etc/systemd/system/docker.service.d/http-proxy.conf"
    DAEMON_JSON="/etc/docker/daemon.json"

    # Check and remove the proxy configuration file
    if [[ -f "$PROXY_CONF" ]]; then
        echo "Removing Docker proxy configuration from $PROXY_CONF..."
        sudo rm -f "$PROXY_CONF"
    else
        echo "No proxy configuration found at $PROXY_CONF."
    fi

    # Check and remove the proxy settings from daemon.json
    if [[ -f "$DAEMON_JSON" ]]; then
        echo "Removing proxy configuration from $DAEMON_JSON..."
        sudo sed -i '/"httpProxy"/d' "$DAEMON_JSON"
        sudo sed -i '/"httpsProxy"/d' "$DAEMON_JSON"
        sudo sed -i '/"noProxy"/d' "$DAEMON_JSON"

        # Check if the file is empty after deletion
        if [[ ! -s "$DAEMON_JSON" ]]; then
            echo "$DAEMON_JSON is empty. Removing it..."
            sudo rm -f "$DAEMON_JSON"
        fi
    else
        echo "No daemon.json file found at $DAEMON_JSON."
    fi

    # Reload systemd daemon and restart Docker service
    echo "Reloading systemd daemon and restarting Docker service..."
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    echo "Docker proxy configuration removed and service restarted."
}

# Execute the function
remove_proxy_config
