resource "aws_lb_target_group_attachment" "frontend_target_group_attachment" {
  target_group_arn = aws_lb_target_group.frontend_target_group.arn
  for_each = {
    for k, v in var.ec2_instances_ids:
    k => v
  }
  target_id = each.value
  port = 3000
}

resource "aws_lb_target_group_attachment" "api_target_group_attachment" {
  target_group_arn = aws_lb_target_group.api_target_group.arn
  for_each = {
    for k, v in var.ec2_instances_ids:
    k => v
  }
  target_id = each.value
  port = 8080
}