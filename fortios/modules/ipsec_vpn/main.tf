terraform {
  required_providers {
    fortios	= {
	     source	= "fortinetdev/fortios"
	  }
  }
}

# IPsec VPN Phase1-interface 설정
resource "fortios_vpnipsec_phase1interface" "default" {
  name			        = var.name
  interface		      = var.interface
  ike_version       = var.ike_version
  dpd			          = var.dpd
  keylife		        = var.keylife
  peertype		      = var.peertype
  net_device	      = var.net_device
  proposal		      = var.proposal_phase1
  dhgrp			        = var.dhgrp
  remote_gw		      = var.remote_gw
  psksecret		      = var.psksecret
  dpd_retryinterval	= var.dpd_retryinterval
  nattraversal		  = var.nattraversal
}


# IPsec VPN Phase2-interface 설정
resource "fortios_vpnipsec_phase2interface" "default" {
  name			        = var.name
  phase1name		    = var.name
  proposal		      = var.proposal_phase2
  pfs			          = var.pfs
  auto_negotiate    = var.auto_negotiate
  keylifeseconds	  = var.keylifeseconds
}