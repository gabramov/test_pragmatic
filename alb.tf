resource "aws_elb" "web" {
  name               = "loadbalancer"
  security_groups    = [aws_security_group.web.id]
  subnets            = [module.vpc.public_subnets[0],module.vpc.public_subnets[1]]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 8080
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
}