################ ORG ################

resource "vcd_org" "org" {
  name      = var.tenant_name
  full_name = var.tenant_name
  description = "ORG for ${var.tenant_name}"

  delete_recursive = false
  delete_force     = false
}

################ VDC ################

resource "vcd_org_vdc" "org_vdc" {
  name        = "${var.tenant_name}-vdc"
  org         = vcd_org.org.name
  description = "Org VDC for ${var.tenant_name}"

  allocation_model  = local.allocation_model
  provider_vdc_name = data.vcd_provider_vdc.pvdc.name
  network_pool_name = local.network_pool_name

  nic_quota     = 1000       
  network_quota = 100  


  storage_profile {
    name    = local.storage_policy
    enabled = true
    default = true
    limit   = 0
  }

  compute_capacity {
    cpu {
      allocated = 2000
      limit     = 4000
    }
    memory {
      allocated = 4096
      limit     = 8192
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

################ NETWORK ################

resource "vcd_nsxt_edgegateway" "org_edge" {
  org      = vcd_org.org.name
  name     = "${var.tenant_name}-edge"
  owner_id = vcd_org_vdc.org_vdc.id
  external_network_id = data.vcd_external_network_v2.provider_gateway.id
}

resource "vcd_ip_space_ip_allocation" "tenant_prefix" {
  org_id      = vcd_org.org.id
  ip_space_id = data.vcd_ip_space.provider_space.id
  type        = "IP_PREFIX"
  prefix_length = var.network_prefix_length
  depends_on = [vcd_nsxt_edgegateway.org_edge]
}

resource "vcd_network_routed_v2" "org_net" {
  name            = "${var.tenant_name}-routed-net"
  org             = vcd_org.org.name
  edge_gateway_id = vcd_nsxt_edgegateway.org_edge.id

  gateway = cidrhost(
    vcd_ip_space_ip_allocation.tenant_prefix.ip_address, 1
  )

  prefix_length = tonumber(
    split("/", vcd_ip_space_ip_allocation.tenant_prefix.ip_address)[1]
  )

  static_ip_pool {
    start_address = cidrhost(
      vcd_ip_space_ip_allocation.tenant_prefix.ip_address, 2
    )
    end_address = cidrhost(
      vcd_ip_space_ip_allocation.tenant_prefix.ip_address, 10
    )
  }
}

################ VAPP + VM ################

resource "vcd_vapp" "tenant_vapp" {
  name = "${var.tenant_name}-vapp"
  org  = vcd_org.org.name
  vdc  = vcd_org_vdc.org_vdc.name
}

resource "vcd_vapp_org_network" "vapp_network_attach" {
  org              = vcd_org.org.name
  vdc              = vcd_org_vdc.org_vdc.name
  vapp_name        = vcd_vapp.tenant_vapp.name
  org_network_name = vcd_network_routed_v2.org_net.name
}

resource "vcd_vapp_vm" "vm" {
  name      = "${var.tenant_name}-vm-1"
  vapp_name = vcd_vapp.tenant_vapp.name
  org       = vcd_org.org.name
  vdc       = vcd_org_vdc.org_vdc.name

  vapp_template_id = data.vcd_catalog_vapp_template.template.id

  memory    = local.vm_flavors[var.vm_flavor].memory
  cpus      = local.vm_flavors[var.vm_flavor].cpus
  cpu_cores = 1

  power_on  = true

  network {
    type               = "org"
    name               = vcd_network_routed_v2.org_net.name
    ip_allocation_mode = "POOL"
  }
}

resource "vcd_vm_internal_disk" "extra_disk" {
  vapp_name = vcd_vapp.tenant_vapp.name
  vm_name   = vcd_vapp_vm.vm.name
  vdc       = vcd_org_vdc.org_vdc.name
  org       = vcd_org.org.name

  size_in_mb = local.vm_flavors[var.vm_flavor].disk * 1024
  bus_type   = "paravirtual"
  bus_number = 1
  unit_number = 0
  storage_profile = local.storage_policy
}   
