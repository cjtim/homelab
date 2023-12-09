resource "oci_core_network_security_group" "lb-ingress" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.kubernetes.id
  display_name   = "Loadbalancer ingress"
}

variable "ports_tcp" {
  default = [
    { max : 443, min : 443 },
    { max : 6443, min : 6443 },
    { max : 32768, min : 25000 },
  ]
}
resource "oci_core_network_security_group_security_rule" "tcp" {
  count                     = length(var.ports_tcp)
  network_security_group_id = oci_core_network_security_group.lb-ingress.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = true
  tcp_options {
    source_port_range {
      max = var.ports_tcp[count.index].max
      min = var.ports_tcp[count.index].min
    }
  }
}

variable "ports_udp" {
  default = [
    { max : 32768, min : 25000 },
  ]
}
resource "oci_core_network_security_group_security_rule" "udp" {
  count                     = length(var.ports_udp)
  network_security_group_id = oci_core_network_security_group.lb-ingress.id
  direction                 = "INGRESS"
  protocol                  = "17" # UDP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = true
  udp_options {
    source_port_range {
      max = var.ports_udp[count.index].max
      min = var.ports_udp[count.index].min
    }
  }
}