# VMware Cloud Director Self-Service IaaS

Terraform-based self-service IaaS platform for
VMware Cloud Director with NSX-T networking.

## Architecture

User
   │
Terraform
   │
Cloud Director
   │
 ├── Org
 ├── Org VDC
 ├── Edge Gateway
 ├── Routed Network
 ├── vApp
 ├── VM
 └── Extra Disk
 # VMware Cloud Director Self-Service IaaS

Terraform project for automatic provisioning of:

- Organization
- Org VDC
- NSX-T Edge Gateway
- Routed Network
- vApp
- Virtual Machine
- Additional Disk

## Requirements

- Terraform
- VMware Cloud Director
- VMware Cloud Director Provider
