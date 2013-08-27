# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvbpsi/libdvbpsi-1.1.0.ebuild,v 1.1 2013/05/08 16:57:38 aballier Exp $

EAPI=5

inherit subversion

DESCRIPTION="library for dvb csa descrambling"
HOMEPAGE="http://www.videolan.org/libdvbcsa"
SRC_URI=""
ESVN_REPO_URI="svn://svn.videolan.org/libdvbcsa/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND=""
DEPEND="sys-devel/automake:1.12"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	./bootstrap || die
	sed -e '/CFLAGS/s:-O2::' -e '/CFLAGS/s:-O6::' -e '/CFLAGS/s:-Werror::' -i configure || die
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/${PN}.la
}
