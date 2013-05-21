# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Qt 5.1 git build for android"
HOMEPAGE="http://qt-project.org"
EGIT_REPO_URI="git://gitorious.org/qt/qt5.git"
EGIT_BRANCH="stable"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/android-sdk-update-manager
        dev-util/android-ndk"
RDEPEND="${DEPEND}"

src_prepare() {
	git config remote.origin.url "git://gitorious.org/qt/qt5.git" || die "git config failed"
	perl init-repository || die "init repo failed"
}

src_compile() {
	make -j1 || die "make failed"
}

src_configure() {
	./configure -developer-build -xplatform android-g++ -nomake tests \
		-nomake examples -android-ndk /opt/android-ndk \
		-android-sdk /opt/android-sdk-update-manager \
		-skip qttranslations -skip qtwebkit \
		-skip qtserialport -skip qtwebkit-examples \
		-opensource -confirm-license \
		-prefix /opt/qt5-android || die "configure failed"
}

