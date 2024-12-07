terraform {
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = ">= 2.2.1"
    }
  }
}

provider "pagerduty" {
}

locals {
  users = [
    { name = "jacopen", email = "jacopen@example.com" },
    { name = "yusuke", email = "yusuke@example.com" },
    { name = "kazuki", email = "kazuki@example.com" },
  ]
}


## Web appという名前のServiceを作成
resource "pagerduty_service" "web" {
  name                    = "Web app"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.engineering.id
  alert_creation          = "create_alerts_and_incidents"

  auto_pause_notifications_parameters {
    enabled = true
    timeout = 300
  }
}

resource "pagerduty_escalation_policy" "engineering" {
  name      = "Engineering"
  num_loops = 2

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "user_reference"
      id   = pagerduty_user.jacopen.id
    }
  }
}

## jacopenという名前のユーザーを作成
resource "pagerduty_user" "jacopen" {
  name  = "jacopen"
  email = "jacopen@example.com"
}

locals {
  users = [
    { name = "jacopen", email = "jacopen@example.com" },
    { name = "yusuke", email = "yusuke@example.com" },
    { name = "kazuki", email = "kazuki@example.com" },
  ]
}

resource "pagerduty_user" "user" {
  for_each = { for u in local.users : u.name => u }
  name  = each.value.name
  email = each.value.email
}

resource "pagerduty_service" "cart" {
  name                    = "Cart Service"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.engineering.id
}

resource "pagerduty_service_integration" "cart_apiv2" {
  name            = "API V2"
  type            = "events_api_v2_inbound_integration"
  service         = pagerduty_service.cart.id
}