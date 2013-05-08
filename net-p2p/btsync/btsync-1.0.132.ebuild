# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Sync stuff via BitTorent"
HOMEPAGE="http://labs.bittorrent.com/experiments/sync.html"
SRC_URI="amd64? ( http://syncapp.bittorrent.com/${PV}/${PN}_x64-${PV}.tar.gz )
	x86? ( http://syncapp.bittorrent.com/${PV}/${PN}_i386-${PV}.tar.gz )
	ppc? ( http://syncapp.bittorrent.com/${PV}/${PN}_powerpc-${PV}.tar.gz )
	arm? ( http://syncapp.bittorrent.com/${PV}/${PN}_arm-${PV}.tar.gz )"

LICENSE="BitTorrent"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~ppc"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	dodoc "${S}/LICENSE.TXT"
	dobin "${S}/btsync"
}
