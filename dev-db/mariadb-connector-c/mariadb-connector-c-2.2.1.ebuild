# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="The MariaDB Native Client library (C driver)"
HOMEPAGE="https://downloads.mariadb.org/client-native/"
SRC_URI="http://mirror2.hs-esslingen.de/mariadb/connector-c-${PV}/mariadb-connector-c-${PV}-src.tar.gz"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	cmake-utils_src_install

	insinto /etc/ld.so.conf.d
	doins "${FILESDIR}/mariadb_client.conf"

	mv "${ED}/usr/bin/"mariadb{,_client}_config
}
