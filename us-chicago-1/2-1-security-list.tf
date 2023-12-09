resource "oci_core_security_list" "vm" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.kubernetes.id
  display_name   = "VM security list"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
  dynamic "ingress_security_rules" {
    for_each = [
      { source : "0.0.0.0/0", min : 22, max : 22, stateless : false, description : "SSH" }
    ]
    content {
      protocol    = "6"
      source      = ingress_security_rules.value.source
      source_type = "CIDR_BLOCK"
      stateless   = ingress_security_rules.value.stateless
      description = try(ingress_security_rules.value.description, null)
      tcp_options {
        max = ingress_security_rules.value.max
        min = ingress_security_rules.value.min
      }
    }
  }
  # Allow all inside OCI network
  ingress_security_rules {
    protocol    = "all"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
}


resource "oci_core_security_list" "default" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.kubernetes.id
  display_name   = "Custom security list"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
  dynamic "ingress_security_rules" {
    for_each = [
      { source : "10.0.0.0/16", code : -1, type : 3, stateless : false },
      { source : "0.0.0.0/0", code : 4, type : 3, stateless : true }
    ]
    content {
      protocol    = "1"
      source      = ingress_security_rules.value.source
      source_type = "CIDR_BLOCK"
      stateless   = ingress_security_rules.value.stateless
      icmp_options {
        code = ingress_security_rules.value.code
        type = ingress_security_rules.value.type
      }
    }
  }
  dynamic "ingress_security_rules" {
    for_each = [
      { source : "0.0.0.0/0", min : 25000, max : 35000, stateless : true },
      { source : "0.0.0.0/0", min : 443, max : 443, stateless : true },
      { source : "0.0.0.0/0", min : 6443, max : 6443, stateless : true },
      { source : "0.0.0.0/0", min : 22, max : 22, stateless : true, description : "SSH" }
    ]
    content {
      protocol    = "6"
      source      = ingress_security_rules.value.source
      source_type = "CIDR_BLOCK"
      stateless   = ingress_security_rules.value.stateless
      description = try(ingress_security_rules.value.description, null)
      tcp_options {
        max = ingress_security_rules.value.max
        min = ingress_security_rules.value.min
      }
    }
  }
  # Allow all inside OCI network
  ingress_security_rules {
    protocol    = "all"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = true
  }
}

