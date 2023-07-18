resource "aws_cognito_user_pool" "commit_users" {
  name = "commit_users"

  #configure sign-in options
  username_attributes = ["username"]
  username_configuration {
    case_sensitive = false
  }
  # configuration the password policy
  password_policy {
    minimum_length = 8
    require_lowercase = anytrue()
    require_uppercase = anytrue()
    require_numbers = anytrue()
    require_symbols = anytrue()
  }
  account_recovery_setting {
    recovery_mechanism {
      name     = "VerifiedEmail"
      priority = 1
    }
  }
}