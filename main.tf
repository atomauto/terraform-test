terraform {
  backend "pg" {}
  required_providers {
    sbercloud = {
      source  = "tf.repo.sbc.space/sbercloud-terraform/sbercloud" # Initialize Cloud.ru provider
      }
  }
}

provider "sbercloud" {
  auth_url = "https://iam.ru-moscow-1.hc.sbercloud.ru/v3" 
  region   = "ru-moscow-1"
  project_name = var.project_name
  access_key = var.access_key
  secret_key = var.secret_key
}

data "sbercloud_availability_zones" "AZ" {}

resource "sbercloud_networking_secgroup" "default" {
  name                 = "${var.project_name}-default"
  delete_default_rules = true
}

resource "sbercloud_networking_secgroup_rule" "out_v4_all" {
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = sbercloud_networking_secgroup.default.id
}

resource "sbercloud_networking_secgroup_rule" "ingress_ssh_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = sbercloud_networking_secgroup.default.id
}

resource "sbercloud_networking_secgroup" "nomad_clients_ingress" {
  name   = "${var.name}-clients-ingress"
  description = "Consul nomad UI security group"
}

resource "sbercloud_networking_secgroup_rule" "nomad_clients_ingress_rule_80" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = sbercloud_networking_secgroup.nomad_clients_ingress.id
}

resource "sbercloud_networking_secgroup" "consul_nomad_ui_ingress" {
  name   = "${var.name}-ui-ingress"
  description = "Consul nomad UI security group"
}

resource "sbercloud_networking_secgroup_rule" "consul_nomad_ui_ingress_rule_4646" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 4646
  port_range_max    = 4646
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = sbercloud_networking_secgroup.consul_nomad_ui_ingress.id
}

resource "sbercloud_networking_secgroup_rule" "consul_nomad_ui_ingress_rule_8500" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8500
  port_range_max    = 8500
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = sbercloud_networking_secgroup.consul_nomad_ui_ingress.id
}