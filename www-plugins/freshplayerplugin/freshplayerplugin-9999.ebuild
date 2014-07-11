# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="PPAPI-host NPAPI-plugin adapter for flashplayer in npapi based browsers"
HOMEPAGE="https://github.com/i-rinat/freshplayerplugin"
SRC_URI=""

EGIT_REPO_URI="https://github.com/i-rinat/freshplayerplugin.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-libs/alsa-lib
	dev-libs/libconfig
	x11-libs/pango
	x11-libs/libXinerama
	dev-libs/libevent
	media-libs/mesa
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

