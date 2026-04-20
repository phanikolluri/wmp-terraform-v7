resource "aws_security_group" "main" {

  name = "${var.component}-${var.env}"

  dynamic "ingress" {
    for_each = var.ports

    content {
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "TCP"
        cidr_blocks      = ["0.0.0.0/0"]
        description = ingress.key
    }
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.component}-${var.env}"
  }
}


resource "aws_instance" "main" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "${var.component}-${var.env}"
  }
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "${var.component}-${var.env}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.main.private_ip]
}

resource "null_resource" "main" {

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.main.public_ip
    }
    inline = [
      "sudo dnf install python3.13-pip.noarch -y",
      "sudo pip3.13 install ansible",
      "ansible-pull -i localhost, -U https://github.com/phanikolluri/wmp-ansible-v4.git main.yml  -e env=${var.env} -e component=${var.component}"
    ]
  }
}



