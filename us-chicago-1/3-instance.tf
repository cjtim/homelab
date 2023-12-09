resource "oci_core_instance" "a1-1" {
  compartment_id      = var.compartment_id
  availability_domain = var.AD_ZONE
  display_name        = "a1-1"
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = "24"
    ocpus         = "4"
  }
  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip = "true"
    hostname_label   = "a1-1"
    private_ip       = "10.0.0.101"
    subnet_id        = oci_core_subnet.default.id
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
	is_pv_encryption_in_transit_enabled = "true"
  metadata = {
    "user_data"           = filebase64("cloud-init.yaml")
    "ssh_authorized_keys" = var.ssh_key
  }
  source_details {
    boot_volume_size_in_gbs = "200"
    boot_volume_vpus_per_gb = "120"
		source_id = "ocid1.image.oc1.us-chicago-1.aaaaaaaaeknhneskytsxnm2akrfyhqklomdhmje22fi7zdcysw6mg6p23zxa"
    source_type             = "image"
  }
  agent_config {
		is_management_disabled = "false"
		is_monitoring_disabled = "false"
		plugins_config {
			desired_state = "DISABLED"
			name = "Vulnerability Scanning"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Compute RDMA GPU Monitoring"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Compute Instance Monitoring"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Compute HPC RDMA Auto-Configuration"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Compute HPC RDMA Authentication"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Block Volume Management"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Bastion"
		}
	}

  provisioner "remote-exec" {
    when = create
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = self.public_ip
    }
    inline = [
      "uname -a"
    ]
  }

}

resource "null_resource" "ansible" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
cat << 'EOF' > ./ansible/hosts.yml
oracle:
  hosts:
    a1-1:
      ansible_host: ${oci_core_instance.a1-1.public_ip}
      ansible_ssh_user: ubuntu
EOF
EOT
  }
  provisioner "local-exec" {
    command = "cd ansible && ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_CONFIG=ansible.cfg ansible-playbook site.yml"
  }
  # Cleanup
  provisioner "local-exec" {
    command = "rm ./ansible/hosts.yml"
  }
}

resource "oci_network_load_balancer_backend" "a1-1" {
  #Required
  backend_set_name         = oci_network_load_balancer_backend_set.lb-1.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb-1.id
  port                     = 0

  #Optional
  ip_address = oci_core_instance.a1-1.private_ip
  is_backup  = false
  is_drain   = false
  is_offline = false
  weight     = 1
}