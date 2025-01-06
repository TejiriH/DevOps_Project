data "aws_ssm_parameter" "db_username" {
  name            = "/myapp/db/username"
  with_decryption = true
}

data "aws_ssm_parameter" "db_password" {
  name            = "/myapp/db/password"
  with_decryption = true
}
