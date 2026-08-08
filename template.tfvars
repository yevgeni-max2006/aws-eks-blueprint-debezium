
###  ---  Default Template  ---  ###
aws_region      = "us-west-2" # \\\ eu-central-1
cluster_name    = "eks-cluster-debezium"
cluster_version = "1.35"
instance_types  = ["t3.medium"]
node_group_desired_size = 3
node_group_min_size     = 3
node_group_max_size     = 7
