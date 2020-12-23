# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ratwithacompiler/OBS-captions-plugin.git"
else
	SRC_URI="https://github.com/ratwithacompiler/OBS-captions-plugin/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Provides closed captioning via Google Cloud Speech Recognition API"
HOMEPAGE="https://github.com/ratwithacompiler/OBS-captions-plugin"

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	media-video/obs-studio
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"
