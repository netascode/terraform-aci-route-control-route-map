variable "name" {
  description = "Route Control Route Map name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "tenant" {
  description = "Route Control Route Map Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Route Control Route Map description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "contexts" {
  description = "Route Control Route Map contexts."
  type = list(object({
    name        = string
    description = optional(string, "")
    action      = optional(string, "permit")
    order       = optional(number, 0)
    set_rule    = optional(string, "")
    match_rules = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for ctx in var.contexts : ctx.name == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", ctx.name))
    ])
    error_message = "Context `name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for ctx in var.contexts : ctx.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", ctx.description))
    ])
    error_message = "Context `description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for ctx in var.contexts : ctx.action == null || contains(["deny", "permit"], ctx.action)
    ])
    error_message = "Context `action`: Valid values are `deny` or `permit`."
  }

  validation {
    condition = alltrue([
      for ctx in var.contexts : ctx.order >= 0 && ctx.order <= 9
    ])
    error_message = "Allowed values Context `order`: 0-9."
  }

}