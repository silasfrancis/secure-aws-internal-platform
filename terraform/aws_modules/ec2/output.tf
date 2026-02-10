output "ec2_instances" {
  value = {
    instance1 = aws_instance.ec2_instance_1.id
    instance2 = aws_instance.ec2_instance_2.id
  }
}