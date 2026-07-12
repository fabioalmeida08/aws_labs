# Busca a instância ativa do Identity Center na conta 
data "aws_ssoadmin_instances" "main" {}

# Limpa as listas do bloco data e joga em variáveis locais mais simples
locals {
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}
