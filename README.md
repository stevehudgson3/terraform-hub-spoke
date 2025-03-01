# Terraform Hub-and-Spoke Infrastructure

## 📌 Overview
This project is designed to help master **Terraform** and **Cloud Infrastructure** by deploying a **Hub-and-Spoke architecture** in AWS. It provides hands-on experience with networking concepts such as **VPCs, Subnets, Transit Gateway, and EC2 instances**.

## 🏗️ Architecture Components
The Terraform configuration deploys the following components:

### **1️⃣ Hub VPC**
- Acts as the **central networking hub**.
- Contains a **subnet** for shared resources.
- Connects to Spoke VPCs using **AWS Transit Gateway**.

### **2️⃣ Spoke VPCs**
- Two separate VPCs (`Spoke 1` and `Spoke 2`).
- These are **isolated networks** that connect only via the hub.
- Each spoke can represent different application environments (e.g., dev, prod).

### **3️⃣ AWS Transit Gateway (TGW)**
- Connects the **Hub and Spoke VPCs**, allowing communication between them.
- Acts as a central routing mechanism.

### **4️⃣ EC2 Instances (Optional)**
- Deployable inside **Spoke VPCs** for testing connectivity.
- Can be used to simulate application workloads.

### **5️⃣ Security Groups**
- Controls access to instances via SSH (port 22).
- Restricts inbound and outbound traffic as needed.

## 🚀 How to Deploy
Follow these steps to deploy the Hub-and-Spoke infrastructure using Terraform.

### **Prerequisites**
- **AWS CLI** installed & configured with access credentials.
- **Terraform** installed (`>=1.0.0`).
- **Git** installed (for version control).

### **Steps to Deploy**
1. **Clone the Repository**
   ```sh
   git clone https://github.com/stevehudgson3/terraform-hub-spoke.git
   cd terraform-hub-spoke
   ```
2. **Initialize Terraform**
   ```sh
   terraform init
   ```
3. **Plan the Deployment**
   ```sh
   terraform plan
   ```
4. **Apply the Configuration**
   ```sh
   terraform apply -auto-approve
   ```
5. **Verify Outputs**
   ```sh
   terraform output
   ```

## 📂 Project Structure
```
terraform-hub-spoke/
├── main.tf          # Defines the Hub-Spoke architecture
├── variables.tf     # Stores configurable parameters
├── outputs.tf       # Displays useful Terraform outputs
├── .gitignore       # Ignores unnecessary files (e.g., Terraform cache, state files)
├── README.md        # Documentation for the project
```

## 🔥 Next Steps
- **Extend the architecture** by adding a **Bastion Host** for secure SSH access.
- **Deploy RKE2 (Kubernetes)** inside Spoke VPCs.
- **Use AWS Systems Manager (SSM)** instead of SSH for instance access.

## 🛑 Cleanup
To **destroy** the infrastructure when done:
```sh
terraform destroy -auto-approve
```

## 📌 Resources
- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Transit Gateway Overview](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html)

---
🚀 **Happy Terraforming!** 🚀

