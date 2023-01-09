output "web_lb_url" {
  value = aws_elb.web.dns_name
}