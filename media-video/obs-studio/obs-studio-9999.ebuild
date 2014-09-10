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
IUSE="pulseaudio imagemagick v4l fontconfig fdk"

DEPEND="x11-libs/libX11
	x11-libs/libXcomposite
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=media-video/ffmpeg-2.1
	pulseaudio? ( >=media-sound/pulseaudio-4 )
	imagemagick? ( media-gfx/imagemagick )
	v4l? ( media-libs/libv4l )
	fontconfig? ( media-libs/freetype:2 media-libs/fontconfig )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package fdk Libfdk)
		$(cmake-utils_use_find_package pulseaudio PulseAudio)
		$(cmake-utils_use_find_package v4l Libv4l2)
		$(cmake-utils_use_find_package fontconfig Freetype)
		$(cmake-utils_use_find_package imagemagick ImageMagick)
		$(use imagemagick && echo "-DLIBOBS_PREFER_IMAGEMAGICK=1" || echo "-DLIBOBS_PREFER_IMAGEMAGICK=0")
	)
	cmake-utils_src_configure
}
