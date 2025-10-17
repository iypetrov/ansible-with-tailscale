resource "aws_iam_role" "worker_role" {
  name = "worker-role"
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

resource "aws_iam_role_policy_attachment" "worker_role_policy_attachment" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "worker_profile" {
  name = "worker-profile"
  role = aws_iam_role.worker_role.name
}

resource "aws_instance" "worker_one" {
  ami                         = "ami-0a628e1e89aaedf80"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.worker_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.worker_profile.name
  user_data_replace_on_change = true
  user_data                   = <<-EOF
    #!/usr/bin/env bash

    apt-get update -y
    apt-get install -y curl

    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up --authkey  ${var.ts_auth_key} --hostname aws-worker-1 --ssh
  EOF
  tags = {
    Name = "aws-worker-1"
  }
}

resource "aws_instance" "worker_two" {
  ami                         = "ami-0a628e1e89aaedf80"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.worker_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.worker_profile.name
  user_data_replace_on_change = true
  user_data                   = <<-EOF
    #!/usr/bin/env bash

    apt-get update -y
    apt-get install -y curl

    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up --authkey  ${var.ts_auth_key} --hostname aws-worker-2 --ssh
  EOF
  tags = {
    Name = "aws-worker-2"
  }
}
