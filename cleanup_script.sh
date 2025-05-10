#!/bin/bash
# Script to clean up all resources created in the Google Cloud VPC Lab

# Exit on error
set -e

# Set variables (these should match the values in setup.sh)
PROJECT_ID=$(gcloud config get-value project)
NETWORK_NAME="mynetwork"
REGION1="us-central1"
ZONE1="us-central1-a"
REGION2="europe-west1"
ZONE2="europe-west1-b"
VM1_NAME="mynet-us-vm"
VM2_NAME="mynet-r2-vm"

echo "Cleaning up resources on project: $PROJECT_ID"

# Confirm the project is set correctly
echo "Using project: $PROJECT_ID"
echo "If this is not the correct project, press Ctrl+C and then run: gcloud config set project YOUR-PROJECT-ID"
echo "Continuing in 5 seconds..."
sleep 5

# Delete VM instances
echo "Deleting VM instances..."
gcloud compute instances delete $VM1_NAME --zone=$ZONE1 --quiet --project=$PROJECT_ID || true
gcloud compute instances delete $VM2_NAME --zone=$ZONE2 --quiet --project=$PROJECT_ID || true

# Delete firewall rules
echo "Deleting firewall rules..."
gcloud compute firewall-rules delete \
  ${NETWORK_NAME}-allow-icmp \
  ${NETWORK_NAME}-allow-ssh \
  ${NETWORK_NAME}-allow-rdp \
  ${NETWORK_NAME}-allow-custom \
  --quiet --project=$PROJECT_ID || true

# Delete the VPC network
echo "Deleting VPC network: $NETWORK_NAME..."
gcloud compute networks delete $NETWORK_NAME --quiet --project=$PROJECT_ID || true

echo "Cleanup complete! All resources have been removed."
