package aws.alb_target_group_validations

import input as tfplan

deny[msg] {
    target_group = tfplan.resource_changes[_]
    target_group.type == "aws_lb_target_group"
    target_group.change.after.protocol == "HTTP"
    not exists target_group.change.after.health_check.path
    msg = sprintf(
        "ALB Target Group %s using HTTP protocol must have a health check path defined.", 
        [target_group.name]
        )
}

deny[msg] {
    target_group = tfplan.resource_changes[_]
    target_group.type == "aws_lb_target_group_attachment"
    not exists target_group.change.after.target_id
    msg = sprintf(
        "ALB Target Group Attachment %s must have a target ID defined.", 
        [target_group.name]
        )
}