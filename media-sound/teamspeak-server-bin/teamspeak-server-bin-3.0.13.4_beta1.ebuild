# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils systemd user

DESCRIPTION="TeamSpeak Server - Voice Communication Software"
HOMEPAGE="http://www.teamspeak.com/"
LICENSE="teamspeak3 GPL-2"

SLOT="0"
IUSE="doc tsdns"
KEYWORDS="~amd64 ~x86"

RESTRICT="installsources mirror strip"

SRC_URI="amd64? ( http://dl.4players.de/ts/releases/pre_releases/server/3.0.13.4-Beta-1/teamspeak3-server_linux_amd64-3.0.13.4.tar.bz2 )
	x86? ( http://dl.4players.de/ts/releases/pre_releases/server/3.0.13.4-Beta-1/teamspeak3-server_linux_x86-3.0.13.4.tar.bz2 )"

RDEPEND="dev-db/mariadb-connector-c:2"
DEPEND="${RDEPEND}
	app-arch/bzip2"

S="${WORKDIR}/teamspeak3-server_linux_${ARCH}"

pkg_setup() {
	enewuser teamspeak3
}

src_install() {
	# Install TeamSpeak 3 server into /opt/teamspeak3-server.
	local opt_dir="/opt/teamspeak3-server"
	into ${opt_dir}
	insinto ${opt_dir}

	# Install binary, wrapper, shell files and libraries.
	newbin ts3server ts3server-bin

	exeinto /usr/bin
	doexe "${FILESDIR}"/ts3server

	exeinto ${opt_dir}
	doexe *.sh
	doins *.so

	doins -r sql

	# Install documentation and tsdns.
	dodoc -r CHANGELOG doc/*.txt
	use doc && dodoc -r serverquerydocs

	if use tsdns; then
		newbin tsdns/tsdnsserver tsdnsserver

		newdoc tsdns/README README.tsdns
		newdoc tsdns/USAGE USAGE.tsdns
		dodoc tsdns/tsdns_settings.ini.sample

		exeinto /usr/bin
		doexe "${FILESDIR}"/tsdnsserver
		exeinto ${opt_dir}

		systemd_dounit "${FILESDIR}"/systemd/tsdns.service
	fi

	# Install the runtime FS layout.
	insinto /etc/teamspeak3-server
	doins "${FILESDIR}"/server.conf
	doins "${FILESDIR}"/ts3db_mysql.ini
	keepdir /{etc,var/{lib,log}}/teamspeak3-server
	use tsdns && touch "${ED}/etc/teamspeak3-server/tsdns_settings.ini"

	# Install the init script and systemd unit.
	newinitd "${FILESDIR}"/initd teamspeak3-server
	systemd_dounit "${FILESDIR}"/systemd/teamspeak3.service
	systemd_dotmpfilesd "${FILESDIR}"/systemd/teamspeak3.conf

	# Fix up permissions.
	fowners teamspeak3 /{etc,var/{lib,log}}/teamspeak3-server
	fowners teamspeak3 ${opt_dir}

	fperms 700 /{etc,var/{lib,log}}/teamspeak3-server
	fperms 755 ${opt_dir}

	chown -R teamspeak3 "${ED}/etc/teamspeak3-server"
	chmod -R go-rwx "${ED}/etc/teamspeak3-server"
}
