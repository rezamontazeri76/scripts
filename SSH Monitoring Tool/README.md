# SSH Monitoring Tool

This tool monitors SSH login attempts and alerts via Telegram and email. It is designed to run within a Docker container using a lightweight Alpine base image.

## Features

- **Real-time Monitoring:** Monitors SSH login attempts in real time by watching the `auth.log` file.
- **Telegram Alerts:** Sends alerts to a specified Telegram bot when an SSH login is detected.
- **Email Notifications:** Sends email notifications using `swaks` for detected SSH logins.

## Requirements

- **Docker**: Ensure Docker is installed on your system.
- **Docker Compose**: Required to orchestrate the Docker container based on the provided configuration.

## Setup Instructions

```
git clone https://github.com/yourusername/ssh-monitor.git
docker-compose up --build -d

```
