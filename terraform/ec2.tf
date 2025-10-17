resource "aws_iam_role" "vm_role" {
  name = "role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vm_role_policy_attachment" {
  role       = aws_iam_role.vm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "vm_profile" {
  name = "profile"
  role = aws_iam_role.vm_role.name
}

resource "aws_instance" "vm" {
  ami                         = "ami-0a628e1e89aaedf80"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.vm_profile.name
  user_data_replace_on_change = true
  user_data                   = <<-EOF
    #!/usr/bin/env bash

    apt-get update -y
    apt-get install -y curl


    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up --authkey  ${var.tailscale_auth_key} --hostname "foo" --ssh
  EOF
}
