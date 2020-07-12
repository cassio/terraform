data "aws_availability_zones" "available" {}

resource "aws_vpc" "VPC_Neon" {
  cidr_block           = var.vpcCIDRblock
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  instance_tenancy = "default"
tags = {
    Name = "VPC Neon"
}
}

resource "aws_subnet" "Neon_subnet_us_east_2a" {
  vpc_id     = aws_vpc.VPC_Neon.id
  cidr_block = "10.7.10.0/24"
  map_public_ip_on_launch = var.mapNeonPublicIP
  availability_zone = "us-east-2a"

  tags = {
    Name = "Neon Subnet us-east-2a"
  }
}

resource "aws_subnet" "Neon_subnet_us_east_2b" {
  vpc_id     = aws_vpc.VPC_Neon.id
  cidr_block = "10.7.11.0/24"
  map_public_ip_on_launch = var.mapNeonPublicIP 
  availability_zone = "us-east-2b"

  tags = {
    Name = "Neon Subnet us-east-2b"
  }
}

resource "aws_subnet" "Neon_subnet_us_east_2c" {
  vpc_id     = aws_vpc.VPC_Neon.id
  cidr_block = "10.7.12.0/24"
  map_public_ip_on_launch = var.mapNeonPublicIP 
  availability_zone = "us-east-2c"

  tags = {
    Name = "Neon Subnet us-east-2c"
  }
}

resource "aws_internet_gateway" "IGW_Neon" {
 vpc_id = aws_vpc.VPC_Neon.id
 tags = {
        Name = "Internet gateway Neon"
}
}

resource "aws_route_table" "Neon_RT" {
 vpc_id = aws_vpc.VPC_Neon.id
 tags = {
        Name = "Neon Route table"
}
}

resource "aws_route" "Neon_internet_access" {
  route_table_id         = aws_route_table.Neon_RT.id
  destination_cidr_block = var.publicdestCIDRblock
  gateway_id             = aws_internet_gateway.IGW_Neon.id
}

resource "aws_route_table_association" "Neon_us_east_2a" {
    subnet_id = aws_subnet.Neon_subnet_us_east_2a.id
    route_table_id = aws_route_table.Neon_RT.id
}

resource "aws_route_table_association" "Neon_us_east_2b" {
    subnet_id = aws_subnet.Neon_subnet_us_east_2b.id
    route_table_id = aws_route_table.Neon_RT.id
}

resource "aws_route_table_association" "Neon_us_east_2c" {
    subnet_id = aws_subnet.Neon_subnet_us_east_2c.id
    route_table_id = aws_route_table.Neon_RT.id
}

resource "aws_launch_configuration" "neonwebcluster" {
    image_id=  var.ami
    instance_type = var.instance_type
    security_groups = [aws_security_group.websg.id]
    key_name = aws_key_pair.awskeypair.key_name
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_key_pair" "awskeypair" {
    key_name = "lab_cloud_key_ohio-cassio"
    public_key = file(var.key_path)
}

resource "aws_autoscaling_group" "neonscalegroup" {
    launch_configuration = aws_launch_configuration.neonwebcluster.name
    availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
    min_size = 2
    max_size = 3
    enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
    metrics_granularity="1Minute"
    load_balancers= [aws_elb.elbneon.id]
    health_check_type = "ELB"
    vpc_zone_identifier  = [
                "${aws_subnet.Neon_subnet_us_east_2a.id}",
                "${aws_subnet.Neon_subnet_us_east_2b.id}",
                "${aws_subnet.Neon_subnet_us_east_2c.id}"
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "autopolicy" {
    name = "neon-autoplicy"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.neonscalegroup.name 

}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
    alarm_name = "neon-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "60"

    dimensions = {
        AutoScalingGroupName =  aws_autoscaling_group.neonscalegroup.name
    }
    alarm_description = "This metric monitor EC2 instance cpu utilization"
    alarm_actions = [aws_autoscaling_policy.autopolicy.arn]
}

resource "aws_autoscaling_policy" "autopolicy-down" {
    name = "neon-autoplicy-down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.neonscalegroup.name
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
    alarm_name = "neon-alarm-down"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "10"

    dimensions = {
        AutoScalingGroupName =  aws_autoscaling_group.neonscalegroup.name
    }
    alarm_description = "This metric monitor EC2 instance cpu utilization"
    alarm_actions = [aws_autoscaling_policy.autopolicy-down.arn]
}

resource "aws_security_group" "websg" {
    name = "security_group_for_web_server"
    vpc_id = aws_vpc.VPC_Neon.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.elbsg.id]
   }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "elbsg" {
    name = "security_group_for_elb"
    vpc_id = aws_vpc.VPC_Neon.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_elb" "elbneon" {
  depends_on = [
    aws_subnet.Neon_subnet_us_east_2c
  ]
    name = "neon-elb"
    security_groups = [aws_security_group.elbsg.id]
    subnets = [
                "${aws_subnet.Neon_subnet_us_east_2a.id}",
                "${aws_subnet.Neon_subnet_us_east_2b.id}",
                "${aws_subnet.Neon_subnet_us_east_2c.id}"
  ]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }

    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    tags = {
        Name = "neon-elb"
    }
}

output "availabilityzones" {
    value = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

output "elb-dns" {
    value = aws_elb.elbneon.dns_name
}
