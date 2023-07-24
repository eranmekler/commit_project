# resource "aws_cognito_user_pool" "commit_users" {
#   name = "commit_users"

  #configure sign-in options
  resource "aws_cognito_user_pool" "commit_users" {
  name = "mypool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  # allow non-admin user to create new users
  admin_create_user_config {
    allow_admin_create_user_only = false
  }


  username_configuration {
    case_sensitive = false
  }

  # configuring the password policy
  password_policy {
    minimum_length = 8
    require_lowercase = anytrue([true])
    require_uppercase = anytrue([true])
    require_numbers = anytrue([true])
    require_symbols = anytrue([true])
  }

  }

# configuration of the cognito hosted ui.need to be configured

resource "aws_cognito_user_pool_domain" "commit_cognito_hosted_ui" {
  domain        = "commit-project-test"
  user_pool_id  = aws_cognito_user_pool.commit_users.id
}

# app_client
# checkout for needed configuration

resource "aws_cognito_user_pool_client" "commit_client" {
  name                                 = "commit_client"
  user_pool_id                         = aws_cognito_user_pool.commit_users.id
  generate_secret                      = true
  allowed_oauth_flows                  = ["code"] #maybe need to be configured to lambda
  allowed_oauth_scopes                 = ["openid", "email"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["${aws_api_gateway_deployment.example.invoke_url}dev/auth", aws_api_gateway_deployment.example.invoke_url]
  default_redirect_uri                 =  "${aws_api_gateway_deployment.example.invoke_url}dev/auth"
  allowed_oauth_flows_user_pool_client = true
  
}

