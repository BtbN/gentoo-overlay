# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit autotools systemd

DESCRIPTION="decode and send infra-red signals of many commonly used remote controls"
HOMEPAGE="http://www.lirc.org/"

MY_P="${PN}-${PV/_/}"

SRC_URI="mirror://sourceforge/lirc/${MY_P}.tar.bz2"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="x11-libs/libX11
         x11-libs/libSM
         x11-libs/libICE"
DEPEND="${CDEPEND}
        sys-apps/man2html"
RDEPEND="${CDEPEND}"

src_prepare() {
	eapply_user

	eautoreconf
}

src_install() {
	default
	systemd_newtmpfilesd "${FILESDIR}/tmpfiles.conf" lircd.conf
}
