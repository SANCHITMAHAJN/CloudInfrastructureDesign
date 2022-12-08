#Create VPC

resource "aws_vpc" "ec2-vpc" {
  cidr_block = "10.0.0.0/16"

    tags = {
      Name = "EC2 VPC"
    }
}

#Create Gateway

resource "aws_internet_gateway" "gw2" {
  vpc_id = aws_vpc.ec2-vpc.id

}

#Create Custom Route Table
resource "aws_route_table" "ec2-route-table" {
  vpc_id = aws_vpc.ec2-vpc.id
  tags = {
    Name = "prod"
  }
}


#Create Subnet
resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.ec2-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
      Name = "ec2-subnet"
  }
}

#Associate subnet with Route table
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.ec2-route-table.id
}


#Create Instance
resource "aws_instance" "ubuntu-instance" {
  ami = "ami-097a2df4ac947655f"
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.subnet_2.id
  associate_public_ip_address = "false"
  
  tags = {
      Name = "Ubuntu" }
  
}
