# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools git-2

EGIT_REPO_URI="git://github.com/opdenkamp/xbmc-pvr-addons.git"

DESCRIPTION="XBMC Frodo PVR Addons"
HOMEPAGE="http://xbmc.org/"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="with-deps"

COMMON_DEPEND=">=media-tv/xbmc-12.0_rc1
	with-deps? ( virtual/mysql )"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf \
		--prefix=/usr \
		--libdir=/usr/lib/xbmc/addons \
		--datadir=/usr/share/xbmc/addons \
		$(use_enable with-deps addons-with-dependencies) || die "econf failed"
}
