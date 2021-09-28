
resource "aws_security_group" "app_security_group" {
   name       = "${local.prefix}-APP-SG"
   description = "Security group for app to communicate in and out"
   vpc_id      = data.terraform_remote_state.infrastructure.outputs.vpc_id
   
   ingress {
        from_port   = 8080
        protocol    = "TCP"
        to_port     = 8080
        cidr_blocks = [data.terraform_remote_state.infrastructure.outputs.vpc_cidr_block]
    }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = merge(
    local.common_tags,
    {
        Name = "${local.prefix}-APP-SG"
    }
  )
}
