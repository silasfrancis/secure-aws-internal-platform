package aws.rds_encryption_and_security

import input as tfplan

deny[msg] {
    rds_instance = tfplan.resource_changes[_]
    rds_instance.type == "aws_db_instance"
    rds_instance.change.after.storage_encrypted != true
    msg = sprintf(
        "RDS Instance %s does not have storage encryption enabled.", 
        [rds_instance.name]
        )
}

deny[msg] {
    rds_instance = tfplan.resource_changes[_]
    rds_instance.type == "aws_db_instance"
    rds_instance.change.after.publicly_accessible == true
    msg = sprintf(
        "RDS Instance %s is publicly accessible.", 
        [rds_instance.name]
        )
}

deny[msg] {
    rds_instance = tfplan.resource_changes[_]
    rds_instance.type == "aws_db_instance"
    not exists rds_instance.change.after_unknown.vpc_security_group_ids[_]
    msg = sprintf(
        "RDS Instance %s is not associated with any VPC Security Groups.", 
        [rds_instance.name]
        )
}

deny[msg] {
    rds_instance = tfplan.resource_changes[_]
    rds_instance.type == "aws_db_instance"
     not rds_instance.change.after_sensitive.username and
     not rds_instance.change.after_sensitive.password
    msg = sprintf(
        "RDS Instance %s does not have sensitive data protection for username and password.", 
        [rds_instance.name]
        )
}