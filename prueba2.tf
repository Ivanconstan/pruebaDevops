#crear parkey ssh-keygen -t rsa -b 4096 -f ~/.ssh/proyecto-clave
provider "aws" {
    region     = "eu-west-1"
    # export AWS_ACCESS_KEY_ID="TU_ACCESS_KEY"
    # export AWS_SECRET_ACCESS_KEY="TU_SECRET_KEY"
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_security_group"
  description = "Permitir trafico HTTP y SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {

    count = 1
    ami           = "ami-0d64bb532e0502c46"
    instance_type = "t2.micro"
    key_name = "proyecto-clave"
    security_groups = [aws_security_group.nginx_sg.name]
  

    
    tags = {
     Name = "Prueba-${count.index + 1}"
    }
}
output "instance_ip" {
  value = [for instance in aws_instance.example : instance.public_ip]
  description = "La IP pública de la instancia Nginx"
}