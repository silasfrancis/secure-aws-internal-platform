resource "aws_vpc_security_group_ingress_rule" "wireguard_ingress_rule" {
    security_group_id = aws_security_group.wireguard.id
    from_port = 51820
    to_port = 51820
    ip_protocol = "udp"
    cidr_ipv4 = "0.0.0.0/0"
    tags = {
    Resource = "WireGuard"
    }
    depends_on = [ aws_security_group.wireguard ]
}

resource "aws_vpc_security_group_egress_rule" "wireguard_egress_rule" {
  security_group_id = aws_security_group.wireguard.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  tags = {
    Resource = "WireGuard"
  }
  depends_on = [ aws_security_group.wireguard ]
}