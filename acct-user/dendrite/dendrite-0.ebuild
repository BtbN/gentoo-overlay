# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Matrix Dendrite User"

ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/${PN}"
ACCT_USER_HOME_OWNER="${PN}:${PN}"
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
