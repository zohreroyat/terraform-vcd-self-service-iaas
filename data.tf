data "vcd_provider_vdc" "pvdc" {
  name = local.provider_vdc_name
}
data "vcd_external_network_v2" "provider_gateway" {
  name = var.provider_gateway_name
}

data "vcd_ip_space" "provider_space" {
  name = local.ip_space_name
}

data "vcd_catalog" "catalog" {
  org  = var.catalog_org
  name = var.catalog_name
}

data "vcd_catalog_vapp_template" "template" {
  catalog_id = data.vcd_catalog.catalog.id
  name       = var.catalog_template_name
}
