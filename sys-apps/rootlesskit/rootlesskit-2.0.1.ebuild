# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Linux-native \"fake root\" for implementing rootless containers"
HOMEPAGE="https://github.com/rootless-containers/rootlesskit"
SRC_URI="https://github.com/rootless-containers/rootlesskit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"

PROPERTIES="live"

KEYWORDS="amd64"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-rootlesskit )"

src_unpack() {
	default

	cd "${S}" || die
	ego mod vendor
}

src_prepare() {
	sed -e 's:/usr/local/bin:/usr/bin:' -i Makefile || die
	default
}
