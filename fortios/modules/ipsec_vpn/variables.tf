variable "name" {
  description = "The name of the IPsec VPN interface."
  type        = string
  default     = null
}

variable "interface" {
  description = "The interface for the IPsec VPN ."
  type        = string
  default     = null
}

variable "ike_version" {
  type        = string
  default     = "1"
}

variable "dpd" {
  type        = string
  default     = "on-idle"
}

variable "keylife" {
  type        = string
  default     = "28800"
}

variable "peertype" {
  type        = string
  default     = "any"
}

variable "net_device" {
  type        = string
  default     = "disable"
}

variable "proposal_phase1" {
  type        = string
  default     = "3des-sha1"
}

variable "dhgrp" {
  type        = string
  default     = "2"
}

variable "remote_gw" {
  type        = string
  default     = null
}

variable "psksecret" {
  type        = string
  default     = null
}

variable "dpd_retryinterval" {
  type        = string
  default     = "10"
}

variable "nattraversal" {
  type        = string
  default     = "disable"
}

variable "proposal_phase2" {
  type        = string
  default     = "3des-sha1"
}


variable "pfs" {
  type        = string
  default     = "disable"
}

variable "auto_negotiate" {
  type        = string
  default     = "enable"
}

variable "keylifeseconds" {
  type        = string
  default     = "27000"
}
