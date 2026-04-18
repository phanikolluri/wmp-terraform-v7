resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "${var.component}-${var.env}"
  type    = "A"
  ttl     = 300
  records = [var.private_ip]
}