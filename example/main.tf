resource "azurerm_resource_group" "this" {
  name     = "${var.product}-${var.env}-rg"
  location = var.location

  tags = module.tags.common_tags
}

module "this" {
  source = "../"

  name           = "plum-subscription"
  namespace_name = "plum-servicebus-sandbox"
  topic_name     = "plum-to-cft"

  resource_group_name = azurerm_resource_group.this.name
}

# projects run on Jenkins do not need this module should and should just pass through var.common_tags instead
module "tags" {
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment  = var.env
  product      = var.product
  builtFrom    = var.builtFrom
  expiresAfter = "2023-01-30"
}