# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# Does not work with py3 here
# It might work with py:2.5 but I didn't test that
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1 multiprocessing autotools

EGIT_REPO_URI="https://github.com/xbmc/xbmc.git"
inherit git-2

DESCRIPTION="XBMC is a free and open source media-player and entertainment hub"
HOMEPAGE="http://xbmc.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="airplay alsa altivec avahi bluetooth bluray caps cec css debug +fishbmc gles goom java joystick midi mysql neon nfs +opengl profile +projectm pulseaudio +rsxs rtmp +samba sse sse2 sftp udev upnp +usb vaapi vdpau webserver +X +xrandr"
REQUIRED_USE="
	rsxs? ( X )
	xrandr? ( X )
"

COMMON_DEPEND="${PYTHON_DEPS}
	app-arch/bzip2
	app-arch/unzip
	app-arch/zip
	app-i18n/enca
	airplay? ( app-pda/libplist )
	dev-libs/boost
	dev-libs/fribidi
	dev-libs/libcdio[-minimal]
	cec? ( >=dev-libs/libcec-2.1 )
	dev-libs/libpcre[cxx]
	>=dev-libs/lzo-2.04
	dev-libs/tinyxml[stl]
	dev-libs/yajl
	dev-python/simplejson[${PYTHON_USEDEP}]
	media-fonts/corefonts
	media-fonts/roboto
	media-libs/alsa-lib
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	>=media-libs/glew-1.5.6
	media-libs/jasper
	media-libs/jbigkit
	>=media-libs/libass-0.9.7
	bluray? ( media-libs/libbluray )
	css? ( media-libs/libdvdcss )
	media-libs/libmad
	media-libs/libmodplug
	media-libs/libmpeg2
	media-libs/libogg
	media-libs/libpng
	projectm? ( media-libs/libprojectm )
	media-libs/libsamplerate
	>=media-libs/taglib-1.8
	media-libs/libvorbis
	media-libs/tiff
	pulseaudio? ( media-sound/pulseaudio )
	media-sound/wavpack
	rtmp? ( media-video/rtmpdump )
	avahi? ( net-dns/avahi )
	nfs? ( net-fs/libnfs )
	webserver? ( net-libs/libmicrohttpd[messages] )
	sftp? ( net-libs/libssh[sftp] )
	net-misc/curl
	samba? ( >=net-fs/samba-3.4.6[smbclient] )
	bluetooth? ( net-wireless/bluez )
	sys-apps/dbus
	caps? ( sys-libs/libcap )
	sys-libs/zlib
	virtual/jpeg
	usb? ( virtual/libusb )
	mysql? ( virtual/mysql )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	gles? ( virtual/opengl )
	vaapi? ( x11-libs/libva[opengl] )
	vdpau? (
		|| ( x11-libs/libvdpau >=x11-drivers/nvidia-drivers-180.51 )
	)
	X? (
		x11-apps/xdpyinfo
		x11-apps/mesa-progs
		x11-libs/libXinerama
		xrandr? ( x11-libs/libXrandr )
		x11-libs/libXrender
	)"
RDEPEND="${COMMON_DEPEND}
	udev? (
		sys-fs/udisks:0
		|| ( sys-power/upower sys-power/upower-pm-utils )
	)"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-lang/swig
	dev-util/gperf
	X? ( x11-proto/xineramaproto )
	dev-util/cmake
	x86? ( dev-lang/nasm )
	virtual/jre"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	export ac_cv_lib_avcodec_ff_vdpau_vc1_decode_picture=yes
	export HAVE_GIT=no GIT_REV=${EGIT_VERSION:-exported}

	epatch_user

	sh ./bootstrap
}

src_configure() {
	# Disable documentation generation
	export ac_cv_path_LATEX=no
	# Avoid help2man
	export HELP2MAN=$(type -P help2man || echo true)
	# No configure flage for this #403561
	export ac_cv_lib_bluetooth_hci_devid=$(usex bluetooth)

	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-ccache \
		--disable-optimizations \
		--with-ffmpeg=force \
		--enable-gl \
		$(use_enable airplay) \
		$(use_enable avahi) \
		$(use_enable bluray libbluray) \
		$(use_enable caps libcap) \
		$(use_enable cec libcec) \
		$(use_enable css dvdcss) \
		$(use_enable debug) \
		$(use_enable fishbmc) \
		$(use_enable gles) \
		$(use_enable goom) \
		$(use_enable joystick) \
		$(use_enable midi mid) \
		$(use_enable mysql) \
		$(use_enable nfs) \
		$(use_enable opengl gl) \
		$(use_enable profile profiling) \
		$(use_enable projectm) \
		$(use_enable pulseaudio pulse) \
		$(use_enable rsxs) \
		$(use_enable rtmp) \
		$(use_enable samba) \
		$(use_enable sftp ssh) \
		$(use_enable usb libusb) \
		$(use_enable upnp) \
		$(use_enable vaapi) \
		$(use_enable vdpau) \
		$(use_enable webserver) \
		$(use_enable X x11) \
		$(use_enable xrandr)
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/*/{LICENSE.GPL,copying.txt}*

	domenu tools/Linux/kodi.desktop
	newicon media/icon48x48.png kodi.png

	# Remove optional addons (platform specific and disabled by USE flag).
	local disabled_addons=(
		repository.pvr-{android,ios,osx{32,64},win32}.xbmc.org
		visualization.dxspectrum
	)
	use fishbmc  || disabled_addons+=( visualization.fishbmc )
	use projectm || disabled_addons+=( visualization.{milkdrop,projectm} )
	use rsxs     || disabled_addons+=( screensaver.rsxs.{euphoria,plasma,solarwinds} )
	rm -rf "${disabled_addons[@]/#/${ED}/usr/share/kodi/addons/}"

	# Punt simplejson bundle, we use the system one anyway.
	rm -rf "${ED}"/usr/share/kodi/addons/script.module.simplejson/lib
	# Remove fonconfig settings that are used only on MacOSX.
	# Can't be patched upstream because they just find all files and install
	# them into same structure like they have in git.
	rm -rf "${ED}"/usr/share/kodi/system/players/dvdplayer/etc

	# Replace bundled fonts with system ones
	# teletext.ttf: unknown
	# bold-caps.ttf: unknown
	# roboto: roboto-bold, roboto-regular
	# arial.ttf: font mashed from droid/roboto, not removed wrt bug#460514
	rm -rf "${ED}"/usr/share/kodi/addons/skin.confluence/fonts/Roboto-*
	dosym /usr/share/fonts/roboto/Roboto-Regular.ttf \
		/usr/share/kodi/addons/skin.confluence/fonts/Roboto-Regular.ttf
	dosym /usr/share/fonts/roboto/Roboto-Bold.ttf \
		/usr/share/kodi/addons/skin.confluence/fonts/Roboto-Bold.ttf

	python_domodule tools/EventClients/lib/python/xbmcclient.py
	python_newscript "tools/EventClients/Clients/Kodi Send/kodi-send.py" xbmc-send
}
