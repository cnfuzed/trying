provider "aws" {
  region = "us-west-2"  # Choose your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-083eed19fc801d7a4"  # Specify the desired AMI ID
  instance_type = "t2.micro"  # Choose the instance type

  tags = {
    Name = "ExampleInstance"
  }
}

