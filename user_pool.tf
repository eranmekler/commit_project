resource "aws_cognito_user_pool" "commit_users" {
  name = "commit_users"

  #configure sign-in options
  username_attributes = ["username"]
  auto_verified_attributes = ["email"]

  # allow non-admin user to create new users
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  schema {
    attribute_data_type = ""
    name                = ""

  }

  username_configuration {
    case_sensitive = false
  }

  # configuring the password policy
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

  # default cognito mail to send verification message
  email_configuration {
    from_email_address = "no-reply@verificationemail.com"
  }
}

# configuration of the cognito hosted ui.need to be configured

resource "aws_cognito_user_pool_domain" "commit_cognito_hosted_ui" {
  domain        = "commit_project"
  user_pool_id  = aws_cognito_user_pool.commit_users.id
}

# app_client
# checkout for needed configuration

resource "aws_cognito_user_pool_client" "commit_client" {
  name                                 = "commit_client"
  user_pool_id                         = aws_cognito_user_pool.commit_users.id
  generate_secret                      = false
  allowed_oauth_flows                  = ["code"] #maybe need to be configured to lambda
  allowed_oauth_scopes                 = ["openid", "email"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["https://example.com/callback"]
  default_redirect_uri                 = "https://example.com/callback"
  allowed_oauth_flows_user_pool_client = true
}

