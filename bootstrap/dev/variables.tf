
variable "tags" {
  description = "common tags"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "infra"
    owner       = "rodrigo"
  }
}