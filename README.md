# Homelab server

Oracle cloud always FREE plan!!

![](./diagram.svg)

## Provision steps
1. Create Oracle cloud infrastructure
   1. VPC (10.0.0.0/16)
   2. 2 Subnet
      1. Subnet A (Servers - 10.0.0.0/24)
      2. Subnet B (Load balancer - 10.0.1.0/24)
   3. Security lists
      1. Subnet A
         1. Allow ingress from Load Balancer subnet (10.0.1.0/24)
         2. Allow egress to 0.0.0.0/0
      2. Subnet B
         1. Allow ingress from 0.0.0.0/0 to HTTPS (443)
         2. Allow ingress from 0.0.0.0/0 to NodePort (25000-35000)
         3. Allow ingress from 0.0.0.0/0 to Kubernetes API Server (6443)
         4. Allow egress to 0.0.0.0/0
   4. Security groups
   5. Network Load Balancer
      1. L4 load balancer
      2. TCP/UDP
   6. Instance
      1. a1-1 (4vCPU, 24GB, 200GB disk)
         1. Cloud-init script are spliting partition 1 to 50GB, partition 2 150GB
2. Run Ansible (Always run)
   1. Install Containerd, CNI, Kubeadm, Kubelet, Kubectl
   2. Copy Containerd configuration, sysctl