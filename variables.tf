variable "network" {
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
variable "network_override" {
  type = string
  default = "standard"
}
variable "private_networkbits" {
  type = number
  default = null
}
variable "public_networkbits" {
  type = number
  default = null
}
variable "intra_networkbits" {
  type = number
  default = null
}
variable "database_networkbits" {
  type = number
  default = null
}
variable "elasticache_networkbits" {
  type = number
  default = null
}
variable "redshift_networkbits" {
  type = number
  default = null
}
variable "public_netnum" {
  type = number
  default = null
}
variable "intra_netnum" {
  type = number
  default = null
}
variable "database_netnum" {
  type = number
  default = null
}
variable "elasticache_netnum" {
  type = number
  default = null
}
variable "redshift_netnum" {
  type = number
  default = null
}
# TODO Likely shouldn't be a number. This should be three options, SINGLE_AZ, MULTI_AZ, POOR_PERSON_NAT, OR NONE
variable "nat_type" {
  type = string
  default = "none"
}

variable "publictags" {
  type = map(string)
  default = null
}

variable "privatetags" {
  type = map(string)
  default = null
}

variable "intratags" {
  type = map(string)
  default = null
}

variable "databasetags" {
  type = map(string)
  default = null
}

variable "elasticachetags" {
  type = map(string)
  default = null
}

variable "redshifttags" {
  type = map(string)
  default = null
}
variable "redshift" {
  type = bool
  default = false
}
variable "intra" {
  type = bool
  default = true
}
variable "database" {
  type = bool
  default = true
}
variable "elasticache" {
  type = bool
  default = true
}
variable "private" {
  type = bool
  default = true
}
variable "public" {
  type = bool
  default = true
}
