# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils git-2

EGIT_REPO_URI="https://github.com/opdenkamp/xbmc-pvr-addons.git"

DESCRIPTION="XBMC Frodo PVR Addons"
HOMEPAGE="http://xbmc.org/"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

COMMON_DEPEND=">=media-tv/xbmc-14.0"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

PVR_ADDON="${PN/xbmc-pvr-addon-/}"

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf \
		--prefix=/usr \
		--libdir=/usr/lib/xbmc/addons \
		--datadir=/usr/share/xbmc/addons \
		|| die "econf failed"
}

src_compile() {
	emake -C "lib/libhts" || die "emake failed"
	emake -C "addons/pvr.${PVR_ADDON}" || die "emake failed"
}

src_install() {
	emake -C "addons/pvr.${PVR_ADDON}" install DESTDIR="${ED}" || die "emake install failed"

	mv "${ED}/usr/share/xbmc" "${ED}/usr/share/kodi"
	mv "${ED}/usr/lib/xbmc" "${ED}/usr/lib/kodi"
}
