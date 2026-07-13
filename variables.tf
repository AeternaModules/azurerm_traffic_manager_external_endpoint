variable "traffic_manager_external_endpoints" {
  description = <<EOT
Map of traffic_manager_external_endpoints, attributes below
Required:
    - name
    - profile_id
    - target
Optional:
    - always_serve_enabled
    - enabled
    - endpoint_location
    - geo_mappings
    - priority
    - weight
    - custom_header (block):
        - name (required)
        - value (required)
    - subnet (block):
        - first (required)
        - last (optional)
        - scope (optional)
EOT

  type = map(object({
    name                 = string
    profile_id           = string
    target               = string
    always_serve_enabled = optional(bool)
    enabled              = optional(bool)
    endpoint_location    = optional(string)
    geo_mappings         = optional(list(string))
    priority             = optional(number)
    weight               = optional(number)
    custom_header = optional(list(object({
      name  = string
      value = string
    })))
    subnet = optional(list(object({
      first = string
      last  = optional(string)
      scope = optional(number)
    })))
  }))
  validation {
    condition = alltrue([
      for k, v in var.traffic_manager_external_endpoints : (
        length(v.name) > 0
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.traffic_manager_external_endpoints : (
        v.weight == null || (v.weight >= 1 && v.weight <= 1000)
      )
    ])
    error_message = "must be between 1 and 1000"
  }
  validation {
    condition = alltrue([
      for k, v in var.traffic_manager_external_endpoints : (
        v.priority == null || (v.priority >= 1 && v.priority <= 1000)
      )
    ])
    error_message = "must be between 1 and 1000"
  }
  validation {
    condition = alltrue([
      for k, v in var.traffic_manager_external_endpoints : (
        v.subnet == null || alltrue([for item in v.subnet : (item.scope == null || (item.scope >= 0 && item.scope <= 32))])
      )
    ])
    error_message = "must be between 0 and 32"
  }
  # Note: 9 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

