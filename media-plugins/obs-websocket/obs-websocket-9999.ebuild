# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_IN_SOURCE_BUILD=1

inherit git-r3 cmake

if [[ ${PV} != *9999 ]]; then
	KEYWORDS="~amd64"
	EGIT_COMMIT="${PV}"
fi

EGIT_REPO_URI="https://github.com/obsproject/obs-websocket.git"
DESCRIPTION="WebSockets API for OBS Studio"
HOMEPAGE="https://github.com/obsproject/obs-websocket"

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	media-video/obs-studio
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"
