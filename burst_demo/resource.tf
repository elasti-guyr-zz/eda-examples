terraform {
  required_providers {
    netapp-cloudmanager = {
      source  = "netapp/netapp-cloudmanager"
      version = "21.9.4"
    }
    gcp = {
      source = "hashicorp/google"
      version = "3.84.0"
    }
  }
}

# Define Cloud Manager variables
provider "netapp-cloudmanager" {
  refresh_token = var.refresh_token
}

# Needs to run the export command every time!!!
 provider "google" {
   project = "<PROJECT ID>"
   /* Set credentials by exporting environment variable of json file
   export GOOGLE_APPLICATION_CREDENTIALS="2.json"
   */
 }


locals {
  gcp = {
    project = "<PROJECT ID>"
    network = "<VPC NAME>"
    subnet = "<SUBNET ID NUMBER>"
  }
  netapp = {
    account_id = "<NETAPP ACCOUNT ID>"
    company_name = "<COMPANY NAME FROM NETAPP>"
  }
}
##### NTAP #####

# Build GCP Cloud Manager
resource "netapp-cloudmanager_connector_gcp" "occm_gcp" {
#  depends_on = [
#    google_project_service.rt1611756_services,
#    google_project_iam_custom_role.connector_role,
#    google_service_account.connector_sa,
#    google_service_account_iam_binding.connector_member_cvo
#  ]

  name = "burstdemoconnector"
  zone = "<ZONE TO CREATE THE CONNECTOR>"
  company = "NetApp"
  project_id = local.gcp.project
  service_account_email = "<SERVICE ACCOUNT>"
  service_account_path = "<JSON FILE>.json"
  account_id = local.netapp.account_id
  subnet_id = local.gcp.subnet
  associate_public_ip = true
  firewall_tags = false
}
# Build GCP CVO
resource "netapp-cloudmanager_cvo_gcp" "cvo_gcp_us_central1" {
#  depends_on = [
#    netapp-cloudmanager_connector_gcp.occm_gcp,
#    google_service_account.cvo_sa,
#    google_service_account_iam_binding.connector_member_cvo,
#    google_compute_firewall.cvo_rule
#  ]

  name = "burstcvo1"
  project_id = local.gcp.project
  zone = "<ZONE TO CREATE THE CVOS>"
  gcp_service_account = "<SERVICE ACCOUNT>"
  svm_password = "<NETAPP PASSWORD>"
  client_id = netapp-cloudmanager_connector_gcp.occm_gcp.client_id
  #firewall_rule = google_compute_firewall.cvo_rule.name
  writing_speed_state = "NORMAL"
  license_type = "<NETAPP LICENSE>"
  capacity_package_name = "Essential"
  instance_type = "n1-standard-8"
  # make sure to change the subnet here as well
  gcp_volume_size = "500"
  gcp_volume_size_unit = "GB"
  subnet_id = "<SUBNET NAME>"
  vpc_id = local.gcp.network
}

resource "netapp-cloudmanager_cvo_gcp" "cvo_gcp_us_central2" {
#  depends_on = [
#    netapp-cloudmanager_connector_gcp.occm_gcp,
#    google_service_account.cvo_sa,
#    google_service_account_iam_binding.connector_member_cvo,
#    google_compute_firewall.cvo_rule
#  ]

  name = "burstcvo2"
# Add more CVOs as needed, copy from burstcvo1 and edit the name.
}
