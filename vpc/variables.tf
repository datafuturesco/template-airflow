variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}
variable "public_subnets" {
  description = "Subnet Ids of the existing public subnets"
  type        = list(string)
  default     = ["10.10.3.0/24", "10.10.4.0/24"]
}

# tags and logging
variable "tags" {
  description = "Tags for this resource"
  type        = map(string)
  default     = {}
}
variable "environment" {
  description = "Environment name."
  type        = string
  default     = null
}
variable "platform" {
  description = "Platform name."
  type        = string
  default     = null
}
variable "aws_region" {
  description = "AWS region."
  type        = string
}
variable "aws_profile" {
  description = "AWS profile to use."
  type        = string
}
variable "aws_account_id" {
  description = "AWS account id to use."
  type        = string
}
variable "vpc_cidr" {
  description = "VPC CIDR for MWAA"
  type        = string
  default     = "10.1.0.0/16"
}