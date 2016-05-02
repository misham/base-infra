
# Setup all the pieces to spin up etcd inside the VPC

resource "aws_route_table" "etcd" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Application = "etcd"
    }
}

resource "aws_subnet" "etcd" {
    vpc_id                  = "${aws_vpc.default.id}"
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true

    tags {
        Application = "support"
    }
}

resource "aws_route_table_association" "etcd" {
    subnet_id       = "${aws_subnet.etcd.id}"
    route_table_id  = "${aws_route_table.etcd.id}"
}

resource "aws_security_group" "etcd" {
    name    = "etcd"
    vpc_id  = "${aws_vpc.default.id}"

    ingress {
        from_port       = 4001
        to_port         = 4001
        protocol        = "tcp"
        self            = true
        security_groups = []
    }

    ingress {
        from_port       = 2379
        to_port         = 2379
        protocol        = "tcp"
        self            = true
        security_groups = []
    }

    ingress {
        from_port       = 2380
        to_port         = 2380
        protocol        = "tcp"
        self            = true
        security_groups = []
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Application = "etcd"
    }
}

resource "aws_instance" "etcd" {
    ami                     = "${var.coreos_ami}"
    instance_type           = "${var.etcd_instance_type}"
    key_name                = "${var.key_name}"
    count                   = "${var.etcd_cluster_size}"

    subnet_id               = "${aws_subnet.etcd.id}"
    vpc_security_group_ids  = ["${aws_security_group.etcd.id}", "${aws_security_group.ssh.id}"]

    user_data               = "${template_file.etcd_cloud_config.rendered}"

    tags {
        Name        = "etcd-${count.index + 1}"
        Application = "etcd"
    }
}

resource "template_file" "etcd_cloud_config" {
    depends_on  = ["template_file.etcd_discovery_url"]
    template    = "${file("${path.module}/scripts/etcd_cloud_config.yaml.tpl")}"

    vars {
        etcd_discovery_url = "${file(var.etcd_discovery_token_file_path)}"
    }
}

# This is a hack from http://maxenglander.com/2015/06/09/etcd-clusters-with-terraform.html
resource "template_file" "etcd_discovery_url" {
    template = "/dev/null"

    provisioner "local-exec" {
        command = "curl https://discovery.etcd.io/new?size=${var.etcd_cluster_size} > ${var.etcd_discovery_token_file_path}"
    }
}




