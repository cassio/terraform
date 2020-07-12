variable "region" {
  description = "AWS Region"
  default = "us-east-2"
}

variable "key_path" {
  description = "Public key path"
  default = "/Users/cassio.cunha/.ssh/id_rsa.pub"
}

variable "ami" {
  description = "AMI"
  default = "ami-0b59bfac6be064b78" // Amazon Linux
}

variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "dnsSupport" {
    default = true
}

variable "dnsHostNames" {
    default = true
}

variable "vpcCIDRblock" {
    default = "10.7.0.0/16"
}

variable "publicdestCIDRblock" {
    default = "0.0.0.0/0"
}

variable "localdestCIDRblock" {
    default = "10.7.0.0/16"
}

variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "mapNeonPublicIP" {
    default = true
}
