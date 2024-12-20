resource "aws_instance" "web-demo" {
  ami                    = var.amiID[var.region]
  instance_type          = var.instanceType
  key_name               = aws_key_pair.demo-key.key_name
  vpc_security_group_ids = [aws_security_group.tf-sg.id]
  availability_zone      = var.zone1

  tags = {
    Name    = "TF-web-demo"
    Project = "TerraForm"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  connection {
    type        = "ssh"
    user        = var.webuser
    private_key = file("demokey")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

}

# resource "aws_ec2_instance_state" "web-state" {
#   instance_id = aws_instance.web.id
#   state       = "running"
# }

output "WebPublicIP" {
  description = "Web Public IP"
  value       = aws_instance.web-demo.public_ip
}

output "WebPrivateIP" {
  description = "Web Private IP"
  value       = aws_instance.web-demo.private_ip
}