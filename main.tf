data "azurerm_servicebus_topic" "this" {
  name                = var.topic_name
  namespace_id        = var.namespace_id
}

resource "azurerm_servicebus_subscription" "servicebus_subscription" {
  name     = var.name
  topic_id = data.azurerm_servicebus_topic.this.id

  lock_duration                     = var.lock_duration
  max_delivery_count                = var.max_delivery_count
  forward_to                        = var.forward_to
  forward_dead_lettered_messages_to = var.forward_dead_lettered_messages_to

  requires_session                     = var.requires_session
  dead_lettering_on_message_expiration = true
  enable_batched_operations            = false
  default_message_ttl                  = "P10675199DT2H48M5.4775807S"
  auto_delete_on_idle                  = "P10675199DT2H48M5.4775807S"
}

resource "azurerm_servicebus_subscription_rule" "sql_filter_rule" {
  for_each        = var.sql_filters
  name            = each.key
  subscription_id = azurerm_servicebus_subscription.servicebus_subscription.id
  filter_type     = "SqlFilter"
  sql_filter      = lookup(each.value, "sql_filter", null)

}

resource "azurerm_servicebus_subscription_rule" "correlation_filter_rules" {
  for_each = var.correlation_filters

  name        = each.key
  filter_type = "CorrelationFilter"

  subscription_id = azurerm_servicebus_subscription.servicebus_subscription.id

  correlation_filter {
    content_type        = lookup(each.value, "content_type", null)
    correlation_id      = lookup(each.value, "correlation_id", null)
    label               = lookup(each.value, "label", null)
    message_id          = lookup(each.value, "message_id", null)
    reply_to            = lookup(each.value, "reply_to", null)
    reply_to_session_id = lookup(each.value, "reply_to_session_id", null)
    session_id          = lookup(each.value, "session_id", null)
    to                  = lookup(each.value, "to", null)
    properties          = lookup(each.value, "properties", null)
  }
}
