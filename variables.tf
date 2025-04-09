#azure credentials 

variable "client_id"  {
  description =  "client id "

}

variable "subscription_id" {
  description = "subscription id"
  
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID associated with the Key Vault."
}

variable "object_id" {
  description = "The object ID of the principal to which permissions will be granted."
}

