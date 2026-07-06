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
    always_serve_enabled = optional(bool) # Default: false
    enabled              = optional(bool) # Default: true
    endpoint_location    = optional(string)
    geo_mappings         = optional(list(string))
    priority             = optional(number)
    weight               = optional(number) # Default: 1
    custom_header = optional(object({
      name  = string
      value = string
    }))
    subnet = optional(object({
      first = string
      last  = optional(string)
      scope = optional(number)
    }))
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
        v.subnet == null || (v.subnet.scope == null || (v.subnet.scope >= 0 && v.subnet.scope <= 32))
      )
    ])
    error_message = "must be between 0 and 32"
  }
  # --- Unconfirmed validation candidates, derived from azurerm_traffic_manager_external_endpoint's provider source ---
  # Not auto-enabled: either a bespoke provider validator we can't safely translate,
  # or a path that crosses a list-typed block (needs its own for_each wrapping).
  # Review, translate into a real validation{} block above, and delete once confirmed.
  # path: profile_id
  #   source:    [from profiles.ValidateTrafficManagerProfileID] !ok
  # path: profile_id
  #   source:    [from profiles.ValidateTrafficManagerProfileID] err != nil
  # path: target
  #   source:    validation.NoZeroValues(...) - no translation rule yet, add one
  # path: custom_header.name
  #   source:    validation.NoZeroValues(...) - no translation rule yet, add one
  # path: custom_header.value
  #   source:    validation.NoZeroValues(...) - no translation rule yet, add one
  # path: subnet.first
  #   source:    [from azValidate.IPv4Address] !ok
  # path: subnet.first
  #   source:    [from azValidate.IPv4Address] four == nil
  # path: subnet.last
  #   source:    [from azValidate.IPv4Address] !ok
  # path: subnet.last
  #   source:    [from azValidate.IPv4Address] four == nil
}

