resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyZDfk5NvQFxsCWNurbBhuAx2/Pi9WU55O3n5b7G9OgtGCIVsWUWfFZcmXMSea/E+piUJhPLuMUhXC2cBtHjDfMuza1cYD2k0XvndLPtIIIUb4xuvhjrqBEGyauZS8Tu9MljESn9XKgI5hvXn82ITmKKR9WHk8vxTXDRjZDiKjzfKNwDbdwa4zvoigoDxBvQ3fsITDyOEh1yW5EttYl163uHEPHq9D/vVPgMUT7ip7AL65ITpzWVhsUe5kX/TbkQDTEvaj9rfg3ftNW7zk2tFFjabg1+hLZaq7dJMloGtdTax7+ynykUd3aC0u6r0KpU/aWHjDkGLP6JnRP3qLmRKL1+D3Gg2I6SyOF3bU9xMAY+mGoKw8kWOvVO2CaQfG/XfDQmGzLqWd7iQ3g1twdqWNGr9aFUx5jGQ/tLAcdXsyEMrsO532CWiDRchPm91J1MqAMrjsNO/mA+KIVbJ4KOFTVaV2DsrEYk1OTpd9l5ZSTuRxrhgZrVEmTs55yo2qslM="
}

resource "aws_launch_configuration" "web" {
  name_prefix     = "web-"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id]
  key_name        = "deployer-key"
  user_data       = file("user_data.sh")
}

resource "aws_autoscaling_group" "web" {
  name_prefix          = "asg-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [module.vpc.public_subnets[0],module.vpc.public_subnets[1]]
  load_balancers       = [aws_elb.web.name]
}