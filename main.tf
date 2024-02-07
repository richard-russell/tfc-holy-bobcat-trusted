provider "aws" {
    region = "${var.aws_region}"
}

variable "aws_region" { default = "eu-west-2" } # London

# Non-compliant config - data source in root module
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

# Non-compliant config - Resource created from root module
resource "aws_instance" "bad_ubuntu" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
 
  tags = {
    Name = "non-compliant"
  }
}

module "tfc-demo-two-tier" {
  source  = "app.terraform.io/richard-russell-org/tfc-demo-two-tier/aws"
  version = "1.0.7"
  aws_region = "eu-west-2"
  aws_ami    = "ami-0ac10f53765369588"
  service_name = "${terraform.workspace}"
}

output "url" {
  value = module.tfc-demo-two-tier.address
}
