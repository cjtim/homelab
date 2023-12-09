terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.21.0"
    }
  }
}

provider "oci" {
  auth             = "APIKey"
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  tenancy_ocid     = var.compartment_id
  region           = var.region
  private_key_path = var.private_key_path
}