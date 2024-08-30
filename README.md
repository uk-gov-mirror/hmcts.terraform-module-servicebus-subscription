# terraform-module-servicebus-subscription

A Terraform module for creating Azure Service Bus subscription
Refer to the following link for a detailed explanation of the Azure Service Bus subscription.

[Azure Service Bus Subscription](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-queues-topics-subscriptions)

## Usage

The following example shows how to use the module to create an Azure Service Bus subscription. 

```terraform
module "servicebus-subscription" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=4.x"
  name                  = "your-subscription"
  namespace_id          = module.servicebus-namespace.id
  topic_name            = module.servicebus-topic.name
}
```

## azurerm_servicebus_subscription_rule

The following example shows how to add a servicebus subscription rule:

```terraform
locals {
  sql_filters = {
    "hmc-servicebus-aat-subscription-rule-civil" : {
      sql_filter = "hmctsServiceId IN ('AAA7','AAA6')"
    }
  }

  correlation_filters = {
    correlation_filter1 : {
      properties = {
        hmctsProperty = "any"
      }
    }
  }
}
module "servicebus-subscription" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=4.x"
  name                = "your-subscription"
  namespace_id        = module.servicebus-namespace.id
  topic_name          = module.servicebus-topic.name
  sql_filters         = local.sql_filters
  correlation_filters = local.correlation_filters
}
```

## Managed Identity Role Assignment
The following example shows how to give read access to a user assigned managed identity for the subscription:

```terraform
module "servicebus-subscription" {
  source                     = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=4.x"
  name                       = "your-subscription"
  namespace_id               = module.servicebus-namespace.id
  topic_name                 = module.servicebus-topic.name

  # this variable is required
  managed_identity_object_id = "your-mi-object-id"
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.79.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.mi_role_assignment_receiver](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_servicebus_subscription.servicebus_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription) | resource |
| [azurerm_servicebus_subscription_rule.correlation_filter_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription_rule) | resource |
| [azurerm_servicebus_subscription_rule.sql_filter_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription_rule) | resource |
| [azurerm_servicebus_topic.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/servicebus_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_correlation_filters"></a> [correlation\_filters](#input\_correlation\_filters) | A map of correlation filters to create rules for which messages will be forwarded from the topic to the subscription. If left undefined or empty all messages will be forwarded. Defaults to {}. | <pre>map(object({<br>    content_type        = optional(string)<br>    correlation_id      = optional(string)<br>    label               = optional(string)<br>    message_id          = optional(string)<br>    reply_to            = optional(string)<br>    reply_to_session_id = optional(string)<br>    session_id          = optional(string)<br>    to                  = optional(string)<br>    properties          = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_forward_dead_lettered_messages_to"></a> [forward\_dead\_lettered\_messages\_to](#input\_forward\_dead\_lettered\_messages\_to) | Topic or Queue to forwards dead lettered messages to | `string` | `""` | no |
| <a name="input_forward_to"></a> [forward\_to](#input\_forward\_to) | Topic or Queue to forwards received messages to | `string` | `""` | no |
| <a name="input_lock_duration"></a> [lock\_duration](#input\_lock\_duration) | Message lock duration (ISO-8601) | `string` | `"PT1M"` | no |
| <a name="input_managed_identity_object_id"></a> [managed\_identity\_object\_id](#input\_managed\_identity\_object\_id) | the object id of the managed identity - can be retrieved with az identity show --name <identity-name>-sandbox-mi -g managed-identities-<env>-rg --subscription DCD-CFTAPPS-<env> --query principalId -o tsv | `any` | `null` | no |
| <a name="input_max_delivery_count"></a> [max\_delivery\_count](#input\_max\_delivery\_count) | Maximum number of attempts to deliver a message before it's sent to dead letter queue | `number` | `10` | no |
| <a name="input_name"></a> [name](#input\_name) | Azure Service Bus subscription name | `string` | n/a | yes |
| <a name="input_namespace_id"></a> [namespace\_id](#input\_namespace\_id) | Azure Service Bus namespace | `string` | n/a | yes |
| <a name="input_requires_session"></a> [requires\_session](#input\_requires\_session) | A value that indicates whether the queue supports the concept of sessions | `bool` | `false` | no |
| <a name="input_sql_filters"></a> [sql\_filters](#input\_sql\_filters) | A map of sql filters | <pre>map(object({<br>    sql_filter = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Azure Service Bus topic name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->