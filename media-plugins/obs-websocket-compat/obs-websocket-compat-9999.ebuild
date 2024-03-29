# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

if [[ ${PV} != *9999 ]]; then
	KEYWORDS="~amd64"
	EGIT_COMMIT="${PV}-compat"
fi

EGIT_REPO_URI="https://github.com/obsproject/obs-websocket.git"
EGIT_BRANCH="4.x-compat-new-cmake"
DESCRIPTION="WebSockets API for OBS Studio (4.x protocol compat)"
HOMEPAGE="https://github.com/obsproject/obs-websocket"

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	media-video/obs-studio
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	|| ( >=media-plugins/obs-websocket-5.0.0 >=media-video/obs-studio-29[websocket] )"
RDEPEND="${DEPEND}"

BUILD_DIR="${S}/build"

src_configure() {
	local mycmakeargs=(
		-DLINUX_PORTABLE=OFF
	)

	cmake_src_configure
}
