variable "cidr" {
  type = string
}
# TODO Spell this out so you know what it is when you read it
variable "subnet_cidr" {
  type = string
}
variable "az_count" {
  type = number
  default = 2
}
# TODO Likely shouldn't be a number. This should be three options, SINGLE_AZ, MULTI_AZ, POOR_PERSON_NAT, OR NONE
variable "nat_type" {
  type = string
  default = "none"
}
