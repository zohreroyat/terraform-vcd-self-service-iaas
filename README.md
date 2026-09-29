# 🚀 VMware Cloud Director Self-Service IaaS

A Terraform-based solution for automating tenant-oriented IaaS provisioning on **VMware Cloud Director** with **NSX-T networking**.

This project demonstrates how **Infrastructure as Code (IaC)** can transform a simple tenant request into a repeatable and automated VMware Cloud Director provisioning workflow.

---

## 🎯 Project Overview

The goal of this project is to simplify the provisioning of isolated tenant environments in VMware Cloud Director.

Instead of manually creating:

- Organization
- Organization VDC
- NSX-T Edge Gateway
- Tenant Network
- vApp
- Virtual Machine
- Additional Storage

Terraform automates the complete provisioning workflow.

The requester only needs to provide a few parameters:

| Parameter | Description |
|---|---|
| `tenant_name` | Name of the tenant organization |
| `network_prefix_length` | Tenant network size |
| `vm_flavor` | Predefined VM resource profile |

Terraform then creates the required VMware Cloud Director resources based on the requested configuration.

---

## 🏗️ Architecture

The overall provisioning workflow is:

```text
                         ┌──────────────────┐
                         │   User Request   │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │    Terraform     │
                         │      IaC         │
                         └────────┬─────────┘
                                  │
                                  ▼
              ┌────────────────────────────────────┐
              │       VMware Cloud Director        │
              │                                    │
              │  ┌──────────────────────────────┐  │
              │  │        Organization          │  │
              │  └──────────────┬───────────────┘  │
              │                 │                  │
              │                 ▼                  │
              │  ┌──────────────────────────────┐  │
              │  │      Organization VDC        │  │
              │  └──────────────┬───────────────┘  │
              │                 │                  │
              │                 ▼                  │
              │  ┌──────────────────────────────┐  │
              │  │      NSX-T Edge Gateway      │  │
              │  └──────────────┬───────────────┘  │
              │                 │                  │
              │                 ▼                  │
              │  ┌──────────────────────────────┐  │
              │  │   IP Prefix / Routed Network │  │
              │  └──────────────┬───────────────┘  │
              │                 │                  │
              │                 ▼                  │
              │  ┌──────────────────────────────┐  │
              │  │          vApp + VM           │  │
              │  └──────────────────────────────┘  │
              └────────────────────────────────────┘
```
---

## ⚙️ What Does This Project Automate?

Terraform provisions the following resources:

```text
Organization
     │
     ├── Organization VDC
     │
     ├── NSX-T Edge Gateway
     │
     ├── Tenant IP Prefix
     │
     ├── Routed Organization Network
     │
     ├── vApp
     │
     ├── Virtual Machine
     │
     └── Additional VM Disk
```

### 📦 Provisioned Resources

| Resource | Purpose |
|---|---|
| Organization | Isolated tenant boundary |
| Organization VDC | Compute, storage and network resource container |
| NSX-T Edge Gateway | Tenant network connectivity |
| IP Prefix | Tenant network address allocation |
| Routed Network | Tenant workload network |
| vApp | VM container |
| Virtual Machine | Initial tenant workload |
| Additional Disk | Additional VM storage |

---

```text
┌─────────────────────────────────────┐
│        Self-Service Request         │
├─────────────────────────────────────┤
│ Tenant Name       : demo            │
│ Network Prefix    : /28             │
│ VM Flavor         : 1               │
└─────────────────────────────────────┘
```

Terraform translates this request into the required infrastructure.

---

## 💻 VM Flavors

The project currently provides three predefined VM resource profiles.

| Flavor | vCPU | Memory | Additional Disk |
|---|---:|---:|---:|
| 1 | 4 | 8 GB | 10 GB |
| 2 | 8 | 16 GB | 12 GB |
| 3 | 8 | 32 GB | 15 GB |

The requester selects a predefined flavor instead of directly modifying the underlying infrastructure configuration.

# 🧰 Technologies & Tools

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| VMware Cloud Director | Cloud / IaaS platform |
| VMware NSX-T | Network virtualization |
| VMware Cloud Director Terraform Provider | Terraform integration |
| HCL | Infrastructure configuration |

---

## ☁️ VMware Cloud Director Requirements

The environment should provide:

- Provider VDC
- Network Pool
- Storage Policy
- External / Provider Network
- IP Space
- Organization-accessible Catalog
- VM Template

Environment-specific resource names are configured in:

```text
locals.tf
```
---

# 📁 Project Structure

```text
terraform-vcd-self-service-iaas/
│
├── .gitignore
├── .terraform.lock.hcl
├── README.md
│
├── data.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── versions.tf
│
└── terraform.tfvars.example
```

## 📝 Terraform Files

| File | Description |
|---|---|
| `main.tf` | Main VMware Cloud Director resources |
| `data.tf` | Existing Cloud Director resources |
| `locals.tf` | Environment configuration and VM flavors |
| `variables.tf` | User inputs and validation |
| `outputs.tf` | Terraform outputs |
| `providers.tf` | VMware Cloud Director provider configuration |
| `versions.tf` | Terraform and provider version requirements |
| `terraform.tfvars.example` | Example configuration |
| `.terraform.lock.hcl` | Provider version and checksum lock information |
| `.gitignore` | Prevents secrets and local files from being committed |

---
### Example Request
# 🎥 Demo

https://youtu.be/_IopcbK-_tk?si=ZUozagXIsSdsiZfO
---

# 🚀 Getting Started

## 1️⃣ Clone the Repository
```bash
git clone https://github.com/zohreroyat/terraform-vcd-self-service-iaas.git
cd terraform-vcd-self-service-iaas
```
---
## 2️⃣ Prepare Terraform Variables
Create a local variables file from the example:
```bash
cp terraform.tfvars.example terraform.tfvars
```
Edit:

```text
terraform.tfvars
```

Example:

```hcl
vcd_url      = "https://vcd.example.com/api"
vcd_org      = "System"
vcd_user     = "YOUR_VCD_USERNAME"
vcd_password = "YOUR_VCD_PASSWORD"

tenant_name           = "demo"
network_prefix_length = 28
vm_flavor             = 1
```
---
## 3️⃣ 🚀 Deploy the Environment

```bash
terraform init
terraform validate
terraform plan
terraform apply
or
terraform apply -auto-approve

```

# 🏢 Multi-Tenant Design

The architecture is designed around isolated tenant environments.

Conceptually:

```text
                    VMware Cloud Director
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
      Tenant A          Tenant B          Tenant C
          │                 │                 │
          ▼                 ▼                 ▼
     Organization      Organization      Organization
          │                 │                 │
          ▼                 ▼                 ▼
       Org VDC           Org VDC           Org VDC
          │                 │                 │
          ▼                 ▼                 ▼
       Network           Network           Network
          │                 │                 │
          ▼                 ▼                 ▼
         VM                VM                VM
```

Each tenant can have its own:

- Organization
- Organization VDC
- Network
- Edge Gateway
- Workloads

# 🔮 Future Improvements

The project can be extended with additional capabilities:

```text
┌─────────────────────────────────────┐
│         Future Improvements         │
├─────────────────────────────────────┤
│ • Remove Hardcoded Values           │
│ • Improve VM Flavor Configuration   | 
| • Remote Terraform Backend          │
│ • Public IP Automation              │
│ • Additional VM Flavors             │
│ • Additional Storage Profiles       │
│ • Load Balancer Provisioning        │
│ • Firewall Automation               │
│ • NAT Automation                    │
│ • Reusable Terraform Modules        │
│ • CI/CD Pipeline                    │
│ • Automated Quota Management        │
│ • Self-Service Portal Integration   │
│ • VMware Automation Integration     │
└─────────────────────────────────────┘
```
---

must be adapted to the target VMware Cloud Director environment.

Always review the Terraform plan before applying changes to a production environment.

---

# ⭐ Project

If you find this project useful for learning or implementing VMware Cloud Director Infrastructure as Code, feel free to explore the repository and adapt it to your environment.

**Infrastructure as Code → Automation → Self-Service → IaaS**
