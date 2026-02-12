# Secure AWS Application Deployment with Ansible, WireGuard, Nginx, and Policy as Code

A production-grade internal application platform deployed on AWS EC2 using Terraform and Ansible, with strong emphasis on network isolation, zero-trust access, and policy-as-code enforcement across infrastructure and CI.

The platform runs a FastAPI backend and React frontend in Docker containers across multiple EC2 instances, fronted by an internal load balancer and accessible **only through a WireGuard VPN**.

---

## Overview

Modern internal platforms must be secure by default, auditable, and fully automated.

This project demonstrates how to build a **locked-down internal application platform on AWS**, where:
- No application is publicly exposed
- Infrastructure changes are policy-validated
- CI pipelines use short-lived credentials
- Configuration management is reproducible and idempotent

It mirrors real-world enterprise patterns for internal tooling, admin platforms, and private services.

---

## Key Features

- Internal-only application access via WireGuard VPN
- Infrastructure provisioning using Terraform
- Configuration management with Ansible (roles & templates)
- Containerized workloads using Docker and Docker Compose
- Internal load balancing with Nginx
- Policy as Code enforcement for IaC and CI
- Secure CI using GitHub OIDC

---

## Architecture Overview

### High-Level Flow

```

Developer
↓
GitHub Actions (OIDC)
↓
Terraform + Policy Checks
↓
AWS Infrastructure (VPC, EC2, ALB, RDS)
↓
Ansible Configuration
↓
Dockerized Applications on EC2

```

### Runtime Traffic Flow

```

Client
↓
WireGuard VPN
↓
Internal Application Load Balancer
↓
Nginx (Internal Routing)
↓
FastAPI / React Containers
↓
RDS (PostgreSQL)

```

---

## Infrastructure & Platform Components

### Networking & Access Control
- Applications are deployed behind an **internal Application Load Balancer**
- No public ingress to application EC2 instances
- Access is restricted to users connected via **WireGuard VPN**
- WireGuard runs on a dedicated EC2 instance

### Application Runtime
- FastAPI backend and React frontend run in Docker containers
- Two EC2 instances host application workloads
- Nginx acts as an internal reverse proxy and load balancer
- Hostname-based routing is used for services

### Configuration Management (Ansible)
Ansible is used to:
- Install Docker and Docker Compose on EC2 instances
- Deploy and manage application containers
- Configure Nginx with templated configs
- Run database migrations from EC2 instances
- Set up WireGuard server and generate client keys
- Enforce consistency using roles and templates

Ansible communicates with EC2 instances using AWS Systems Manager (SSM) instead of SSH. 
This allows configuration management without opening inbound management ports or distributing SSH keys.

Connections are authenticated using IAM roles attached to the EC2 instances.

---

## Security Model

### CI/CD Security
- GitHub Actions uses **OIDC to assume AWS IAM roles**
- No long-lived AWS credentials stored in CI
- AWS Secrets Manager is used to securely fetch Terraform secrets

### Policy as Code
- **Checkov** for static Terraform/IaC scanning
- **OPA** to validate Terraform plan files before apply
- Prevents insecure or non-compliant infrastructure changes

### Application & Image Security
- **Semgrep** for static application code analysis
- **OWASP Dependency Check** for vulnerable dependencies
- **Trivy** for container image vulnerability scanning after build

### Network Security
- No public application endpoints
- VPN-only access via WireGuard
- Internal ALB and private networking

### Instance Access & Management

EC2 instances are managed using AWS Systems Manager (SSM) rather than SSH.

- No SSH keys are generated or distributed
- Port 22 is not exposed on any EC2 instance
- Ansible connects to EC2 instances via SSM using IAM permissions

This significantly reduces the attack surface and eliminates credential sprawl associated with SSH-based access.

---

## CI/CD Pipeline

- Infrastructure provisioning via Terraform
- Policy validation gates before apply
- Container images built and scanned in CI
- Configuration applied via Ansible
- Secrets sourced dynamically using OIDC and AWS Secrets Manager

---

## Repository Structure

```

.
├── .github
│   ├── actions
│   └── workflows
├── ansible
│   └── roles
├── backend
│   ├── fastapi
│   └── postgres_db
├── frontend
│   └── react-recoil
├── policies
│   ├── checkov
│   └── opa
├── terraform
│   ├── aws_modules
│   └── env
├── docs
└── utils

```

### Directory Overview

- `.github/` – CI workflows and reusable GitHub Actions
- `ansible/` – Roles and templates for EC2 configuration
- `terraform/` – AWS infrastructure modules and environments
- `policies/` – Policy-as-code rules (Checkov & OPA)
- `backend/` – FastAPI application and database migrations files
- `frontend/` – React frontend
- `docs/` – Architecture and security documentation

---

## Getting Started (High-Level)

This project is **not a one-click deployment**.

It assumes familiarity with:
- AWS networking & IAM
- Terraform
- Ansible
- Docker
- VPN concepts

High-level steps:
1. Provision AWS infrastructure using Terraform
2. Validate plans using policy-as-code checks
3. Configure EC2 instances using Ansible
4. Deploy WireGuard and generate client configurations
5. Deploy application containers and Nginx routing
6. Access the platform via VPN connection

---

## Limitations & Future Work

- No Kubernetes (intentionally EC2-focused)
- Observability stack not yet implemented
- Automated VPN client provisioning could be improved

---

## Why This Project Matters

This project demonstrates:
- Defense-in-depth cloud security
- Policy-driven infrastructure governance
- Realistic enterprise deployment patterns
- Strong separation of concerns between provisioning and configuration


## Additional Documentation

Detailed architecture and security documentation is provided in the `docs/` directory:

- `docs/architecture.md` – System architecture, infrastructure components, and data flows
- `docs/security.md` – Security model, IAM design, policy-as-code enforcement, and threat mitigation
