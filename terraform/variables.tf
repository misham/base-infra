variable "aws_region" {
    description = "AWS region to launch servers."
    default     = "us-west-2"
}

variable "coreos_ami" {
    description = "Default AMI to use for CoreOS"
    default     = "ami-4f7f8a2f"
}

variable "etcd_instance_type" {
    description = "Default instance type for initial etcd cluster"
    default     = "t2.micro"
}

variable "key_name" {
    description = "AWS key to use for instances"
    default     = "coreos-kuber"
}

variable "etcd_cluster_size" {
    description = "Number of instances for initial etcd cluster"
    default     = 3
}

variable "etcd_discovery_token_file_path" {
    description = "Where to store the discovery token"
    default     = "/tmp/etcd_discovery_token.txt"
}
