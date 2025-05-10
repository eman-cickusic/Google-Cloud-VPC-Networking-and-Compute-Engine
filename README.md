# Google Cloud VPC Networking and Compute Engine Lab

This repository documents a hands-on lab exploring Google Cloud Virtual Private Cloud (VPC) networking and Compute Engine. The lab demonstrates how to create and configure VPC networks, manage firewall rules, and establish VM instances across different regions.

## Overview

Google Cloud VPC provides networking functionality to various Google Cloud services, including Compute Engine VM instances. This lab explores how VPC networks function as virtualized networks within Google Cloud, providing logically isolated environments for your resources.

## Objectives

- Explore the default VPC network
- Create an auto mode network with custom firewall rules
- Create VM instances across different regions
- Test and verify network connectivity between VM instances
- Understand how firewall rules affect connectivity

## Video

https://youtu.be/5W1Nrw-mZTs?si=p9T9IkZHYvH1qF5p


## Lab Steps

### Task 1: Explore the Default Network

The lab begins by examining the default VPC network that comes with every Google Cloud project:
- Viewing subnets automatically created across different regions
- Exploring routes configured for the network
- Reviewing default firewall rules
- Deleting the default network to understand its importance

### Task 2: Create a VPC Network and VM Instances

After deleting the default network, we:
- Create a new auto mode VPC network called `mynetwork`
- Configure firewall rules for the network
- Create VM instances in different regions connected to this network

### Task 3: Test Connectivity Between VM Instances

Finally, we explore how connectivity works between VM instances:
- Test SSH connectivity using the `allow-ssh` firewall rule
- Verify ICMP connectivity (ping) between instances
- Systematically remove firewall rules to observe how connectivity changes
- Understand the relationship between firewall rules and networking permissions

## Key Concepts Learned

- VPC networks are global resources that consist of regional subnets
- Firewall rules control what traffic can flow between resources
- Without a VPC network, you cannot create VM instances
- Connectivity between VM instances depends on properly configured firewall rules
- Auto mode networks automatically create subnets in each region


## Requirements

- Google Cloud account with billing enabled
- Basic understanding of networking concepts
- Familiarity with Google Cloud Console

## Resources

- [Google Cloud VPC Documentation](https://cloud.google.com/vpc/docs)
- [Google Compute Engine Documentation](https://cloud.google.com/compute/docs)
- [Google Cloud Firewall Rules](https://cloud.google.com/vpc/docs/firewalls)

## Author

Add your name here

## License

This project is licensed under the MIT License - see the LICENSE file for details.
