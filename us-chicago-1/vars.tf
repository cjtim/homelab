variable "compartment_id" {
  nullable = false
}

variable "region" {
  default = "us-chicago-1"
  nullable = false
}

variable "fingerprint" {
  nullable = false
}

variable "user_ocid" {
  nullable = false
}

variable "private_key_path" {
  nullable = false
}


# Instance vars
variable "ssh_key" {
  nullable = false
}

variable "AD_ZONE" {
  default = "rwsH:US-CHICAGO-1-AD-1"
}
