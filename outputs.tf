output "org_name" {
  value = vcd_org.org.name
}

output "vdc_name" {
  value = vcd_org_vdc.org_vdc.name
}

output "vm_name" {
  value = vcd_vapp_vm.vm.name
}

output "vm_ip" {
  value = vcd_vapp_vm.vm.network[0].ip
}
