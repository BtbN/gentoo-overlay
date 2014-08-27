# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Qt5 api wrapper and gui for btsync"
HOMEPAGE="https://github.com/BtbN/btsync-qt"
EGIT_REPO_URI="https://github.com/BtbN/btsync-qt.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gui"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	gui? ( dev-qt/qtwidgets:5 )"
RDEPEND="${DEPEND}
	net-p2p/btsync"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with gui)
		-DBTSYNC_BINARY_DEFAULT_PATH="${EPREFIX}/usr/bin/btsync"
	)
	cmake-utils_src_configure
}
