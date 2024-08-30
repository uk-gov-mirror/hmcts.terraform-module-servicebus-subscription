variable "name" {
  type        = string
  description = "Azure Service Bus subscription name"
}

variable "namespace_id" {
  type        = string
  description = "Azure Service Bus namespace"
}

variable "topic_name" {
  type        = string
  description = "Azure Service Bus topic name"
}

variable "max_delivery_count" {
  type        = number
  description = "Maximum number of attempts to deliver a message before it's sent to dead letter queue"
  default     = 10
}

variable "lock_duration" {
  type        = string
  description = "Message lock duration (ISO-8601)"
  default     = "PT1M"
}

variable "forward_to" {
  type        = string
  description = "Topic or Queue to forwards received messages to"
  default     = ""
}

variable "forward_dead_lettered_messages_to" {
  type        = string
  description = "Topic or Queue to forwards dead lettered messages to"
  default     = ""
}

variable "requires_session" {
  type        = bool
  description = "A value that indicates whether the queue supports the concept of sessions"
  default     = false
}

variable "managed_identity_object_id" {
  default     = null
  description = "the object id of the managed identity - can be retrieved with az identity show --name <identity-name>-sandbox-mi -g managed-identities-<env>-rg --subscription DCD-CFTAPPS-<env> --query principalId -o tsv"
}

variable "sql_filters" {
  type = map(object({
    sql_filter = optional(string)
  }))
  description = "A map of sql filters"
  default     = {}
}

variable "correlation_filters" {
  type = map(object({
    content_type        = optional(string)
    correlation_id      = optional(string)
    label               = optional(string)
    message_id          = optional(string)
    reply_to            = optional(string)
    reply_to_session_id = optional(string)
    session_id          = optional(string)
    to                  = optional(string)
    properties          = optional(map(string))
  }))
  description = "A map of correlation filters to create rules for which messages will be forwarded from the topic to the subscription. If left undefined or empty all messages will be forwarded. Defaults to {}."
  default     = {}

  validation {
    condition = alltrue([
      for name, filter in var.correlation_filters : anytrue([
        for key, value in filter : value != null
      ])
    ])
    error_message = "At least one of \"content_type\", \"correlation_id\", \"label\", \"message_id\", \"reply_to\", \"reply_to_session_id\", \"session_id\", \"to\" or \"properties\" must be set on every correlation_filter block."
  }
}
