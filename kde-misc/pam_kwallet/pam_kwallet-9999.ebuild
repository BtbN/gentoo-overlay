# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="PAM KWallet"
HOMEPAGE="http://quickgit.kde.org/?p=scratch/afiestas/pam-kwallet.git"
EGIT_REPO_URI="git://anongit.kde.org/scratch/afiestas/pam-kwallet.git"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="kde-base/kdelibs"
RDEPEND="${DEPEND}
	net-misc/socat"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(kde4-config --prefix)"
		-DQT_QMAKE_EXECUTABLE=/usr/lib/qt4/bin/qmake
	)
	cmake-utils_src_configure
}
