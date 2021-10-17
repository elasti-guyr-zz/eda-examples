#
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cluster_name = "edafarm"
project      = "<project>"
zone         = "us-central1-f"

# network_name            = "<existing network name>"
# subnetwork_name         = "<existing subnetwork name>"
# shared_vpc_host_project = "<vpc host project>"

# disable_controller_public_ips = true
# disable_login_public_ips      = true
# disable_compute_public_ips    = true

# suspend_time  = 300

controller_machine_type = "n1-standard-2"
controller_image        = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-20-11-7-hpc-centos-7"
controller_disk_type    = "pd-standard"
controller_disk_size_gb = 50
# controller_labels = {
#   key1 = "val1"
#   key2 = "val2"
# }
# controller_service_account = "default"
# controller_scopes          = ["https://www.googleapis.com/auth/cloud-platform"]
# cloudsql = {
#   server_ip = "<cloudsql ip>"
#   user      = "slurm"
#   password  = "verysecure"
#   db_name   = "slurm_accounting"
# }
# controller_secondary_disk      = false
# controller_secondary_disk_size = 100
# controller_secondary_disk_type = "pd-ssd"
#
# When specifying an instance template, specified controller fields will
# override the template properties.
# controller_instance_template = null

login_machine_type = "n1-standard-2"
login_image        = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-20-11-7-hpc-centos-7"
login_disk_type    = "pd-standard"
login_disk_size_gb = 20
# login_labels = {
#   key1 = "val1"
#   key2 = "val2"
# }
# login_node_count = 1
# login_node_service_account = "default"
# login_node_scopes          = [
#   "https://www.googleapis.com/auth/monitoring.write",
#   "https://www.googleapis.com/auth/logging.write"
# ]
#
# When specifying an instance template, specified login fields will
# override the template properties.
# login_instance_template = null

# Optional network storage fields
# network_storage is mounted on all instances
# login_network_storage is mounted on controller and login instances
network_storage = [{
    server_ip     = "<home_vol_ip>"
    remote_mount  = "/home"
    local_mount   = "/home"
    fs_type       = "nfs"
    mount_options = "defaults,hard,intr"
  },{
    server_ip     = "<tools_vol_ip>"
    remote_mount  = "/tools"
    local_mount   = "/tools"
    fs_type       = "nfs"
    mount_options = "defaults,hard,intr"
}]
#
# login_network_storage = [{
#   server_ip     = "<storage host>"
#   remote_mount  = "/net_storage"
#   local_mount   = "/shared"
#   fs_type       = "nfs"
#   mount_options = null
# }]

# compute_node_service_account = "default"
# compute_node_scopes          = [
#   "https://www.googleapis.com/auth/monitoring.write",
#   "https://www.googleapis.com/auth/logging.write"
# ]

partitions = [
  { name                 = "debug"
    machine_type         = "n1-standard-2"
    static_node_count    = 0
    max_node_count       = 10
    zone                 = "us-central1-f"
    image                = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-20-11-7-hpc-centos-7"
    image_hyperthreads   = true
    compute_disk_type    = "pd-standard"
    compute_disk_size_gb = 20
    compute_labels       = {}
    cpu_platform         = null
    gpu_count            = 0
    gpu_type             = null
    network_storage      = []
    preemptible_bursting = false
    vpc_subnet           = null
    exclusive            = false
    enable_placement     = false
    regional_capacity    = false
    regional_policy      = {}
    instance_template    = null
  },
  #  { name                 = "partition2"
  #    machine_type         = "c2-standard-16"
  #    static_node_count    = 0
  #    max_node_count       = 20
  #    zone                 = "us-central1-a"
  #    image                = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-20-11-7-hpc-centos-7"
  #    image_hyperthreads   = true
  #
  #    compute_disk_type    = "pd-ssd"
  #    compute_disk_size_gb = 20
  #    compute_labels       = {
  #      key1 = "val1"
  #      key2 = "val2"
  #    }
  #    cpu_platform         = "Intel Skylake"
  #    gpu_count            = 8
  #    gpu_type             = "nvidia-tesla-v100"
  #    network_storage      = [{
  #      server_ip     = "none"
  #      remote_mount  = "<gcs bucket name>"
  #      local_mount   = "/data"
  #      fs_type       = "gcsfuse"
  #      mount_options = "file_mode=664,dir_mode=775,allow_other"
  #    }]
  #    preemptible_bursting = true
  #    vpc_subnet           = null
  #    exclusive            = false
  #    enable_placement     = false
  #
  #    # With regional_capacity : true, the region can be specified in the zone.
  #    # Otherwise the region will be inferred from the zone.
  #    zone = "us-central"
  #    regional_capacity    = true
  #    # Optional
  #    regional_policy      = {
  #        locations = {
  #            "zones/us-central-a" = {
  #                preference = "DENY"
  #            }
  #        }
  #    }
  #
  #    # When specifying an instance template, specified compute fields will
  #    # override the template properties.
  #    instance_template = "my-template"
  #  }
]

