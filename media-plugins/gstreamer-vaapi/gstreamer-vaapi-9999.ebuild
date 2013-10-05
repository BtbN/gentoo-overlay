# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://gitorious.org/gstreamer-vaapi/gstreamer-vaapi.git"
AUTOTOOLS_AUTORECONF="yes"

inherit git-r3 autotools-utils

DESCRIPTION="GStreamer VA-API plugins"
HOMEPAGE="http://gitorious.org/vaapi/gstreamer-vaapi"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

IUSE="doc opengl static-libs +encoders"

RDEPEND="dev-libs/glib:2
	>=media-libs/gstreamer-1.0
	>=media-libs/gst-plugins-base-1.0
	>=media-libs/gst-plugins-bad-1.0
	>=x11-libs/libva-1.2
	x11-libs/libX11
	>=virtual/ffmpeg-0.6[vaapi]
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

DOCS=(AUTHORS README NEWS)

S="${WORKDIR}/${P}"

src_prepare() {
	[ -f gtk-doc.make ] || echo 'EXTRA_DIST =' > gtk-doc.make

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable opengl glx)
		$(use_enable encoders)
	)
	autotools-utils_src_configure
}
