# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils user

DESCRIPTION="TeamSpeak Server - Voice Communication Software"
HOMEPAGE="http://www.teamspeak.com/"
LICENSE="teamspeak3 GPL-2"

SLOT="0"
IUSE="doc pdf tsdns"
KEYWORDS="~amd64 ~x86"

RESTRICT="installsources mirror fetch strip"

SRC_URI="amd64? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux-amd64-${PV}.tar.gz )
	x86? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux-x86-${PV}.tar.gz )"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/gzip"

S="${WORKDIR}/teamspeak3-server_linux-${ARCH}"

pkg_nofetch() {
	if use amd64 ; then
		einfo "Please download teamspeak3-server_linux-amd64-${PV}.tar.gz"
	elif use x86 ; then
		einfo "Please download teamspeak3-server_linux-x86-${PV}.tar.gz"
	fi
	einfo "from ${HOMEPAGE}?page=downloads and place this"
	einfo "file in ${DISTDIR}"
}

pkg_setup() {
	enewuser teamspeak3
}

src_install() {
	# Install TeamSpeak 3 server into /opt/teamspeak3-server.
	local opt_dir="/opt/teamspeak3-server"
	into ${opt_dir}
	insinto ${opt_dir}

	# Install binary, wrapper, shell files and libraries.
	newbin ts3server_linux_${ARCH} ts3server-bin

	exeinto /usr/bin
	doexe "${FILESDIR}"/ts3server

	exeinto ${opt_dir}
	doexe *.sh
	doins *.so

	zcat "${FILESDIR}"/libmysqlclient.so.15.gz > "${ED}${opt_dir}/libmysqlclient.so.15" || die "gunzip failed"

	doins -r sql

	# Install documentation and tsdns.
	dodoc -r CHANGELOG doc/*.txt
	use doc && dodoc -r serverquerydocs
	use pdf && dodoc doc/*.pdf

	if use tsdns; then
		newbin tsdns/tsdnsserver_linux_${ARCH} tsdnsserver

		newdoc tsdns/README README.tsdns
		newdoc tsdns/USAGE USAGE.tsdns
		dodoc tsdns/tsdns_settings.ini.sample

		exeinto /usr/bin
		doexe "${FILESDIR}"/tsdnsserver
		exeinto ${opt_dir}
	fi

	# Install the runtime FS layout.
	insinto /etc/teamspeak3-server
	doins "${FILESDIR}"/server.conf
	doins "${FILESDIR}"/ts3db_mysql.ini
	keepdir /{etc,var/{lib,log}}/teamspeak3-server
	use tsdns && touch "${ED}/etc/teamspeak3-server/tsdns_settings.ini"

	# Install the init script and systemd unit.
	newinitd "${FILESDIR}"/initd teamspeak3-server

	# Fix up permissions.
	fowners teamspeak3 /{etc,var/{lib,log}}/teamspeak3-server
	fowners teamspeak3 ${opt_dir}

	fperms 700 /{etc,var/{lib,log}}/teamspeak3-server
	fperms 755 ${opt_dir}

	chown -R teamspeak3 "${ED}/etc/teamspeak3-server"
	chmod -R go-rwx "${ED}/etc/teamspeak3-server"
}
