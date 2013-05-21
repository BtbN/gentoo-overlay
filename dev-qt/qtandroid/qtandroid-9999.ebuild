# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Qt 5.1 git build for android"
HOMEPAGE="http://qt-project.org"
EGIT_REPO_URI="git://gitorious.org/qt/qt5.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/android-sdk-update-manager
        dev-util/android-ndk"
RDEPEND="${DEPEND}"

src_configure() {
	my_arch="linux-x86_64"
	if use x86; then
		my_arch="linux-x86"
	fi

	./configure -developer-build -xplatform android-g++ -nomake tests \
		-nomake examples -android-ndk /opt/android-ndk \
		-android-sdk /opt/android-sdk-update-manager \
		-android-ndk-host "$my_arch" -skip qttranslations -skip qtwebkit \
		-skip qtserialport -skip qtwebkit-examples \
		-prefix /opt/qt5-android
}

