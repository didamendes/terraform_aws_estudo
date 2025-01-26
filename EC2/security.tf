resource "aws_security_group" "diogo_sg_web" {
  name        = var.diogo_sg_web_name
  description = "Regras de firewall para as EC2 para aplicacao WEB"
  vpc_id      = aws_vpc.diogo_vpc.id

  dynamic "ingress" {
    for_each = var.diogo_sg_web_ingresses
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.diogo_sg_web_egresses
    content {
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = {
    Name = var.diogo_sg_web_name
  }

}

resource "aws_network_acl" "diogo_nacl_web" {
  vpc_id     = aws_vpc.diogo_vpc.id
  subnet_ids = [aws_subnet.dio_subnet_publica.id]

  dynamic "ingress" {
    for_each = var.diogo_nacl_publica_ingress
    content {
      protocol   = ingress.value["protocol"]
      rule_no    = ingress.value["rule_no"]
      action     = ingress.value["action"]
      cidr_block = ingress.value["cidr_block"]
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
    }
  }

  dynamic "egress" {
    for_each = var.diogo_nacl_publica_egress
    content {
      protocol   = egress.value["protocol"]
      rule_no    = egress.value["rule_no"]
      action     = egress.value["action"]
      cidr_block = egress.value["cidr_block"]
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
    }
  }

  tags = {
    Name = var.diogo_nacl_publica_name
  }

}



/**
  DB
 */

resource "aws_security_group" "diogo_sg_db" {
  name        = var.diogo_sg_db_name
  description = "Regras de firewall para as EC2 para aplicacao DB"
  vpc_id      = aws_vpc.diogo_vpc.id

  ingress {
    description     = "Acesso Mongo DB"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.diogo_sg_web.id]
    #    cidr_blocks      = ["0.0.0.0/0"]
    #    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Acesso SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "egress" {
    for_each = var.diogo_sg_db_egresses
    content {
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = {
    Name = var.diogo_sg_db_name
  }

}

resource "aws_network_acl" "diogo_nacl_db" {
  vpc_id     = aws_vpc.diogo_vpc.id
  subnet_ids = [aws_subnet.dio_subnet_privada.id]

  dynamic "ingress" {
    for_each = var.diogo_nacl_privada_ingress
    content {
      protocol   = ingress.value["protocol"]
      rule_no    = ingress.value["rule_no"]
      action     = ingress.value["action"]
      cidr_block = ingress.value["cidr_block"]
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
    }
  }

  dynamic "egress" {
    for_each = var.diogo_nacl_privada_egress
    content {
      protocol   = egress.value["protocol"]
      rule_no    = egress.value["rule_no"]
      action     = egress.value["action"]
      cidr_block = egress.value["cidr_block"]
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
    }
  }

  tags = {
    Name = var.diogo_nacl_privada_name
  }

}