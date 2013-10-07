# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 autotools-utils

DESCRIPTION="Tox is a FOSS encrypted instant messaging library"
HOMEPAGE="https://github.com/irungentoo/ProjectTox-Core/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/irungentoo/ProjectTox-Core.git"
AUTOTOOLS_AUTORECONF="1"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="ntox dht-bootstrap-daemon"

DEPEND="
	>=dev-libs/libsodium-0.4.2
	ntox? ( sys-libs/ncurses )
	dht-bootstrap-daemon? ( dev-libs/libconfig )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README README.md ChangeLog NEWS  )

src_configure() {
	local myeconfargs=(
		$(use_enable dht-bootstrap-daemon)
		$(use_enable ntox)
		--disable-tests
		--disable-testing
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	use dht-bootstrap-daemon && newinitd "${FILESDIR}"/initd tox-dht-bootstrap
}
