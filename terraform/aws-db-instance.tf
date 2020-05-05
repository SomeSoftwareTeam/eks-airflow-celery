resource "aws_db_subnet_group" "airflow" {
  name       = "airflow"
  subnet_ids = ["subnet-01f87b66182c45f98", "subnet-07f79c2b3f6e0ec31"]
  tags = {
    Name = "airflow"
  }
}

resource "aws_db_instance" "airflow" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "airflow"
  username             = var.mysql_username
  password             = var.mysql_password
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = "true"
  db_subnet_group_name = aws_db_subnet_group.airflow.name
  tags = {
    Name = "airflow"
  }
}