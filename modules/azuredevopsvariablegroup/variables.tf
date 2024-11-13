variable "client_id" {
  type        = string
  description = "The application id of the service principal that will be used by the service connection."
}

variable "tenant_id" {
  type        = string
  description = "The tensnt id of the app registration."
}

variable "client_secret" {
  type        = string
  description = "The application scret of the app registration."
  sensitive   = true
}

variable "devops_project_id" {
  type        = string
  description = "The Azure DevOps project id, output from the azuredevops_project resource."
}

variable "variable_group_name" {
  type        = string
  description = "The name of the service connection in Azure DevOps"
}

variable "clientid_secret_name" {
  type        = string
  description = "The name of the clientid secret"
  default     = "clientid"
}

variable "tenantid_secret_name" {
  type        = string
  description = "The name of the tenantid secret"
  default     = "tenantid"
}

variable "clientsecret_secret_name" {
  type        = string
  description = "The name of the clientsecret secret"
  default     = "clientsecret"
}

variable "allow_access" {
  type        = bool
  default     = false
  description = "Boolean that indicate if this variable group is shared by all pipelines of this project"
}
