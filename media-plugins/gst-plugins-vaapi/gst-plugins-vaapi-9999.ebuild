# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils git-r3

MY_PN="gstreamer-vaapi"
DESCRIPTION="Hardware accelerated video decoding through VA-API plugin"
HOMEPAGE="http://gitorious.org/vaapi/gstreamer-vaapi"
EGIT_REPO_URI="https://github.com/gbeauchesne/gstreamer-vaapi.git"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~amd64"
IUSE="+X opengl wayland"

RDEPEND="
	>=dev-libs/glib-2.34.3:2
	media-libs/libvpx
	>=media-libs/gstreamer-1.2.3:1.0
	>=media-libs/gst-plugins-base-1.2.3:1.0
	>=media-libs/gst-plugins-bad-1.2.3:1.0
	>=x11-libs/libdrm-2.4.46
	>=x11-libs/libX11-1.6.2
	>=x11-libs/libXrandr-1.4.2
	>=x11-libs/libva-1.4.0[X?,opengl?,wayland?]
	>=virtual/opengl-7.0-r1
	>=virtual/libudev-208:=
	wayland? ( >=dev-libs/wayland-1.0.6 )"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1"

src_prepare() {
	./autogen.sh || die "autogen failed"
}

src_configure() {
	econf \
		--enable-builtin-libvpx=no \
		--disable-static \
		--enable-drm \
		$(use_enable opengl glx) \
		$(use_enable wayland) \
		$(use_enable X x11)
}

src_install() {
	emake install DESTDIR="${ED}"
	einstalldocs
	prune_libtool_files --modules
}
