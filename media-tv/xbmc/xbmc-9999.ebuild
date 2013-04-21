# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/xbmc/xbmc-9999.ebuild,v 1.134 2013/01/29 17:11:12 scarabeus Exp $

EAPI="4"

# Does not work with py3 here
# It might work with py:2.5 but I didn't test that
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH=sqlite

inherit eutils python multiprocessing autotools git-2

EGIT_REPO_URI="git://github.com/xbmc/xbmc.git"

DESCRIPTION="XBMC is a free and open source media-player and entertainment hub"
HOMEPAGE="http://xbmc.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="airplay alsa altivec avahi bluetooth bluray cec css debug goom java joystick midi mysql nfs profile +projectm pulseaudio pvr +rsxs rtmp +samba sse sse2 sftp udev upnp vaapi vdpau webserver +xrandr external-ffmpeg"
REQUIRED_USE="pvr? ( mysql )"

COMMON_DEPEND="virtual/glu
	virtual/opengl
	app-arch/bzip2
	app-arch/unzip
	app-arch/zip
	app-i18n/enca
	airplay? ( app-pda/libplist )
	>=dev-lang/python-2.4
	dev-libs/boost
	dev-libs/fribidi
	dev-libs/libcdio[-minimal]
	cec? ( >=dev-libs/libcec-2 )
	dev-libs/libpcre[cxx]
	>=dev-libs/lzo-2.04
	dev-libs/tinyxml[stl]
	dev-libs/yajl
	dev-python/simplejson
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
	media-libs/libsdl[audio,opengl,video,X]
	alsa? ( media-libs/libsdl[alsa] )
	>=media-libs/taglib-1.8
	media-libs/libvorbis
	media-libs/sdl-gfx
	>=media-libs/sdl-image-1.2.10[gif,jpeg,png]
	media-libs/sdl-mixer
	media-libs/sdl-sound
	media-libs/tiff
	pulseaudio? ( media-sound/pulseaudio )
	media-sound/wavpack
	|| ( media-libs/libpostproc <media-video/libav-0.8.2-r1 media-video/ffmpeg )
	>=virtual/ffmpeg-0.6[encode]
	rtmp? ( media-video/rtmpdump )
	avahi? ( net-dns/avahi )
	nfs? ( net-fs/libnfs )
	webserver? ( net-libs/libmicrohttpd[messages] )
	sftp? ( net-libs/libssh )
	net-misc/curl
	samba? ( >=net-fs/samba-3.4.6[smbclient] )
	bluetooth? ( net-wireless/bluez )
	sys-apps/dbus
	sys-libs/zlib
	virtual/jpeg
	mysql? ( virtual/mysql )
	x11-apps/xdpyinfo
	x11-apps/mesa-progs
	vaapi? ( x11-libs/libva[opengl] )
	vdpau? (
		|| ( x11-libs/libvdpau >=x11-drivers/nvidia-drivers-180.51 )
		virtual/ffmpeg[vdpau]
	)
	x11-libs/libXinerama
	xrandr? ( x11-libs/libXrandr )
	x11-libs/libXrender"
RDEPEND="${COMMON_DEPEND}
	udev? (	sys-fs/udisks:0 sys-power/upower )"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-lang/swig
	dev-util/gperf
	x11-proto/xineramaproto
	dev-util/cmake
	x86? ( dev-lang/nasm )
	java? ( virtual/jre )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	./bootstrap || die "bootstrap failed"
}

src_configure() {
	# Disable documentation generation
	export ac_cv_path_LATEX=no
	# Avoid help2man
	export HELP2MAN=$(type -P help2man || echo true)
	# No configure flage for this #403561
	export ac_cv_lib_bluetooth_hci_devid=$(usex bluetooth)
	# Requiring java is asine #434662
	export ac_cv_path_JAVA_EXE=$(which $(usex java java true))

	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-ccache \
		--disable-optimizations \
		--enable-external-libraries \
		--enable-gl \
		$(use_enable airplay) \
		$(use_enable avahi) \
		$(use_enable bluray libbluray) \
		$(use_enable cec libcec) \
		$(use_enable css dvdcss) \
		$(use_enable debug) \
		$(use_enable goom) \
		--disable-hal \
		$(use_enable joystick) \
		$(use_enable midi mid) \
		$(use_enable mysql) \
		$(use_enable nfs) \
		$(use_enable profile profiling) \
		$(use_enable projectm) \
		$(use_enable pulseaudio pulse) \
		$(use_enable pvr mythtv) \
		$(use_enable rsxs) \
		$(use_enable rtmp) \
		$(use_enable samba) \
		$(use_enable sftp ssh) \
		$(use_enable upnp) \
		$(use_enable vaapi) \
		$(use_enable vdpau) \
		$(use_enable webserver) \
		$(use_enable xrandr) \
		$(use_enable external-ffmpeg)
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/*/{LICENSE.GPL,copying.txt}*

	domenu tools/Linux/xbmc.desktop
	newicon tools/Linux/xbmc-48x48.png xbmc.png

	# punt simplejson bundle, we use the system one anyway
	rm -rf "${ED}"/usr/share/xbmc/addons/script.module.simplejson/lib
	# Remove fonconfig settings that are used only on MacOSX.
	# Can't be patched upstream because they just find all files and install
	# them into same structure like they have in git.
	rm -rf "${ED}"/usr/share/xbmc/system/players/dvdplayer/etc

	# Replace bundled fonts with system ones
	# corefonts: arial ; unknown source teletext.ttf
	rm -rf "${ED}"/usr/share/xbmc/media/Fonts/arial.ttf
	dosym /usr/share/fonts/corefonts/arial.ttf \
		/usr/share/xbmc/media/Fonts/arial.ttf
	# roboto: roboto-bold, roboto-regular ; unknown source: bold-caps
	rm -rf "${ED}"/usr/share/xbmc/addons/skin.confluence/fonts/Roboto-*
	dosym /usr/share/fonts/roboto/Roboto-Regular.ttf \
		/usr/share/xbmc/addons/skin.confluence/fonts/Roboto-Regular.ttf
	dosym /usr/share/fonts/roboto/Roboto-Bold.ttf \
		/usr/share/xbmc/addons/skin.confluence/fonts/Roboto-Bold.ttf

	insinto "$(python_get_sitedir)" #309885
	doins tools/EventClients/lib/python/xbmcclient.py || die
	newbin "tools/EventClients/Clients/XBMC Send/xbmc-send.py" xbmc-send || die
}

pkg_postinst() {
	elog "Visit http://wiki.xbmc.org/?title=XBMC_Online_Manual"
}
