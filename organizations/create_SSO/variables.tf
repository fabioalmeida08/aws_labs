variable "sso_user_name" {
  type        = string
  description = "Nome de login do usuário no Identity Center"
}

variable "sso_user_email" {
  type        = string
  description = "E-mail para receber o convite de ativação"
}

variable "sso_session_duration" {
  type        = string
  default     = "PT8H"
  description = "Duração da sessão"
}

variable "display_name" {
  type        = string
  description = "Display name para o console"
}

variable "given_name" {
  type        = string
  description = "Given name"
}

variable "family_name" {
  type        = string
  description = "Family name"
}

variable "sandbox_acc_id" {
  type = string
  description = "Acc sandbox string"
}
