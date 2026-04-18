module "databases" {
  for_each = var.databases
  source = "./modules/component"
  
  dns_domain = var.dns_domain
  env = var.env
  component = each.key
  ports = each.value["ports"]
  instance_type = each.value["instance_type"]
}

 module "apps" {
   depends_on = [module.databases]
   source = "./modules/component"
   for_each = var.apps
   
   component = each.key
   dns_domain = var.dns_domain
   env = var.env
   instance_type = each.value["instance_type"]
   ports = each.value["ports"]
 }








