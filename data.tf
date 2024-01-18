data "aws_availability_zones" "availability_zone" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
  state = "available"
}
data "aws_ssm_parameter" "instance_ami" {
  name = "/aws/service/canonical/ubuntu/eks/20.04/1.22/stable/20220713/amd64/hvm/ebs-gp2/ami-id"
}