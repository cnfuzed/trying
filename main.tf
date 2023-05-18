rovider "aws" {
  region = "us-east-2" # Use us-east-2 as the desired region
}

resource "aws_vpc" "jenkins_automate_vpc" {
  cidr_block = "192.168.0.0/16" # Use 192.168.0.0/16 as the CIDR block for the VPC
}

resource "aws_subnet" "jenkins_automate_public_subnet_1" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.0.0/24" # Use 192.168.0.0/24 as the CIDR block for the public subnet 1
  availability_zone = "us-east-2a"     # Choose the desired availability zone in us-east-2
}

resource "aws_subnet" "jenkins_automate_public_subnet_2" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.1.0/24" # Use 192.168.1.0/24 as the CIDR block for the public subnet 2
  availability_zone = "us-east-2b"     # Choose the desired availability zone in us-east-2
}

resource "aws_subnet" "jenkins_automate_private_subnet_1" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.2.0/24" # Use 192.168.2.0/24 as the CIDR block for the private subnet 1
  availability_zone = "us-east-2a"     # Choose the desired availability zone in us-east-2
}

resource "aws_subnet" "jenkins_automate_private_subnet_2" {
  vpc_id            = aws_vpc.jenkins_automate_vpc.id
  cidr_block        = "192.168.3.0/24" # Use 192.168.3.0/24 as the CIDR block for the private subnet 2
  availability_zone = "us-east-2b"     # Choose the desired availability zone in us-east-2
}

resource "aws_internet_gateway" "jenkins_automate_igw" {
  vpc_id = aws_vpc.jenkins_automate_vpc.id
}

resource "aws_route_table" "jenkins_automate_public_route_table" {
  vpc_id = aws_vpc.jenkins_automate_vpc.id
}

resource "aws_route_table_association" "jenkins_automate_public_subnet_1_association" {
  subnet_id      = aws_subnet.jenkins_automate_public_subnet_1.id
  route_table_id = aws_route_table.jenkins_automate_public_route_table.id
}

resource "aws_route_table_association" "jenkins_automate_public_subnet_2_association" {
  subnet_id      = aws_subnet.jenkins_automate_public_subnet_2.id
  route_table_id = aws_route_table.jenkins_automate_public_route_table.id
}

resource "aws_eip" "jenkins_automate_eip" {
  vpc = true
}

resource "aws_instance" "jenkins_automate" {
  ami                    = "ami-083eed19fc801d7a4" # Specify the desired AMI ID
  instance_type          = "t2.micro"              # Choose the instance type
  subnet_id              = aws_subnet.jenkins_automate_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.jenkins_automate_security_group.id]
  key_name               = "lab6" # Specify the name of your key pair

  tags = {
    Name = "jenkins-automate-instance"
  }
}

resource "aws_security_group" "jenkins_automate_security_group" {
  name        = "jenkins-automate-sg"
  description = "Security group for Jenkins Automate"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.jenkins_automate_vpc.id
}

resource "aws_security_group_rule" "jenkins_automate_outbound_rule" {
  security_group_id = aws_security_group.jenkins_automate_security_group.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "jenkins_automate_inbound_rule" {
  security_group_id = aws_security_group.jenkins_automate_security_group.id

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
}
