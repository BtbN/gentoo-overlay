# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Palakis/obs-websocket.git"
else
	SRC_URI="https://github.com/Palakis/obs-websocket/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="WebSockets API for OBS Studio"
HOMEPAGE="https://github.com/Palakis/obs-websocket"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	media-video/obs-studio
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"
