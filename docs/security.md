# Security Model

This document outlines the security principles, controls, and enforcement mechanisms used throughout the platform.

The system follows a **defense-in-depth** approach, with multiple layers of security across CI, infrastructure, networking, and runtime environments.

---

## Security Principles

- No public access to application workloads
- No long-lived credentials in CI
- No SSH access to instances
- Least-privilege IAM everywhere
- Policy enforcement before infrastructure changes
- Secrets never stored in Git or container images

---

## CI/CD Security

### Identity & Access Management

- GitHub Actions uses **OIDC** to assume AWS IAM roles
- No static AWS credentials are stored in CI
- Permissions are scoped to specific workflows and actions

### Secrets Management

- AWS Secrets Manager is used to store sensitive CI secrets
- Secrets are fetched dynamically at runtime
- Terraform credentials are injected only when required

---

## Policy as Code

Policy enforcement is applied before infrastructure changes are allowed.

### Tools Used

- **Checkov**
  - Static analysis of Terraform code
  - Prevents insecure infrastructure patterns

- **OPA (Open Policy Agent)**
  - Validates Terraform plan files
  - Enforces organizational and security rules before apply

This ensures non-compliant infrastructure never reaches production.

---

## Infrastructure Security

### Network Isolation

- Applications run in private subnets
- Internal Application Load Balancer only
- No public ingress to EC2 instances
- VPN-only access to the platform

### Instance Access

EC2 instances are managed using **AWS Systems Manager (SSM)** instead of SSH.

- No SSH keys generated or distributed
- Port 22 is disabled on all instances
- Access is controlled via IAM roles
- All access is logged via AWS CloudTrail

This removes an entire class of credential and exposure risks.

---

## VPN & Access Control

### WireGuard

- WireGuard runs on a dedicated EC2 instance
- Client keys are generated and managed via Ansible
- Only VPN-connected clients can access internal services

This enforces a zero-trust access boundary at the network level.

---

## Application & Container Security

### Static Analysis

- **Semgrep** for application code scanning
- **OWASP Dependency Check** for vulnerable dependencies

### Image Security

- **Trivy** scans container images after build and push
- Vulnerabilities are detected before deployment

---

## Runtime Security

- Containers run with minimal privileges
- No secrets baked into images
- Environment configuration injected at runtime
- Database access restricted to application subnets

---

## Threat Model Summary

| Threat | Mitigation |
|------|-----------|
| Credential leakage | OIDC, no static secrets |
| Public exposure | Internal ALB + VPN |
| SSH compromise | SSM-only access |
| Insecure IaC | Checkov + OPA |
| Vulnerable images | Trivy scanning |
| Supply chain risks | CI scanning gates |

---

## Summary

This security model ensures:
- Strong isolation between users and infrastructure
- Automated, enforceable security controls
- Minimal attack surface
- Full traceability across CI, infrastructure, and runtime
