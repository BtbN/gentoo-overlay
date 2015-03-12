# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit nsplugins cmake-utils multilib git-2

DESCRIPTION="PPAPI-host NPAPI-plugin adapter for flashplayer in npapi based browsers"
HOMEPAGE="https://github.com/i-rinat/freshplayerplugin"
SRC_URI=""

EGIT_REPO_URI="https://github.com/i-rinat/freshplayerplugin.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="pulseaudio"

CDEPEND="
	media-libs/mesa:=[egl,gles2]
	media-libs/alsa-lib:=
	media-libs/freetype:=
	dev-libs/libconfig:=
	dev-libs/uriparser:=
	dev-libs/libevent:=
	dev-libs/glib:2=
	dev-libs/openssl:0=
	x11-libs/pango:=[X]
	x11-libs/libXinerama:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/gtk+:2=
	x11-libs/cairo:=
	media-libs/freetype:=
	pulseaudio? ( media-sound/pulseaudio:= )"
DEPEND="
	${CDEPEND}
	dev-util/ragel
	virtual/pkgconfig"
RDEPEND="
	${CDEPEND}
	www-plugins/chrome-binary-plugins[flash]"

src_configure() {
	local mycmakeargs=( $(cmake-utils_use_find_package pulseaudio PulseAudio) )
	cmake-utils_src_configure
}

src_install() {
	dodoc ChangeLog README.md

	exeinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doexe "${BUILD_DIR}"/*.so

	mkdir -p "${ED}/etc"
	sed -r 's|(pepperflash_path *= *)".*"|\1"/usr/lib/chromium-browser/PepperFlash/libpepflashplayer.so"|' data/freshwrapper.conf.example > "${ED}/etc/freshwrapper.conf" || die "sed failed"
}
