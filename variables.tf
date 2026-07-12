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
  # --- Unconfirmed validation candidates, derived from azurerm_traffic_manager_external_endpoint's provider source ---
  # Not auto-enabled: either a bespoke provider validator we can't safely translate,
  # or a path that crosses a list-typed block (needs its own for_each wrapping).
  # Review, translate into a real validation{} block above, and delete once confirmed.
  # path: name
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: profile_id
  #   source:    [from profiles.ValidateTrafficManagerProfileID] !ok
  # path: profile_id
  #   source:    [from profiles.ValidateTrafficManagerProfileID] err != nil
  # path: target
  #   source:    validation.NoZeroValues(...) - no translation rule yet, add one
  # path: weight
  #   condition: value >= 1 && value <= 1000
  #   message:   must be between 1 and 1000
  # path: custom_header.name
  #   source:    validation.NoZeroValues(...) - no translation rule yet, add one
  # path: custom_header.value
  #   source:    validation.NoZeroValues(...) - no translation rule yet, add one
  # path: priority
  #   condition: value >= 1 && value <= 1000
  #   message:   must be between 1 and 1000
  # path: subnet.first
  #   source:    [from azValidate.IPv4Address] !ok
  # path: subnet.first
  #   source:    [from azValidate.IPv4Address] four == nil
  # path: subnet.last
  #   source:    [from azValidate.IPv4Address] !ok
  # path: subnet.last
  #   source:    [from azValidate.IPv4Address] four == nil
  # path: subnet.scope
  #   condition: value >= 0 && value <= 32
  #   message:   must be between 0 and 32
}

