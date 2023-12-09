#!/bin/bash

source .env

count=0
while true; do
    terraform apply -auto-approve

    if [ $? -eq 0 ]; then
        echo "Terraform apply successful. Exiting loop."
        break
    else
        count=$((count + 1))
        echo "$count Terraform apply failed. Retrying in 30 seconds..."
        sleep 30
    fi
done
