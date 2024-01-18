resource "aws_security_group" "sg" {
  name = var.sg_name
  description = var.description
  vpc_id = var.vpc_id


dynamic "ingress" {
    for_each = var.sg_db_ingress
    content {
        from_port = ingress.value.port
        to_port = ingress.value.port
        protocol = ingress.value.protocol
        security_groups = var.sg_source
        self = ingress.value.self
    }
    }
dynamic "egress" {
    for_each = var.sg_db_egress
    content {
        from_port = egress.value.port
        to_port = egress.value.port
        protocol = egress.value.protocol
        security_groups = var.sg_source
        self = egress.value.self
    }
    }
}