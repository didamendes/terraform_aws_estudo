resource "aws_db_subnet_group" "aula_db_subnet_group" {
  name       = "aula-db-subnet-group"
  subnet_ids = module.vpc.public_subnets

  ##subnet_ids = module.vpc.private_subnets - Banco privado
}

resource "aws_db_instance" "db_mysql" {
  allocated_storage   = 10
  db_name             = "mysqldb"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "root"
  password            = "123456"
  skip_final_snapshot = true
  publicly_accessible = true

  #  publicly_accessible = false - Banco privado

  multi_az            = false

  db_subnet_group_name   = aws_db_subnet_group.aula_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}