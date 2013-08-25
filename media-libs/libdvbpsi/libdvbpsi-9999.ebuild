# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvbpsi/libdvbpsi-1.1.0.ebuild,v 1.1 2013/05/08 16:57:38 aballier Exp $

EAPI=5

inherit git-2

DESCRIPTION="library for MPEG TS/DVB PSI tables decoding and generation"
HOMEPAGE="http://www.videolan.org/libdvbpsi"
SRC_URI=""
EGIT_REPO_URI="git://git.videolan.org/libdvbpsi.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc static-libs"

RDEPEND=""
DEPEND="
	doc? (
		app-doc/doxygen
		>=media-gfx/graphviz-2.26
	)"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	./bootstrap || die
	sed -e '/CFLAGS/s:-O2::' -e '/CFLAGS/s:-O6::' -e '/CFLAGS/s:-Werror::' -i configure || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-release
}

src_compile() {
	emake
	use doc && emake doc
}

src_install() {
	default
	use doc && dohtml doc/doxygen/html/*
	rm -f "${ED}"usr/lib*/${PN}.la
}

