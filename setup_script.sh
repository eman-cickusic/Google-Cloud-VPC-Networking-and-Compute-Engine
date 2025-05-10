#!/bin/bash
# Script to set up the VPC Network and VM instances for the Google Cloud VPC Lab

# Exit on error
set -e

# Set variables (change these according to your preferences)
PROJECT_ID=$(gcloud config get-value project)
NETWORK_NAME="mynetwork"
REGION1="us-central1"
ZONE1="us-central1-a"
REGION2="europe-west1"
ZONE2="europe-west1-b"
VM1_NAME="mynet-us-vm"
VM2_NAME="mynet-r2-vm"
MACHINE_TYPE="e2-micro"

echo "Setting up VPC Networking Lab on project: $PROJECT_ID"

# Confirm the project is set correctly
echo "Using project: $PROJECT_ID"
echo "If this is not the correct project, press Ctrl+C and then run: gcloud config set project YOUR-PROJECT-ID"
echo "Continuing in 5 seconds..."
sleep 5

# Check if default network exists and delete it
echo "Checking for default network..."
if gcloud compute networks describe default --project=$PROJECT_ID &>/dev/null; then
  echo "Deleting default firewall rules..."
  gcloud compute firewall-rules delete \
    default-allow-icmp default-allow-internal default-allow-rdp default-allow-ssh \
    --quiet --project=$PROJECT_ID || true
  
  echo "Deleting default network..."
  gcloud compute networks delete default --quiet --project=$PROJECT_ID
  echo "Default network deleted."
else
  echo "Default network not found or already deleted."
fi

# Create a new auto mode VPC network
echo "Creating auto mode VPC network: $NETWORK_NAME..."
gcloud compute networks create $NETWORK_NAME \
  --subnet-mode=auto \
  --project=$PROJECT_ID

# Create firewall rules
echo "Creating firewall rules..."
gcloud compute firewall-rules create ${NETWORK_NAME}-allow-icmp \
  --network=$NETWORK_NAME \
  --allow=icmp \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create ${NETWORK_NAME}-allow-ssh \
  --network=$NETWORK_NAME \
  --allow=tcp:22 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create ${NETWORK_NAME}-allow-rdp \
  --network=$NETWORK_NAME \
  --allow=tcp:3389 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create ${NETWORK_NAME}-allow-custom \
  --network=$NETWORK_NAME \
  --allow=tcp:0-65535,udp:0-65535,icmp \
  --source-ranges=10.0.0.0/8 \
  --project=$PROJECT_ID

# Create VM in Region 1
echo "Creating VM in $REGION1: $VM1_NAME..."
gcloud compute instances create $VM1_NAME \
  --zone=$ZONE1 \
  --machine-type=$MACHINE_TYPE \
  --network=$NETWORK_NAME \
  --project=$PROJECT_ID

# Create VM in Region 2
echo "Creating VM in $REGION2: $VM2_NAME..."
gcloud compute instances create $VM2_NAME \
  --zone=$ZONE2 \
  --machine-type=$MACHINE_TYPE \
  --network=$NETWORK_NAME \
  --project=$PROJECT_ID

echo "Setup complete!"
echo ""
echo "VM1 ($VM1_NAME) external IP: $(gcloud compute instances describe $VM1_NAME --zone=$ZONE1 --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --project=$PROJECT_ID)"
echo "VM1 ($VM1_NAME) internal IP: $(gcloud compute instances describe $VM1_NAME --zone=$ZONE1 --format='get(networkInterfaces[0].networkIP)' --project=$PROJECT_ID)"
echo ""
echo "VM2 ($VM2_NAME) external IP: $(gcloud compute instances describe $VM2_NAME --zone=$ZONE2 --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --project=$PROJECT_ID)"
echo "VM2 ($VM2_NAME) internal IP: $(gcloud compute instances describe $VM2_NAME --zone=$ZONE2 --format='get(networkInterfaces[0].networkIP)' --project=$PROJECT_ID)"
echo ""
echo "To SSH into VM1, run: gcloud compute ssh $VM1_NAME --zone=$ZONE1 --project=$PROJECT_ID"
echo "To SSH into VM2, run: gcloud compute ssh $VM2_NAME --zone=$ZONE2 --project=$PROJECT_ID"
