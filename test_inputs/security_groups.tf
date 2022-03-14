resource "aws_security_group" "bad_ports_for_protocol" {
  name        = "bad_ports_for_protocol"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    CostCentre = "tf-test-sg"
    Terraform = "test"
  }
}

resource "aws_security_group" "good_ports_for_protocol" {
  name        = "good_ports_for_protocol"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    CostCentre = "tf-test-sg"
    Terraform = "test"
  }
}

resource "aws_security_group" "tcp_protocol" {
  name        = "tcp_protocol"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    CostCentre = "tf-test-sg"
    Terraform = "test"
  }
}