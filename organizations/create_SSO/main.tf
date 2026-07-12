# 1. Cria o seu usuário no Identity Store
resource "aws_identitystore_user" "dev_user" {
  identity_store_id = local.identity_store_id

  user_name    = var.sso_user_name
  display_name = var.display_name

  name {
    given_name  = var.given_name
    family_name = var.family_name
  }

  emails {
    primary = true
    value   = var.sso_user_email
  }
}

# 2. Cria o Permission Set (Perfil de Permissão) de Administrador
resource "aws_ssoadmin_permission_set" "admin_access" {
  name             = "SandboxAdminAccess"
  description      = "Acesso total de administrador para a conta Sandbox"
  instance_arn     = local.sso_instance_arn
  session_duration = var.sso_session_duration
}

# 3. Atribui a política gerenciada pela AWS (AdministratorAccess) ao Permission Set
resource "aws_ssoadmin_managed_policy_attachment" "admin_policy" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 4. O VÍNCULO: Associa o Usuário à Conta Sandbox com a permissão de Admin
resource "aws_ssoadmin_account_assignment" "sandbox_assignment" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn

  principal_type = "USER"
  principal_id   = aws_identitystore_user.dev_user.user_id

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.sandbox.id # Assume que o recurso da conta está neste mesmo diretório
}
