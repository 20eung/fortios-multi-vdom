provider "fortios" {
  hostname      = "49.50.63.182"
  token         = "9kNtm6bx0nG74ffbd59pdhc8kgsfgp"
  insecure      = "true"
  cabundlefile  = "/home/ubuntu/.ssh/cloud9-terraform.crt"
  vdom          = "root"
}
/*
provider "fortios" {
  alias = "vdom-us"
  vdom  = "VDOM-US"
}

provider "fortios" {
  alias = "vdom-kosite"
  vdom  = "VDOM-KOsite"
}

provider "fortios" {
  alias = "vdom-ussite"
  vdom  = "VDOM-USsite"
}
*/

module "aws_vpn_ko" {

    source              = "./modules/ipsec_vpn"
    
    # IPsec VPN Phase1-interface 설정
    name                = "aws_vpn_ko"
    interface           = "wan1"
    ike_version         = "2"
    dpd                 = "on-idle"
    keylife             = "28800"
    peertype            = "any"
    net_device	        = "disable"
    proposal_phase1	    = "aes128-sha1 3des-sha1 aes256-sha256"
    dhgrp		            = "2"
    remote_gw           = ""
    psksecret	          = "sknetvpn"
    dpd_retryinterval   = "10"
    nattraversal		    = "disable"
    
    # IPsec VPN Phase2-interface 설정
    proposal_phase2		  = "aes128-sha1 3des-sha1 aes256-sha256"
    pfs			            = "disable"
    auto_negotiate      = "enable"
    keylifeseconds	    = "27000"
}