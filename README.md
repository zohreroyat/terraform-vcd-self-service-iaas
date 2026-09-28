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
              │  │        Routed Network        │  │
              │  └──────────────┬───────────────┘  │
              │                 │                  │
              │                 ▼                  │
              │  ┌──────────────────────────────┐  │
              │  │          vApp + VM            │  │
              │  └──────────────────────────────┘  │
              └────────────────────────────────────┘
```

### 🌐 Network Flow

```text
┌──────────────────────┐
│ Provider / External  │
│       Network        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│        NSX-T         │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│    Edge Gateway      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Tenant Routed      │
│       Network        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│      Tenant VM       │
└──────────────────────┘
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

## 🧑‍💻 Self-Service Request

The request is intentionally kept simple.

The requester does **not** need to know the underlying VMware Cloud Director infrastructure configuration.

### Required Inputs

```text
tenant_name
network_prefix_length
vm_flavor
```

### Example Request

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

This provides a controlled and repeatable resource allocation model.

---

## 🔄 Provisioning Workflow

The complete workflow is:

```text
┌─────────────────┐
│  Tenant Request │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Terraform    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Organization   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Organization VDC│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ NSX-T Edge GW   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    IP Prefix    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Routed Network  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│      vApp       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│       VM        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Additional Disk │
└─────────────────┘
```

### 1️⃣ Organization Provisioning

Terraform creates a dedicated VMware Cloud Director Organization using the requested tenant name.

Example:

```text
Tenant Request
      │
      ▼
tenant_name = demo
      │
      ▼
Organization
      │
      ▼
demo
```

---

### 2️⃣ Organization VDC

An Organization VDC is created and associated with the configured:

- Provider VDC
- Network Pool
- Storage Policy
- Compute Capacity

The Organization VDC provides the resource boundary for the tenant environment.

---

### 3️⃣ 🌐 Network Provisioning

The tenant networking workflow consists of:

```text
NSX-T Edge Gateway
        │
        ▼
    IP Prefix
        │
        ▼
  Routed Network
        │
        ▼
      VM NIC
```

The network prefix is selected by the requester.

Example:

```hcl
network_prefix_length = 28
```

This results in a tenant `/28` network allocation.

---

### 4️⃣ 🖥️ Workload Provisioning

Terraform creates a vApp and deploys the initial VM from the configured Cloud Director catalog template.

The VM is automatically connected to the tenant routed network.

The VM name follows the tenant naming convention:

```text
<tenant_name>-vm-1
```

Example:

```text
demo-vm-1
```

---

### 5️⃣ 💾 Storage Provisioning

An additional VM disk is created based on the selected VM flavor.

Example:

```text
Flavor 1
   │
   ├── 4 vCPU
   ├── 8 GB RAM
   └── 10 GB Additional Disk
```

---

# 🧰 Technologies & Tools

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| VMware Cloud Director | Cloud / IaaS platform |
| VMware NSX-T | Network virtualization |
| VMware Cloud Director Terraform Provider | Terraform integration |
| HCL | Infrastructure configuration |

---

# 📋 Requirements

Before running the project, the target VMware Cloud Director environment should already have the required infrastructure components configured.

## 💻 Software Requirements

- Terraform
- VMware Cloud Director Terraform Provider `3.14+`
- Access to VMware Cloud Director API

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

> ⚠️ **Never commit the real `terraform.tfvars` file to GitHub.**

---

## 3️⃣ Initialize Terraform

```bash
terraform init
```

Terraform initializes the working directory and the required provider.

---

## 4️⃣ Format the Configuration

```bash
terraform fmt
```

---

## 5️⃣ Validate the Configuration

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

## 6️⃣ 🔍 Review the Terraform Plan

```bash
terraform plan
```

Review the resources that Terraform intends to create before applying the configuration.

---

## 7️⃣ 🚀 Deploy the Environment

Run:

```bash
terraform apply
```

Or for automated execution:

```bash
terraform apply -auto-approve
```

---

# 📤 Terraform Outputs

After deployment:

```bash
terraform output
```

The project exposes information such as:

```text
Organization Name
Organization VDC Name
VM Name
VM IP Address
```

---

# 🔐 Security Considerations

Security is an important part of Infrastructure as Code projects.

The following files should **never** be committed to a public repository:

```text
terraform.tfvars
*.tfstate
*.tfstate.*
*.tfplan
.env
*.pem
*.key
```

The repository `.gitignore` is configured to exclude these types of files.

### ❌ Never Commit

```text
Passwords
API Tokens
Private Keys
Certificates
Terraform State
Credentials
```

### ✅ Recommended Approach

Use environment variables or a secure secret management solution for credentials in production environments.

---

# 🔒 TLS / SSL

The provider configuration may contain:

```hcl
allow_unverified_ssl = true
```

This is intended for controlled lab or demonstration environments where the Terraform host does not trust the VMware Cloud Director certificate.

For production environments:

```text
Use trusted TLS certificates
        │
        ▼
Enable certificate validation
        │
        ▼
Avoid allow_unverified_ssl
```

---

# 🗄️ Terraform State

Terraform state is required to track managed resources.

For development and demonstration purposes, local state can be used.

For production environments, a secure remote backend is recommended.

Examples include:

- S3-compatible backend
- Terraform Cloud
- Terraform Enterprise
- Secure object storage

Terraform state should **never** be committed to GitHub.

---

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

---

# 🧩 Configuration Model

The project separates:

### 👤 User Inputs

```text
tenant_name
network_prefix_length
vm_flavor
```

from:

### 🏗️ Infrastructure Configuration

```text
Provider VDC
Network Pool
Storage Policy
External Network
IP Space
Catalog
VM Template
```

This separation keeps the self-service request simple while keeping infrastructure-specific settings under administrator control.

---

# 🎯 Design Goals

The project focuses on the following principles.

### ⚡ Automation

Reduce repetitive manual provisioning tasks.

### 🔁 Repeatability

Create environments using a consistent Terraform workflow.

### 🧱 Isolation

Maintain tenant separation using VMware Cloud Director Organizations and Organization VDCs.

### 🌐 Network Automation

Automate tenant network creation using NSX-T-backed networking.

### 🛠️ Infrastructure as Code

Keep infrastructure configuration version-controlled and reproducible.

### 👤 Self-Service

Expose only the parameters required by the requester instead of infrastructure-level configuration.

---

# 📌 Current Scope

The current implementation includes:

- ✅ Tenant Organization provisioning
- ✅ Organization VDC provisioning
- ✅ NSX-T Edge Gateway provisioning
- ✅ Tenant IP Prefix allocation
- ✅ Routed Network provisioning
- ✅ vApp provisioning
- ✅ Initial VM deployment
- ✅ VM flavor selection
- ✅ Additional VM disk provisioning
- ✅ Terraform-based automation
- ✅ Input validation

---

# 🔮 Future Improvements

The project can be extended with additional capabilities:

```text
┌─────────────────────────────────────┐
│         Future Improvements         │
├─────────────────────────────────────┤
│ • Remote Terraform Backend          │
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

# 🎥 Demo

A technical demonstration can show the complete provisioning workflow:

```text
User Request
     │
     ▼
Terraform Plan
     │
     ▼
Terraform Apply
     │
     ▼
Cloud Director Organization
     │
     ▼
Organization VDC
     │
     ▼
NSX-T Network
     │
     ▼
vApp
     │
     ▼
VM
     │
     ▼
Final IaaS Environment
```

---

# 📊 Example

## Input

```hcl
tenant_name           = "demo"
network_prefix_length = 28
vm_flavor             = 1
```

## Result

```text
                    demo
                     │
                     ▼
              ┌───────────────┐
              │ Organization  │
              │     demo      │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │    demo-vdc   │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │   demo-edge   │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │ demo-routed-  │
              │     net       │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │   demo-vm-1   │
              │               │
              │   4 vCPU      │
              │   8 GB RAM    │
              │   10 GB Disk  │
              └───────────────┘
```

---

# 📚 References

- VMware Cloud Director
- VMware NSX-T
- Terraform
- VMware Cloud Director Terraform Provider
- Infrastructure as Code

---

# 🔗 Repository

**GitHub Repository:**

https://github.com/zohreroyat/terraform-vcd-self-service-iaas

---

# 📄 Disclaimer

This repository is a technical demonstration and reference implementation.

Environment-specific values such as:

- Provider VDC
- Network Pool
- Storage Policy
- External Network
- IP Space
- Catalog
- VM Template

must be adapted to the target VMware Cloud Director environment.

Always review the Terraform plan before applying changes to a production environment.

---

# ⭐ Project

If you find this project useful for learning or implementing VMware Cloud Director Infrastructure as Code, feel free to explore the repository and adapt it to your environment.

**Infrastructure as Code → Automation → Self-Service → IaaS**
