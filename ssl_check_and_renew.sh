#!/bin/bash

# Prompt user to enter the domain name
read -p "Enter the domain name: " yourdomain

# Step 1: Get the expiration date of the SSL certificate
end_date=$(echo | openssl s_client -connect "$yourdomain":443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)

# Step 2: Convert the expiration date to YYYY-MM-DD format
end_date_formatted=$(date -d "$end_date" +"%Y-%m-%d")

# Step 3: Get the current date in YYYY-MM-DD format
current_date=$(date +"%Y-%m-%d")

# Step 4: Calculate the number of days left until expiration
days_left=$(( ( $(date -ud "$end_date_formatted" +'%s') - $(date -ud "$current_date" +'%s') ) / 86400 ))

# Step 5: Display the result
echo "Days left until SSL certificate expires: $days_left"

# Define the destination path
dest_dir="/etc/nginx/ssl-certificates"
cert_dir="/etc/letsencrypt/live/$yourdomain"
cert_file="$cert_dir/fullchain.pem"
key_file="$cert_dir/privkey.pem"

# Step 6: Check if the SSL certificate is about to expire
if [ "$days_left" -lt 2 ]; then
  echo "Less than 2 days left until SSL certificate expires!"
  
  # Check if SSL certificate already exists
  if [ -f "$cert_file" ] && [ -f "$key_file" ]; then
    echo "SSL certificate already exists. Renewing..."
    sudo certbot renew --nginx --non-interactive --agree-tos
  else
    echo "SSL certificate does not exist. Generating new certificate..."
    sudo certbot --nginx -d "$yourdomain" -d "www.$yourdomain" --non-interactive --agree-tos --email your-email@example.com
  fi

  # Create the destination directory if it doesn't exist
  sudo mkdir -p "$dest_dir" &> /dev/null
  
  # Convert and rename the certificates to .crt and .key format
  sudo cp "$cert_file" "$dest_dir/${yourdomain}.crt" &> /dev/null
  sudo cp "$key_file" "$dest_dir/${yourdomain}.key" &> /dev/null
  
  echo "Certificates have been copied and renamed to $dest_dir as ${yourdomain}.crt and ${yourdomain}.key"
else
  echo "Days left until SSL certificate expires: $days_left"
fi
