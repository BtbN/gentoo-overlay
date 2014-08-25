# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="Utility to bind the super and other keys to shortcuts"
HOMEPAGE="https://github.com/hanschen/ksuperkey"
EGIT_REPO_URI="https://github.com/hanschen/ksuperkey"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libXtst
	x11-libs/libX11"
RDEPEND="${DEPEND}"
