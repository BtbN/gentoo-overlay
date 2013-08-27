# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-2" || VCS_ECLASS=""

inherit cmake-utils versionator ${VCS_ECLASS}

DESCRIPTION="Spectrum is a XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"
MY_PN="spectrum"
MY_PV=$(replace_version_separator '_' '-')
MY_P="${MY_PN}-${MY_PV}"
SRC_URI="mirror://github/hanzz/libtransport/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE_PLUGINS="frotz jabber purple sms twitter yahoo" # irc
IUSE="debug doc libev mysql postgres sqlite test ${IUSE_PLUGINS}"

RDEPEND="net-im/swift
	dev-libs/libev
	dev-libs/log4cxx
	dev-libs/openssl
	dev-libs/popt
	dev-libs/protobuf
	mysql? ( virtual/mysql )
	postgres? ( dev-libs/libpqxx )
	sqlite? ( dev-db/sqlite:3 )
	purple? ( >=net-im/pidgin-2.6.0 )
	libev? ( dev-libs/libev )
	"
# irc? ( net-im/communi )

DEPEND="${RDEPEND}
	dev-util/cmake
	sys-devel/gettext
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
	"

REQUIRED_USE="|| ( sqlite mysql postgres )"

pkg_setup() {
	CMAKE_IN_SOURCE_BUILD=1
	use debug && CMAKE_BUILD_TYPE=Debug
	MYCMAKEARGS="-DLIB_INSTALL_DIR=$(get_libdir)"
}

src_prepare() {
	# no patches as of now
	#epatch "${FILESDIR}"/spectrum2-.patch
	base_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable mysql MYSQL)
		$(cmake-utils_use_enable postgres PQXX)
		$(cmake-utils_use_enable sqlite SQLITE3)
		$(cmake-utils_use_enable doc DOCS)
		$(cmake-utils_use_enable frotz FROTZ)
		$(cmake-utils_use_enable irc IRC)
		$(cmake-utils_use_enable jabber SWIFTEN)
		$(cmake-utils_use_enable purple PURPLE)
		$(cmake-utils_use_enable skype SKYPE)
		$(cmake-utils_use_enable sms SMSTOOLS3)
		$(cmake-utils_use_enable twitter TWITTER)
		$(cmake-utils_use_enable yahoo YAHOO2)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/spectrum2.initd spectrum2
	keepdir "${EPREFIX}"/var/lib/spectrum2
	keepdir "${EPREFIX}"/var/log/spectrum2
	keepdir "${EPREFIX}"/var/run/spectrum2
}

pkg_postinst() {
	# Create jabber-user
	enewgroup jabber
	enewuser jabber -1 -1 -1 jabber

	# Set correct rights
	chown jabber:jabber -R "/etc/spectrum2" || die
	chown jabber:jabber -R "${EPREFIX}/var/log/spectrum2" || die
	chown jabber:jabber -R "${EPREFIX}/var/run/spectrum2" || die
	chmod 750 "/etc/spectrum2" || die
	chmod 750 "${EPREFIX}/var/log/spectrum2" || die
	chmod 750 "${EPREFIX}/var/run/spectrum2" || die
}
