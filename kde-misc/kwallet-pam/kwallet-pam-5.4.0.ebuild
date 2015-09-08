# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="PAM KWallet"
HOMEPAGE="https://quickgit.kde.org/?p=kwallet-pam.git"
SRC_URI="mirror://kde/stable/plasma/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="kde-base/kdelibs:4"
RDEPEND="${DEPEND}
	net-misc/socat"

src_prepare() {
    # Patch Gentoo default kde path
	sed -i 's/\.kde/.kde4/' pam_kwallet.c || die 'sed failed'
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(kde4-config --prefix)"
		-DQT_QMAKE_EXECUTABLE=/usr/lib/qt4/bin/qmake
		-DKWALLET4=1
	)
	cmake-utils_src_configure
}
