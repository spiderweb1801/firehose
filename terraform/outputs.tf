# output "app_details" {
#     value = {
#         vpc_id = module.app-aps1.network_details.vpc_id
#         public_subnet_ids = module.app-aps1.network_details.public_subnet_ids
#         private_subnet_ids = module.app-aps1.network_details.private_subnet_ids
#         public_rtb  =   module.app-aps1.network_details.public_rtb
#         private_rtb  =   module.app-aps1.network_details.private_rtb
#         ec2_id = module.app-aps1.ec2_details.ec2_id
#         ec2_public_ip = module.app-aps1.ec2_details.ec2_public_ip
#         ec2_private_ip = module.app-aps1.ec2_details.ec2_private_ip
#     }
# }

# output "splunk_details" {
#     value = {
#         vpc_id = module.splunk-aps1.network_details.vpc_id
#         public_subnet_ids = module.splunk-aps1.network_details.public_subnet_ids
#         private_subnet_ids = module.splunk-aps1.network_details.private_subnet_ids
#         public_rtb  =   module.splunk-aps1.network_details.public_rtb
#         private_rtb  =   module.splunk-aps1.network_details.private_rtb
#         ec2_id = module.splunk-aps1.ec2_details.ec2_id
#         ec2_public_ip = module.splunk-aps1.ec2_details.ec2_public_ip
#         ec2_private_ip = module.splunk-aps1.ec2_details.ec2_private_ip
#     }
# }