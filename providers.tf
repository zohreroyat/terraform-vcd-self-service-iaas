provider "vcd" {
  url                  = var.vcd_url
  org                  = var.vcd_org
  user                 = var.vcd_user
  password             = var.vcd_password
  allow_unverified_ssl = false
}
