
#Create VPC

resource "aws_vpc" "web-vpc" {
  cidr_block = "10.0.0.0/16"

    tags = {
      Name = "Webserver VPC"
    }
}

#Create Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.web-vpc.id

}

#Create Custom Route Table
resource "aws_route_table" "web-route-table" {
  vpc_id = aws_vpc.web-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Web"
  }

}
#Create Subnet
resource "aws_subnet" "subnet_3" {
  vpc_id = aws_vpc.web-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
      Name = "web-subnet"
  }
}

#Associate subnet with Route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.web-route-table.id
}


#Create Security group to allow port 22, 80, 443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.web-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   # 0.0.0.0 means everyone can
   
  }

 

ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  
  }

 


ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  
  }


   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"   #ANY Protocol
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }



  tags = {
    Name = "allow_web"
  }
}

#Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet_3.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}


#Assign an elastic IP to network interface
resource "aws_eip" "one" {
  vpc = true
  network_interface = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
  


}



# Create Instance
resource "aws_instance" "web-server-instance" {
  ami = "ami-097a2df4ac947655f"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"

  network_interface {
    device_index = 0 #First network interface
    network_interface_id = aws_network_interface.web-server-nic.id

  }

  #Commands as user

  user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo bash -c 'echo XYZ Corp Web Server > /var/www/html/index.html'
        EOF
    tags = {
      Name = "Web-Server" }
}
