variable "github_token" {
  type        = string
  description = "GitHub Personal Access Token with admin:org scope."
  sensitive   = true
}

provider "github" {
  token = var.github_token
  owner = "Nix-Milano"
}

resource "github_organization_settings" "org_settings" {
  billing_email             = "milan@nix.pizza"
  description               = "Nix community in Milan"
  location                  = "Milan, Italy"
  has_organization_projects = true
  has_repository_projects   = true

  members_can_create_repositories         = false
  members_can_create_public_repositories  = false
  members_can_create_private_repositories = false
  members_can_fork_private_repositories   = false # optional

  default_repository_permission = "read" # options: "read", "write", "admin", "none"
}

resource "github_membership" "member" {
  for_each = {
    for member in jsondecode(file("users.json")) :
    member.username => member
  }

  username = each.value.username
  role     = each.value.role
}

resource "github_repository" "infra" {
  name        = "infra"
  description = "Infrastructure"
  visibility  = "private"
}
