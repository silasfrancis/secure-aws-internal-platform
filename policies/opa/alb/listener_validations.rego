package aws.alb_listener_validations

import input as tfplan

warn[msg] {
    listener = tfplan.resource_changes[_]
    listener.type == "aws_lb_listener"
    listener.change.after.protocol == "HTTP"
    listener.change.after.port == 80
    not listener.change.after.default_action[_].redirect
    msg = sprintf(
        "ALB Listener %s on port 80 must have a redirect action to HTTPS.", 
        [listener.name]
        )
}

deny[msg] {
    listener = tfplan.resource_changes[_]
    listener.type == "aws_lb_listener"
    listener.change.after.protocol == "HTTP"
    listener.change.after.default_action[_].redirect = redirect
    redirect.protocol != "HTTPS" and redirect.port != "443"
    msg = sprintf(
        "ALB Listener %s on port 80 must redirect to HTTPS on port 443.", 
        [listener.name]
        )
}

deny[msg] {
    listener = tfplan.resource_changes[_]
    listener.type == "aws_lb_listener"
    listener.change.after.protocol == "HTTPS"
    not listener.change.after.ssl_policy and not listener.change.after.certificate_arn
    msg = sprintf(
        "ALB Listener %s using HTTPS must have an SSL policy defined.", 
        [listener.name]
        )
}