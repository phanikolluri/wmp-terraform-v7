resource "null_resource" "main" {

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
    }
    inline = [
      "sudo dnf install python3.13-pip.noarch -y",
      "sudo pip3.13 install ansible",
      "ansible-pull -i localhost, -U https://github.com/phanikolluri/wmp-ansible-v4.git main.yml  -e env=${var.env} -e component=${var.component}"
    ]
  }
}