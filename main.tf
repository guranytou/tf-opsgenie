terraform {
  required_providers {
    opsgenie = {
      source  = "opsgenie/opsgenie"
      version = "0.6.35"
    }
  }
}

variable "OPSGENIE_API_KEY" {
  type = string
}

provider "opsgenie" {
  api_key = var.OPSGENIE_API_KEY
}

# terraform import opsgenie_user.user {user_id}
resource "opsgenie_user" "user" {
  username  = "test-test@domain.example.com"
  full_name = "testtest"
  role      = "User"
  timezone  = "Asia/Tokyo"
}

resource "opsgenie_user" "gurany" {
  username  = "guranytou@gmail.com"
  full_name = "Yamabuki Akari"
  role      = "Owner"
  timezone  = "Asia/Tokyo"
}

locals {
  team_member = [
    {
      id   = opsgenie_user.gurany.id
      role = "admin"
    },
    {
      id   = opsgenie_user.user.id
      role = "user"
    }
  ]
}

# terraform import opsgenie_team.team {team_id}
resource "opsgenie_team" "team" {
  name = "test"

  dynamic "member" {
    for_each = local.team_member
    content {
      id   = member.value.id
      role = member.value.role
    }
  }
}

# terraform import opsgenie_schedule.test {schedule_id}
resource "opsgenie_schedule" "test" {
  name          = "test_schedule"
  timezone      = "Asia/Tokyo"
  enabled       = true
  owner_team_id = resource.opsgenie_team.team.id
}
