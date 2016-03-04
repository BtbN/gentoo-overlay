# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# Does not work with py3 here
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils linux-info python-single-r1 multiprocessing autotools toolchain-funcs

CODENAME="Krypton"
case ${PV} in
9999)
	EGIT_REPO_URI="git://github.com/xbmc/xbmc.git"
	inherit git-r3
	;;
*|*_p*)
	MY_PV=${PV/_p/_r}
	MY_P="${PN}-${MY_PV}"
	SRC_URI="http://mirrors.kodi.tv/releases/source/${MY_PV}-${CODENAME}.tar.gz -> ${P}.tar.gz
		https://github.com/xbmc/xbmc/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz
		!java? ( http://mirrors.kodi.tv/releases/source/${MY_P}-generated-addons.tar.xz )"
	KEYWORDS="~amd64 ~x86"

	S=${WORKDIR}/xbmc-${PV}-${CODENAME}
	;;
esac

DESCRIPTION="Kodi is a free and open source media-player and entertainment hub"
HOMEPAGE="https://kodi.tv/ http://kodi.wiki/"

LICENSE="GPL-2"
SLOT="0"
IUSE="airplay alsa avahi bluetooth bluray caps cec dbus debug gles java joystick midi mysql nfs +opengl profile pulseaudio rtmp +samba sftp test +texturepacker udisks upnp upower +usb vaapi vdpau webserver +X"
# gles/vaapi: http://trac.kodi.tv/ticket/10552 #464306
REQUIRED_USE="
	|| ( gles opengl )
	gles? ( !vaapi )
	vaapi? ( !gles )
	udisks? ( dbus )
	upower? ( dbus )
"

COMMON_DEPEND="${PYTHON_DEPS}
	app-arch/bzip2
	app-arch/unzip
	app-arch/zip
	app-i18n/enca
	airplay? ( app-pda/libplist )
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/libcdio[-minimal]
	cec? ( >=dev-libs/libcec-3.0 )
	dev-libs/libpcre[cxx]
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-libs/lzo-2.04
	dev-libs/tinyxml[stl]
	>=dev-libs/yajl-2
	dev-python/simplejson[${PYTHON_USEDEP}]
	media-fonts/corefonts
	media-fonts/roboto
	alsa? ( media-libs/alsa-lib )
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	media-libs/jbigkit
	>=media-libs/libass-0.9.7
	bluray? ( >=media-libs/libbluray-0.7.0 )
	media-libs/libmad
	media-libs/libmodplug
	media-libs/libogg
	media-libs/libpng:0=
	media-libs/libsamplerate
	joystick? ( media-libs/libsdl2 )
	>=media-libs/taglib-1.8
	media-libs/libvorbis
	media-sound/dcadec
	pulseaudio? ( media-sound/pulseaudio )
	media-sound/wavpack
	>=media-video/ffmpeg-2.6:=[encode]
	rtmp? ( media-video/rtmpdump )
	avahi? ( net-dns/avahi )
	nfs? ( net-fs/libnfs:= )
	webserver? ( net-libs/libmicrohttpd[messages] )
	sftp? ( net-libs/libssh[sftp] )
	net-misc/curl
	samba? ( >=net-fs/samba-3.4.6[smbclient(+)] )
	bluetooth? ( net-wireless/bluez )
	dbus? ( sys-apps/dbus )
	caps? ( sys-libs/libcap )
	sys-libs/zlib
	usb? ( virtual/libusb:1 )
	mysql? ( virtual/mysql )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	gles? (
		media-libs/mesa[gles2]
	)
	vaapi? ( x11-libs/libva[opengl] )
	vdpau? (
		|| ( >=x11-libs/libvdpau-1.1 >=x11-drivers/nvidia-drivers-180.51 )
		media-video/ffmpeg[vdpau]
	)
	X? (
		x11-apps/xdpyinfo
		x11-apps/mesa-progs
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
	)"
RDEPEND="${COMMON_DEPEND}
	!media-tv/xbmc
	udisks? ( sys-fs/udisks:0 )
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-lang/swig
	dev-libs/crossguid
	dev-util/gperf
	texturepacker? ( media-libs/giflib )
	X? ( x11-proto/xineramaproto )
	dev-util/cmake
	x86? ( dev-lang/nasm )
	java? ( virtual/jre )
	test? ( dev-cpp/gtest )
	virtual/pkgconfig"
# Force java for latest git version to avoid having to hand maintain the
# generated addons package.  #488118
[[ ${PV} == "9999" ]] && DEPEND+=" virtual/jre"

CONFIG_CHECK="~IP_MULTICAST"
ERROR_IP_MULTICAST="
In some cases Kodi needs to access multicast addresses.
Please consider enabling IP_MULTICAST under Networking options.
"

pkg_setup() {
	check_extra_config
	python-single-r1_pkg_setup
}

src_unpack() {
	[[ ${PV} == "9999" ]] && git-r3_src_unpack || default
}

src_prepare() {
	export HAVE_GIT=no GIT_REV=${EGIT_VERSION:-exported}
	epatch_user #293109
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
	[[ ${PV} != "9999" ]] && export ac_cv_path_JAVA_EXE=$(which $(usex java java true))

	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-ccache \
		--disable-optimizations \
		--with-ffmpeg=shared \
		$(use_enable alsa) \
		$(use_enable airplay) \
		$(use_enable avahi) \
		$(use_enable bluray libbluray) \
		$(use_enable caps libcap) \
		$(use_enable cec libcec) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable gles) \
		$(use_enable joystick) \
		$(use_enable midi mid) \
		$(use_enable mysql) \
		$(use_enable nfs) \
		$(use_enable opengl gl) \
		$(use_enable profile profiling) \
		$(use_enable pulseaudio pulse) \
		$(use_enable rtmp) \
		$(use_enable samba) \
		$(use_enable sftp ssh) \
		$(use_enable usb libusb) \
		$(use_enable test gtest) \
		$(use_enable texturepacker) \
		$(use_enable upnp) \
		$(use_enable vaapi) \
		$(use_enable vdpau) \
		$(use_enable webserver) \
		$(use_enable X x11)
}

src_compile() {
	emake V=1
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/*/{LICENSE.GPL,copying.txt}* || die

	domenu tools/Linux/kodi.desktop
	newicon media/icon48x48.png kodi.png

	python_domodule tools/EventClients/lib/python/xbmcclient.py
	python_newscript "tools/EventClients/Clients/Kodi Send/kodi-send.py" kodi-send
}
