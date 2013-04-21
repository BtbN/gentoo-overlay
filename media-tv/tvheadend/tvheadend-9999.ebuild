# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvheadend/tvheadend-3.2.ebuild,v 1.1 2012/10/27 06:09:17 yngwin Exp $

EAPI=4

inherit eutils toolchain-funcs user git-2

DESCRIPTION="A combined DVB receiver, Digital Video Recorder and Live TV streaming server"
HOMEPAGE="https://www.lonelycoder.com/redmine/projects/tvheadend/"

EGIT_REPO_URI="git://github.com/tvheadend/tvheadend.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="avahi xmltv zlib timeshift trace +dvbscan"

DEPEND="dev-libs/openssl
	virtual/linuxtv-dvb-headers
	avahi? ( net-dns/avahi )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	xmltv? ( media-tv/xmltv )"

DOCS=( README )

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	# remove '-Werror' wrt bug #438424
	sed -e 's:-Werror::' -i Makefile || die 'sed failed!'
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share/ \
		--mandir="${EPREFIX}"/usr/share/man/man1 \
		--release \
		--disable-dvbscan \
		$(use_enable avahi) \
		$(use_enable zlib) \
		$(use_enable dvbscan) \
		$(use_enable timeshift) \
		$(use_enable trace)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newinitd "${FILESDIR}/tvheadend.initd" tvheadend
	newconfd "${FILESDIR}/tvheadend.confd" tvheadend

	dodir /etc/tvheadend
	fperms 0700 /etc/tvheadend
	fowners tvheadend:video /etc/tvheadend
}

pkg_postinst() {
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."
}
