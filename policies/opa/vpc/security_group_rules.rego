package aws.vpc_security_group_rules

import input as tfplan

http_port := 80
https_port := 443
api_port := 8080
react_app_port := 3000
postgres_port := 5432

deny[msg] {
    sg_rule = tfplan.resource_changes[_]
    sg_rule.type in ["aws_vpc_security_group_ingress_rule", "aws_vpc_security_group_egress_rule"]
    not exists sg_rule.change.after.tags["Resource"]
    msg = sprintf(
        "Security Group Rule %s is missing Resource tag.", 
        [sg_rule.name]
        )
}

# ALB Security Group Rules
deny[msg] {
    sg_rule = tfplan.resource_changes[_]
    sg_rule.type in ["aws_vpc_security_group_ingress_rule", "aws_vpc_security_group_egress_rule"]
    sg_rule.change.after.tags["Resource"] = "ALB"
    not (sg_rule.change.after.from_port in [http_port, https_port] 
        and sg_rule.change.after.to_port in [http_port, https_port])
    msg = sprintf(
        "Security Group Rule %s for ALB has invalid port: %d. Allowed ports are: %d, %d", 
        [sg_rule.name, sg_rule.change.after.from_port, http_port, https_port]
        )
}

# EC2 Security Group Rules
deny[msg] {
    sg_rule = tfplan.resource_changes[_]
    sg_rule.type in ["aws_vpc_security_group_ingress_rule"]
    sg_rule.change.after.tags["Resource"] = "EC2"
    not exists sg_rule.change.after.referenced_security_group_id
    msg = sprintf(
        "Security Group Rule %s for EC2 must reference another security group.", 
        [sg_rule.name]
        )
}

deny[msg] {
    sg_rule = tfplan.resource_changes[_]
    sg_rule.type in ["aws_vpc_security_group_ingress_rule"]
    sg_rule.change.after.tags["Resource"] = "EC2"
    not (sg_rule.change.after.from_port in [api_port, react_app_port] 
        and sg_rule.change.after.to_port in [api_port, react_app_port])
    msg = sprintf(
        "Security Group Rule %s for EC2 has invalid port: %d. Allowed ports are: %d, %d", 
        [sg_rule.name, sg_rule.change.after.from_port, api_port, react_app_port]
        )
}

# RDS Security Group Rules
deny[msg]{
    sg_rule = tfplan.resource_changes[_]
    sg_rule.type in ["aws_vpc_security_group_egress_rule"]
    sg_rule.change.after.tags["Resource"] = "RDS"
    not exists sg_rule.change.after.referenced_security_group_id
    msg = sprintf(
        "Security Group Rule %s for RDS must reference another security group.", 
        [sg_rule.name]
        )
}

deny[msg] {
    sg_rule = tfplan.resource_changes[_]
    sg_rule.type in ["aws_vpc_security_group_ingress_rule"]
    sg_rule.change.after.tags["Resource"] = "RDS"
    not (sg_rule.change.after.from_port == postgres_port 
        and sg_rule.change.after.to_port == postgres_port)
    msg = sprintf(
        "Security Group Rule %s for RDS has invalid port: %d. Allowed port is: %d", 
        [sg_rule.name, sg_rule.change.after.from_port, postgres_port]
        )
}