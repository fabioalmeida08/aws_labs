# Lab ativando SSO com Identity Center

---

## Steps
    1. Primeiro ativar o identity center no painel da aws de forma manual
    2. configurar as variaveis no arquivo terraform.tfvars
        - sso_user_name
        - sso_user_email
        - display_name = "Fabio Almeida"
        - given_name
        - family_name
        - sandbox_acc_id 
        pegar id da conta usando o comando:
            aws cli aws organizations list-accounts

## Como rodar o projeto

```
$ tofu init
$ tofu plan
$ tofu apply
```

## Diagrama visual do fluxo

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
