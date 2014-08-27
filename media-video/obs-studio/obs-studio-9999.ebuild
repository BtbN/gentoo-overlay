# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Live streaming and capturing application"
HOMEPAGE="http://obsproject.com/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/jp9000/obs-studio.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="pulseaudio"

DEPEND="x11-libs/libX11
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=media-video/ffmpeg-2.1
	pulseaudio? ( >=media-sound/pulseaudio-4 )
	x11-libs/libXcomposite
	media-libs/freetype:2
	media-libs/fontconfig"
RDEPEND="${DEPEND}"

