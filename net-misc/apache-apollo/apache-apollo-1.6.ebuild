# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="ActiveMQ Apollo is a faster, more reliable, easier to maintain messaging broker built from the foundations of the original ActiveMQ"
HOMEPAGE="http://activemq.apache.org/apollo/"
SRC_URI="mirror://apache/activemq/activemq-apollo/${PV}/${P}-unix-distro.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="docs examples"

RDEPEND=">=virtual/jdk-1.6"
DEPEND="${DEPEND}"

pkg_setup() {
	enewgroup apollo
	enewuser apollo "" /bin/bash /var/lib/apollo apollo
}

src_install() {
	mkdir -p "${D}/opt/apache-apollo"

	cp -r "${S}/"{bin,lib,etc} "${D}/opt/apache-apollo" || die "cp failed"

	dosym /opt/apache-apollo/bin/apollo /usr/bin/apollo

	dodoc LICENSE
	dodoc NOTICE
	dodoc readme.html

	use docs && dodoc -r "${S}/docs"
	use examples && cp -r "${S}/examples" "${D}/opt/apache-apollo"


	mkdir -p "${D}/var/lib/apollo"
	cd "${D}/var/lib/apollo"
	chown apollo:apollo "${D}/var/lib/apollo"

	su apollo -c "'${D}/opt/apache-apollo/bin/apollo' create default" >/dev/null

	doinitd "${FILESDIR}/apollo"
	doenvd "${FILESDIR}/98apollo"
}

