resource "oci_core_vcn" "kubernetes" {
  compartment_id = var.compartment_id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "kubernetes"
  dns_label      = "vcn04062154"
}

resource "oci_core_subnet" "default" {
  display_name   = "default"
  cidr_block     = "10.0.0.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.kubernetes.id
  dns_label      = "subnet04062154"
  route_table_id = oci_core_route_table.Internet.id

}

resource "oci_core_subnet" "lb" {
  display_name   = "lb"
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.kubernetes.id
  dns_label      = "subnetlb"
  route_table_id = oci_core_route_table.Internet.id
  security_list_ids = [
    oci_core_security_list.default.id
  ]
}

resource "oci_core_route_table" "Internet" {
  compartment_id = var.compartment_id
  display_name   = "Internet"
  vcn_id         = oci_core_vcn.kubernetes.id
  route_rules {
    network_entity_id = oci_core_internet_gateway.Internet.id
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_internet_gateway" "Internet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.kubernetes.id
  display_name   = "Internet"
}
