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
}

