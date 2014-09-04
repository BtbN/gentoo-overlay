# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils

EGIT_REPO_URI="https://github.com/jpirko/libndp.git"
[[ "${PV}" == "9999" ]] && inherit git-r3

DESCRIPTION="Library for Neighbor Discovery Protocol"
HOMEPAGE="http://libndp.org"
[[ "${PV}" == "9999" ]] || SRC_URI="https://github.com/jpirko/libndp/archive/v${PV}.tar.gz -> ${P}.tar.gz"
AUTOTOOLS_AUTORECONF="1"

LICENSE="GPL-2"
SLOT="0"
IUSE="+logging debug"

if [[ "${PV}" != "9999" ]]; then
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable logging)
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
