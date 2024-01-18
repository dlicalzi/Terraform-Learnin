# security
module "db_sg" {
  source = "./modules/rds"
  sg_name = "${var.default_tags.env}-dbsg"
  description = "SG for Terraform demo"
  vpc_id = aws_vpc.main.id
  sg_db_ingress = var.sg_db_ingress
  sg_db_egress = var.sg_db_egress
  sg_source = aws_instance.main.vpc_security_group_ids
}

# db subnet group
resource "aws_db_subnet_group" "db" {
  name_prefix = "vbtfpostgresql"
  subnet_ids = aws_subnet.private.*.id
  tags = {
    "Name" = "${var.default_tags.env}-group"
  }
}
# cluster
resource "aws_rds_cluster" "db" {
  cluster_identifier = "${var.default_tags.env}-db-cluster"
  db_subnet_group_name = aws_db_subnet_group.db.name
  engine = "aurora-postgresql"
  engine_mode = "provisioned"
  engine_version = "15.3"
  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
  availability_zones = aws_subnet.private[*].availability_zone
  database_name = "vbtfpostgresql"
  vpc_security_group_ids = [module.db_sg.sg_id]
  master_username = var.db_credentials.username
  master_password = var.db_credentials.password
  skip_final_snapshot = true
  tags = {
    "Name" = "${var.default_tags.env}-cluster"
  }
}

# cluster instances
resource "aws_rds_cluster_instance" "db" {
  count = 2
  identifier = "${var.default_tags.env}-${count.index+1}"
  cluster_identifier = aws_rds_cluster.db.id
  instance_class = "db.serverless"
  engine = aws_rds_cluster.db.engine
  engine_version = aws_rds_cluster.db.engine_version
  db_subnet_group_name = aws_db_subnet_group.db.name
}
output "db_endpoints" {
    value = {
        writer = aws_rds_cluster.db.endpoint
        reader = aws_rds_cluster.db.reader_endpoint
    }
  
}