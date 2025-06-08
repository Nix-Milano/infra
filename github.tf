terraform {
  encryption {
    key_provider "pbkdf2" "state-key" {
      passphrase = var.opentofu_passphrase
    }

    method "aes_gcm" "encryption_method" {
      keys = key_provider.pbkdf2.state-key
    }

    state {
      method   = method.aes_gcm.encryption_method
      enforced = true
    }
  }
}

variable "opentofu_passphrase" {
  type        = string
  description = "Passphrase for encrypting/decrypting the state file."
  sensitive   = true
}

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
  visibility  = "public"
}

resource "github_organization_ruleset" "strict-rules" {
  name        = "strict-rules"
  target      = "branch" # Targeting branches (not tags)
  enforcement = "active" # Enforced immediately

  conditions {
    # Apply ruleset to all repositories
    repository_name {
      include = ["~ALL"]
      exclude = []
    }

    # Apply to all branches within included repositories
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  rules {
    creation                = true # Disallow branch creation unless bypass is granted
    update                  = true # Disallow branch updates unless bypass is granted
    deletion                = true # Disallow branch deletion unless bypass is granted
    required_linear_history = true # Disallow merge commits, enforce linear history
    required_signatures     = true # Only allow signed commits

    branch_name_pattern {
      name     = "Main branch naming rule"
      operator = "equals"
      pattern  = "master" # Only allow branches that start with 'master'
      negate   = false
    }

    commit_message_pattern {
      name     = "No WIP in commit messages"
      operator = "contains"
      pattern  = "WIP"
      negate   = true # Disallow commit messages containing "WIP"
    }

    pull_request {
      dismiss_stale_reviews_on_push     = true # Require re-review after new commits
      require_last_push_approval        = true # Last push must be approved by someone else
      required_approving_review_count   = 1    # Require at least 1 approvals
      required_review_thread_resolution = true # All conversations must be resolved
    }

  }
}
