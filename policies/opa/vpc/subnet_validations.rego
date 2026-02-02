package aws.vpc_subnets

import input as tfplan

allowed_subnet_tiers := ["public", "private"]

deny[msg] {
    subnet = tfplan.resource_changes[_]
    subnet.type == "aws_subnet"
    not exists subnet.change.after.tags["Tier"]
    msg = sprintf(
        "Subnet %s is missing Tier tag. Allowed values are: %v", 
        [subnet.change.after.tags["Name"], allowed_subnet_tiers]
        )
}

deny[msg] {
    subnet = tfplan.resource_changes[_]
    subnet.type == "aws_subnet"
    subnet.change.after.tags["Tier"] not in allowed_subnet_tiers
    msg = sprintf(
        "Subnet %s has invalid Tier tag: %s. Allowed values are: %v", 
        [subnet.change.after.tags["Name"], subnet.change.after.tags["Tier"], allowed_subnet_tiers]
        )
}

