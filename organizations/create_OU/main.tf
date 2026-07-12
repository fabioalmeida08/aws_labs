resource "aws_organizations_organizational_unit" "ou_sandbox" {
  name = "OU_Sandbox"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "sandbox" {
  name = "sandbox"
  email = var.acc_email
  parent_id = aws_organizations_organizational_unit.ou_sandbox.id
  role_name = "OrganizationAccountAccessRole"
}
