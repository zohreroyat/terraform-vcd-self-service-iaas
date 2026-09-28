locals {
  provider_vdc_name = "Name_provider_vdc_name"
  network_pool_name = "Name_network_pool_name"
  storage_policy    = "Name_storage_policy"
  allocation_model  = "AllocationVApp"

#AllocationVApp->Pay As You Go
#AllocationPool->Allocation Pool
#ReservationPool->Reservation Pool


  vm_flavors = {
    1 = { cpus = 4, memory = 8192, disk = 10 }
    2 = { cpus = 8, memory = 16384, disk = 12 }
    3 = { cpus = 8, memory = 32768, disk = 15 }
  }
}

