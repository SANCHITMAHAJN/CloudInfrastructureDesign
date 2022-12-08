# 1.Create VPC

resource "aws_vpc" "ec2-vpc" {
  cidr_block = "10.0.0.0/16"

    tags = {
      Name = "EC2 VPC"
    }
}

# 2. Create Gateway

resource "aws_internet_gateway" "gw2" {
  vpc_id = aws_vpc.ec2-vpc.id

}

# 3.Create Custom Route Table
resource "aws_route_table" "ec2-route-table" {
  vpc_id = aws_vpc.ec2-vpc.id
  tags = {
    Name = "prod"
  }
}


# 4.Create Subnet
resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.ec2-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
      Name = "ec2-subnet"
  }
}

# 5.Associate subnet with Route table
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.ec2-route-table.id
}


# Create EC2
resource "aws_instance" "windows" {
  ami           = "ami-0abd913dba3f356b5"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_2.id
  associate_public_ip_address = "false"

  tags = {
      Name = "Windows" }
 
}