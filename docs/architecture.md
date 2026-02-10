# Architecture

This document describes the architecture of the **Secure AWS Application Deployment Platform**, focusing on infrastructure layout, traffic flow, and platform responsibilities.

The platform is designed as an **internal-only application environment**, prioritizing security, auditability, and reproducibility over public accessibility.

---

## High-Level Architecture

The system is composed of:
- AWS-managed infrastructure provisioned via Terraform
- Configuration and application lifecycle managed by Ansible
- Containerized workloads running on EC2
- Private access enforced through VPN and internal load balancing

---

## Infrastructure Overview

### AWS Resources

- VPC with private subnets
- Internal Application Load Balancer (ALB)
- EC2 instances for application workloads
- Dedicated EC2 instance for WireGuard VPN
- Amazon RDS (PostgreSQL)
- IAM roles for EC2, CI, and SSM access

All infrastructure is provisioned using Terraform modules to ensure consistency across environments.

---

## Application Runtime Architecture

### Application Nodes

- Two EC2 instances host application workloads
- Docker and Docker Compose are used to run:
  - FastAPI backend
  - React frontend
- Nginx runs on each instance as an internal reverse proxy

### Internal Routing

- Nginx performs hostname-based routing
- The internal ALB distributes traffic across EC2 instances
- No application service is directly exposed to the public internet

---

## Network & Traffic Flow

### Runtime Traffic Flow

Client
↓
WireGuard VPN
↓
Internal Application Load Balancer
↓
Nginx (Internal Reverse Proxy)
↓
FastAPI / React Containers
↓
RDS (PostgreSQL)


### Key Characteristics

- ALB is internal-only
- EC2 instances do not accept public inbound traffic
- Application access is only possible from within the VPN network

---

## Configuration Management

### Ansible Responsibilities

Ansible is responsible for configuring all EC2 instances after provisioning:

- Installing Docker and Docker Compose
- Deploying application containers
- Configuring and templating Nginx
- Running database migrations
- Installing and configuring WireGuard
- Enforcing configuration consistency using roles and templates

### Instance Access via SSM

Ansible connects to EC2 instances using **AWS Systems Manager (SSM)** instead of SSH.

- No SSH keys are used
- Port 22 is not exposed
- Access is controlled using IAM roles
- All access is logged and auditable

---

## CI/CD & Provisioning Flow

### Infrastructure Lifecycle

GitHub Actions
↓
OIDC → AWS IAM
↓
Policy Validation (Checkov)
↓
Terraform (Plan)
↓
Policy Validation (OPA)
↓
Terraform (Apply)
↓
AWS Infrastructure


### Application Lifecycle

GitHub Actions
↓
Build & Scan Containers
↓
Ansible Deployment
↓
Running Applications on EC2

---

## Design Tradeoffs

- EC2 + Ansible chosen over Kubernetes for explicit infrastructure control
- VPN-based access prioritizes security over convenience
- Separate provisioning and configuration layers improve auditability
- Internal-only design reduces attack surface significantly