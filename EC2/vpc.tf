/**
  Criação de uma VPC
 */
resource "aws_vpc" "diogo_vpc" {
  cidr_block = var.diogo_vpc_cidr_block

  tags = {
    Name = var.diogo_vpc_name
  }
}

/**
  Criaçao de uma Subnet publica e vincular a VPC
 */
resource "aws_subnet" "dio_subnet_publica" {
  vpc_id     = aws_vpc.diogo_vpc.id
  cidr_block = var.diogo_subnet_publica_cidr_block

  tags = {
    Name = var.diogo_subnet_publica_name
  }
}

/**
  Criaçao de uma Subnet privada e vincular a VPC
 */
resource "aws_subnet" "dio_subnet_privada" {
  vpc_id     = aws_vpc.diogo_vpc.id
  cidr_block = var.diogo_subnet_privada_cidr_block

  tags = {
    Name = var.diogo_subnet_privada_name
  }
}

/**
  Criaçao de Internet Gateway e vincular a VPC. Suas instancia comunicar com a Internet.
 */
resource "aws_internet_gateway" "diogo_igw" {
  vpc_id = aws_vpc.diogo_vpc.id

  tags = {
    Name = var.diogo_igw_name
  }
}

/**
  Criar uma IP elastico para vincular com o NAT Gateway
 */
resource "aws_eip" "diogo_lb" {
  depends_on = [aws_internet_gateway.diogo_igw]

  tags = {
    Name = var.diogo_nat_eip_name
  }

}

/**
  Criar de um NAT Gateway e vincular com a Subnet publica e allocar um IP Elastico. Ele depende de um Internet Gateway
  Faz sua rede publica comunicar com sua rede privada. Sem expor sua rede privata a Internet diretamente.
 */
resource "aws_nat_gateway" "diogo_nat" {
  subnet_id     = aws_subnet.dio_subnet_publica.id
  allocation_id = aws_eip.diogo_lb.id

  tags = {
    Name = var.diogo_nat_gtw_name
  }

  depends_on = [aws_internet_gateway.diogo_igw]
}

/**
  Cria uma Route table publica. Vincular com a VCP, e sua Internet Gateway
  Vale lembrar que a route table publica sempre conecta com o Internet Gateway
 */
resource "aws_route_table" "diogo_rt_publica" {
  vpc_id = aws_vpc.diogo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.diogo_igw.id
  }

  tags = {
    Name = var.diogo_rt_publica_name
  }
}

/**
  Associa sua Router publica com a subnet publica e a route criada anterior.
 */
resource "aws_route_table_association" "diogo_rt_publica_a" {
  subnet_id      = aws_subnet.dio_subnet_publica.id
  route_table_id = aws_route_table.diogo_rt_publica.id
}

/**
  Cria uma Route table privada. Vincular com a VCP, e sua NAT Gateway
  Vale lembrar que a route table privada sempre conecta com o NAT Gateway
 */
resource "aws_route_table" "diogo_rt_privada" {
  vpc_id = aws_vpc.diogo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.diogo_nat.id
  }

  tags = {
    Name = var.diogo_rt_privada_name
  }
}

/**
  Associa sua Router publica com a subnet privada e a route criada anterior.
 */
resource "aws_route_table_association" "diogo_rt_privada_a" {
  subnet_id      = aws_subnet.dio_subnet_privada.id
  route_table_id = aws_route_table.diogo_rt_privada.id
}