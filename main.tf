provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Choisis l'AMI de ton choix
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorldApp"
  }
}
