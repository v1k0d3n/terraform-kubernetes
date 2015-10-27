#
# Welcome to the Terraform Kubernetes Lab provided by v1k0d3n.
# http://github.com/v1k0d3n/tform-ostack-kubelab
# 2015-10-26
# Feel free to use and update as you wish, but please give
# give back to the open-source community and credit the
# folks who have helped you learn new things along the way!
# Brandon B. Jozsa
#
/* Kubemaster Deployment */
resource "openstack_compute_instance_v2" "kubemaster" {
  user_data = <<EOF
#cloud-config
hostname: kubemaster.kubelab.com
password: ${var.root_password}
ssh_pwauth: True
chpasswd: { expire: False }
ssh_authorized_keys:
  - ssh-rsa ${var.ssh_key_hash}
EOF
  name = "kubemaster"
  image_name = "${var.kubemaster_image}"
  flavor_name = "${var.kubemaster_flavor}"
  key_pair = "${openstack_compute_keypair_v2.terraform-key.name}"
  security_groups = [
  "${openstack_compute_secgroup_v2.kubelab-default.name}",
  "${openstack_compute_secgroup_v2.kubelab-kubernetes.name}",
  "${openstack_compute_secgroup_v2.kubelab-kube-mgnt.name}",
  "${openstack_compute_secgroup_v2.kubelab-nodeport-tests.name}"
  ]
  floating_ip = "${openstack_compute_floatingip_v2.kubemaster_dev_float.address}"
  network {
    uuid = "${openstack_networking_network_v2.ext_net.id}"
    fixed_ip_v4 = "${var.kubemaster_fixed_ipv4}"
  }
  connection {
    user = "${var.kubemaster_ssh_user_name}"
    key_file = "${var.ssh_key_file}"
  }
  provisioner "local-exec" {
    command = "echo ${openstack_compute_floatingip_v2.kubemaster_dev_float.address} kubemaster.kubelab.com kubemaster > hosts-out"
  }
  provisioner "file" {
    source = "kubemaster"
    destination = "/home/fedora/kubemaster"
  }
  provisioner "remote-exec" {
    inline = [
    "sudo mv -f /home/fedora/kubemaster/fedora-updates-testing.repo /etc/yum.repos.d/fedora-updates-testing.repo",
    "sudo mv -f /home/fedora/kubemaster/cockpit-testing.repo /etc/yum.repos.d/cockpit-testing.repo",
    "sudo dnf update -y",
    "sudo mv -f /home/fedora/kubemaster/hosts /etc/hosts",
    "sudo mv -f /home/fedora/kubemaster/selinux /etc/sysconfig/selinux",
    "sudo systemctl disable iptables firewalld",
    "sudo systemctl stop iptables firewalld",
    "sudo dnf install -y git python flannel kubernetes cockpit cockpit-kubernetes etcd docker golang-github-kubernetes-heapster-devel kubernetes-unit-test",
    "sudo mv -f /home/fedora/kubemaster/docker /etc/sysconfig/docker",
    "sudo mv -f /home/fedora/kubemaster/kubemaster_etcd.conf /etc/etcd/etcd.conf",
    "sudo mv -f /home/fedora/kubemaster/kubemaster_kube.config /etc/kubernetes/config",
    "sudo mv -f /home/fedora/kubemaster/kubemaster_kube.api /etc/kubernetes/apiserver",
    "sudo mv -f /home/fedora/kubemaster/kubemaster_kube.cman /etc/kubernetes/controller-manager",
    "sudo mv -f /home/fedora/kubemaster/kubemaster_kube.kube /etc/kubernetes/kubelet",
    "sudo mv -f /home/fedora/kubemaster/kubemaster_kube.proxy /etc/kubernetes/proxy",
    "sudo mv -f /home/fedora/kubemaster/flanneld /etc/sysconfig/flanneld",
    "sudo systemctl enable cockpit.socket",
    "sudo systemctl start cockpit.socket",
    "sudo systemctl enable etcd kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy",
    "sudo systemctl start docker etcd kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy",
    "curl -L http://localhost:2379/v2/keys/kubelab/network/config -XPUT --data-urlencode value@/home/fedora/kubemaster/flanneld-conf.json",
    "mkdir -p /home/fedora/github",
    "cd /home/fedora/github",
    "git clone https://github.com/kubernetes/kubernetes.git",
    "git clone https://github.com/v1k0d3n/kubelab.git",
    "git clone https://github.com/henszey/etcd-browser.git",
    "cd etcd-browser",
    "sudo docker build -t etcd-browser .",
    "sudo docker run --restart=always -d --name etcd-browser -p 0.0.0.0:8000:8000 --env ETCD_HOST=10.8.80.10 etcd-browser",
    "sudo reboot"
    /* "sudo reboot" */
  ]
  }
}
