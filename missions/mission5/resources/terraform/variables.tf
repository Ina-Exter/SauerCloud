#AWS default profile name
variable "profile" {

}

#AWS region
variable "region" {
  default = "us-east-1"
}

#Session ID (fibonacci is debug value)
variable "id" {
  default = "1123581321"
}

#Account ID
variable "accountid" {
  default = "1123581321"
}

#Whitelisted IP
variable "ip" {

}

#SSH key
variable "sshprivatekey" {
  default = "error"
}

variable "sshservicekey" {
  default = "error"
}
