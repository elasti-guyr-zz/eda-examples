import requests
import urllib3
import time
import json

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

#on-prem NetApp Cluster configuration details
source_cluster_name = "<on-prem cluster name>"
source_cluster_mgmt_addr = "<on-prem cluster management IP>"
source_cluster_intercluster_addr = "<on-prem cluster intercluster IP>"
source_cluster_usr = "<on-prem cluster username>"
source_cluster_pswrd = "<on-prem cluster password>”
source_volume_name = "<on-prem cluster source volume name>"
source_svm_name = "<on-prem cluster svm name>"

target_cluster_name = "<GCP CVO name>"
target_cluster_mgmt_addr = "<GCP CVO management IP>"
target_cluster_usr = "<GCP CVO username>"
target_cluster_pswrd = "<GCP CVO password>"
target_aggr_name = "<GCP CVO aggregate name>"
target_volume_name = "<GCP CVO FlexCache volume name>"

#FROM SOURCE NetApp
data = {"authentication":{"generate_passphrase":True}}
response = requests.post('https://{}/api/cluster/peers'.format(source_cluster_mgmt_addr),data=json.dumps(data), verify=False, auth=(source_cluster_usr, source_cluster_pswrd))

print(response.json())
print(response.status_code)

passphrase = json.loads(response.content)
passphrase = passphrase['records'][0]['authentication']['passphrase']

time.sleep(5)

#FROM TARGET NetApp
data = {"remote":{"ip_addresses":[source_cluster_intercluster_addr]}, "authentication":{"passphrase":passphrase}}
response = requests.post('https://{}/api/cluster/peers'.format(target_cluster_mgmt_addr), data=json.dumps(data), verify=False, auth=(target_cluster_usr, target_cluster_pswrd))

print(response.json())
print(response.status_code)
time.sleep(5)

#FROM SOURCE NetApp
data = {"cluster_peer":{"name":target_cluster_name}, "svm":{"name":"*"}, "applications":["flexcache"]}
response = requests.post('https://{}/api/svm/peer-permissions'.format(source_cluster_mgmt_addr),data=json.dumps(data), verify=False, auth=(source_cluster_usr, source_cluster_pswrd))

print(response.json())
print(response.status_code)
time.sleep(10)

#FROM SOURCE NetApp
data = {"vserver":format(source_svm_name),"peer-vserver":"svm_{}".format(target_cluster_name),"peer-cluster":"{}".format(target_cluster_name),"applications":["flexcache"]}
response = requests.post('https://{}/api/private/cli/vserver/peer'.format(source_cluster_mgmt_addr),data=json.dumps(data), verify=False, auth=(source_cluster_usr, source_cluster_pswrd))

print(response.json())
print(response.status_code)
time.sleep(15)

#FROM TARGET NetApp
data = {"vserver":"svm_{}".format(target_cluster_name),"peer-vserver":format(source_svm_name)}
response = requests.post('https://{}/api/private/cli/vserver/peer/accept'.format(target_cluster_mgmt_addr), data=json.dumps(data), verify=False, auth=(target_cluster_usr, target_cluster_pswrd))

print(response.json())
print(response.status_code)
time.sleep(10)

#FROM TARGET NetApp - Target VOLUME creation
data = {"volume":target_volume_name,"aggr-list":["aggr1"],"origin-volume":source_volume_name,"vserver":"svm_{}".format(target_cluster_name),"origin-vserver":format(source_svm_name),"size":"100GB","junction-path":"/{}".format(target_volume_name)}
response = requests.post('https://{}/api/private/cli/volume/flexcache'.format(target_cluster_mgmt_addr), data=json.dumps(data), verify=False, auth=(target_cluster_usr, target_cluster_pswrd))

print(response.json())
print(response.status_code)
time.sleep(5)

#FROM TARGET NetAPP
data = {"policy":"export-svm_{}".format(target_cluster_name)}
response = requests.patch("https://{}/api/private/cli/volume?vserver=svm_{}&volume={}".format(target_cluster_mgmt_addr, target_cluster_name, target_volume_name), data=json.dumps(data), verify=False, auth=(target_cluster_usr, target_cluster_pswrd))

print(response.json())
print(response.status_code)
time.sleep(5)
