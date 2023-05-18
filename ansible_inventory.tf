data "template_file" "ansible_inventory" {
  template = <<-EOF
    [web]
    ${aws_instance.jenkins_automate.private_ip}
  EOF
}

resource "null_resource" "ansible_inventory" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.ansible_inventory.rendered}' > ansible/inventory.ini"
  }
}

