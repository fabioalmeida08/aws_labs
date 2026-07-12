# AWS IAM Identity Center Lab

Este projeto utiliza **OpenTofu/Terraform** para automatizar a criação de um usuário no **AWS IAM Identity Center (AWS SSO)**, criar um **Permission Set** com privilégios administrativos e conceder acesso a uma conta Sandbox.

---

## Pré-requisitos

- AWS CLI v2
- OpenTofu
- Credenciais da conta de gerenciamento (Management Account)
- AWS Organizations habilitado
- AWS IAM Identity Center habilitado

Primeiro, ative manualmente o AWS IAM Identity Center no console da AWS.

---

## Configuração

Edite o arquivo `terraform.tfvars`:

```hcl
sso_user_name = ""
sso_user_email = ""

display_name = ""
given_name   = ""
family_name  = ""

sandbox_acc_id = ""
```

### Variáveis

| Variável | Descrição |
|----------|-----------|
| `sso_user_name` | Nome de login do usuário |
| `sso_user_email` | E-mail do usuário |
| `display_name` | Nome exibido |
| `given_name` | Primeiro nome |
| `family_name` | Sobrenome |
| `sandbox_acc_id` | ID da conta Sandbox |

Obtenha o ID da conta Sandbox utilizando:

```bash
aws organizations list-accounts
```

---

## Como executar

```bash
tofu init
tofu plan
tofu apply
```

---

## Recursos criados

- Identity Center User
- Permission Set
- AdministratorAccess Policy Attachment
- Account Assignment para a conta Sandbox

---

## Fluxo

1. Descobre automaticamente a instância do Identity Center.
2. Cria um usuário.
3. Cria um Permission Set.
4. Anexa a política AdministratorAccess.
5. Associa o usuário à conta Sandbox.
6. O usuário recebe um e-mail de convite.
7. Após ativar a conta, pode utilizar `aws sso login`.

---

## Diagrama do fluxo

```
+---------------------------------------------------------------------------------+
| 1. DATA SOURCES & LOCALS (Mapeamento do Terreno)                                |
|                                                                                 |
|  [ data.aws_ssoadmin_instances ] ──> Consulta a API da AWS na conta Root        |
|                                            │                                    |
|  [ locals ] ───────────────────────────────┼──> Extrai as Strings Únicas:       |
|                                            ├──> sso_instance_arn (O motor)      |
|                                            └──> identity_store_id (O banco)     |
+---------------------------------------------------------------------------------+
                                             │
                      ┌──────────────────────┴──────────────────────┐
                      ▼                                             ▼
+-------------------------------------------+ +-----------------------------------+
| 2. USER CREATION (Quem?)                  | | 3. PERMISSION SET (O que pode?)   |
|                                           | |                                   |
|  [ aws_identitystore_user.dev_user ]      | |  [ aws_ssoadmin_permission_set ]  |
|  • user_name: "seu.usuario"               | |  • Nome: "SandboxAdminAccess"     |
|  • email: "seu-email@gmail.com"           | |  • session_duration: "4 Horas"    |
+-------------------------------------------+ +-----------------------------------+
                      │                                             │
                      │                                             ▼
                      │                       +-----------------------------------+
                      │                       | 4. POLICY ATTACHMENT              |
                      │                       |                                   |
                      │                       |  Injeta a política da AWS:        |
                      │                       |  "arn:.../AdministratorAccess"    |
                      │                       +-----------------------------------+
                      │                                             │
                      └──────────────────────┬──────────────────────┘
                                             │
                                             v
+---------------------------------------------------------------------------------+
| 5. THE ACCOUNT VINCLUM / ASSIGNMENT (O Grampo Final)                            |
|                                                                                 |
|  [ aws_ssoadmin_account_assignment.sandbox_assignment ]                         |
|                                                                                 |
|         +------------------+      +--------------------+      +-------------+   |
|         |     USUÁRIO      |  +   |   PERMISSION SET   |  +   | TARGET ACCT |   |
|         |    (Dev User)    |      | (Admin - 4 Horas)  |      |  (Sandbox)  |   |
|         +------------------+      +--------------------+      +-------------+   |
|                  │                          │                        │          |
|                  └──────────────────────────┼────────────────────────┘          |
|                                             ▼                                   |
|                          A AWS junta as 3 pontas do circuito!                   |
+---------------------------------------------------------------------------------+
                                             │
                                             ▼
+---------------------------------------------------------------------------------+
| RESULTADO FINAL NO MUNDO REAL                                                   |
|                                                                                 |
| 1. Você recebe um e-mail de convite da AWS para ativar sua senha.               |
| 2. Ao logar na URL do portal, você enxerga o bloco da conta Sandbox.            |
| 3. No terminal, o comando `aws sso login` te autentica por 4 horas seguidas.    |
+---------------------------------------------------------------------------------+
```

---

## Resultado esperado

1. O usuário recebe um e-mail para ativar o acesso.
2. A conta Sandbox aparece no portal do AWS IAM Identity Center.
3. O comando `aws sso login` autentica o usuário utilizando o Permission Set criado.
