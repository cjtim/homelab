resource "oci_network_load_balancer_network_load_balancer" "lb-1" {
  #Required
  compartment_id                 = var.compartment_id
  display_name                   = "lb-1"
  network_security_group_ids     = [oci_core_network_security_group.lb-ingress.id]
  subnet_id                      = oci_core_subnet.lb.id
  is_preserve_source_destination = false
  nlb_ip_version                 = "IPV4"
  is_private                     = false
}

resource "oci_network_load_balancer_backend_set" "lb-1" {
  #Required
  health_checker {
    #Required
    protocol = "TCP"
    #Optional
    port               = 22
    # url_path           = "/"
    # return_code        = 403
    timeout_in_millis  = 3000
  }
  name                     = "backend-1"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb-1.id
  policy                   = "FIVE_TUPLE"
  ip_version               = "IPV4"
  is_preserve_source       = false
}

resource "oci_network_load_balancer_listener" "lb-1" {
  default_backend_set_name = oci_network_load_balancer_backend_set.lb-1.name
  name                     = "listener-1"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb-1.id
  protocol                 = "TCP_AND_UDP"
  port                     = 0
  ip_version               = "IPV4"
}
