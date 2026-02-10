resource "aws_eip" "wireguard_eip" {
  instance = aws_instance.wireguard_server.id
  domain   = "vpc"
  depends_on = [ aws_instance.wireguard_server ]
}