terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = ">= 3.14.0"
    }
  }
}
