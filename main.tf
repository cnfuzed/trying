provider "aws" {
  region = "us-east-2" # Use us-east-2 as the desired region
}

resource "aws_vpc" "jenkins_automate_vpc" {
  cidr_block = "192.168.0.0/16" # Use 192.168.0.0/16 as the CIDR block for the VPC
  tags = {
    Name = "jenkins-automate-VPC"
  }
}

resource "aws_subnet" "jenkins_automate_public_subnet1" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.1.0/24" # Use 192.168.1.0/24 as the CIDR block for the public subnet 1
  availability_zone = "us-east-2a"     # Choose the desired availability zone in us-east-2
}

resource "aws_subnet" "jenkins_automate_public_subnet2" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.2.0/24" # Use 192.168.2.0/24 as the CIDR block for the public subnet 2
  availability_zone = "us-east-2b"     # Choose the desired availability zone in us-east-2
}

resource "aws_subnet" "jenkins_automate_private_subnet1" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.3.0/24" # Use 192.168.3.0/24 as the CIDR block for the private subnet 1
  availability_zone = "us-east-2a"     # Choose the desired availability zone in us-east-2
}

resource "aws_subnet" "jenkins_automate_private_subnet2" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.4.0/24" # Use 192.168.4.0/24 as the CIDR block for the private subnet 2
  availability_zone = "us-east-2b"     # Choose the desired availability zone in us-east-2
}

resource "aws_internet_gateway" "jenkins_automate_igw" {
  vpc_id = aws_vpc.jenkins_automate_vpc.id
}

resource "aws_route_table" "jenkins_automate_public_route_table" {
  vpc_id = aws_vpc.jenkins_automate_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_automate_igw.id
  }
}

resource "aws_route_table_association" "jenkins_automate_public_subnet1_association" {
  subnet_id      = aws_subnet.jenkins_automate_public_subnet1.id
  route_table_id = aws_route_table.jenkins_automate_public_route_table.id
}

resource "aws_route_table_association" "jenkins_automate_public_subnet2_association" {
  subnet_id      = aws_subnet.jenkins_automate_public_subnet2.id
  route_table_id = aws_route_table.jenkins_automate_public_route_table.id
}

resource "aws_security_group" "jenkins_automate_security_group" {
  vpc_id = aws_vpc.jenkins_automate_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add any additional security group rules you may require

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } # Add your desired security group rules here
  tags = {
    Name = "jenkins-automate-sg"
  }
}

resource "aws_instance" "jenkins_automate" {
  ami                    = "ami-083eed19fc801d7a4" # Specify the desired AMI ID
  instance_type          = "t2.micro"              # Choose the instance type
  subnet_id              = aws_subnet.jenkins_automate_public_subnet1.id
  vpc_security_group_ids = [aws_security_group.jenkins_automate_security_group.id]

  tags = {
    Name = "jenkins-automate-instance"
  }
}

resource "aws_eip" "jenkins_automate_eip" {
  instance = aws_instance.jenkins_automate.id
}
