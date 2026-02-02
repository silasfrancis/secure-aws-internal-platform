package aws.vpc_gateway_rules

import input as tfplan

deny[msg] {
    route_table = tfplan.resource_changes[_]
    route_table.type == "aws_route_table"
    not exists route_table.change.after.tags["Resource"]
    msg = sprintf(
        "Route Table %s is missing Resource tag.", 
        [route_table.name]
        )
}

deny[msg] {
    route_table = tfplan.resource_changes[_]
    route_table.type == "aws_route_table"
    contains(lower(route_table.change.after.tags["Resource"]), "public")
    not exists route_table.change.after_unknown.routes[_].gateway_id
    msg = sprintf(
        "Route Table %s for Public Subnets must have an Internet Gateway route.", 
        [route_table.name]
        )
}

deny[msg] {
    route_table = tfplan.resource_changes[_]
    route_table.type == "aws_route_table"
    contains(lower(route_table.change.after.tags["Resource"]), "private")
    not exists route_table.change.after_unknown.routes[_].nat_gateway_id
    msg = sprintf(
        "Route Table %s for Private Subnets must have an NAT Gateway route.", 
        [route_table.name]
        )
}