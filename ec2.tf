# Aws web server 
resource "aws_instance" "example" {
  ami           = ami-08e2c1a8d17c2fe17
  instance_type = "t2.micro"
  key_name  = "terraform"
  subnet_id     = aws_subnet.ibm-web-sn.id
  vpc_security_group_id = [aws_security_group.ibm-db-nacl-sg.id]
  user_data = file("ecomm.sh")

  tags = {
    Name = "ibm-web-server"
  }
}