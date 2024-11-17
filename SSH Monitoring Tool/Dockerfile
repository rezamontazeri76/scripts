# Use an official Alpine base image
FROM alpine:3.16

# Install necessary packages
RUN apk update && \
    apk add --no-cache inotify-tools swaks curl bash && \
    rm -rf /var/cache/apk/*

# Copy the script into the container and set permissions
COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

# Set the entry point to the script
ENTRYPOINT ["/usr/local/bin/script.sh"]
