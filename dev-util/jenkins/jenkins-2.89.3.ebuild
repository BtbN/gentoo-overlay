# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user systemd java-pkg-2

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://jenkins-ci.org/"
LICENSE="MIT"
SRC_URI="http://mirrors.jenkins-ci.org/war-stable/${PV}/jenkins.war -> jenkins-${PV}.war"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-fonts/dejavu"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}"

src_unpack() {
	return
}

src_compile() {
	return
}

pkg_setup() {
	enewgroup jenkins
	enewuser jenkins -1 /bin/bash /var/lib/jenkins jenkins
}

src_install() {
	keepdir /var/log/jenkins
	keepdir /var/lib/jenkins/home /var/lib/jenkins/backup

	mkdir -p "${ED}/usr/lib/jenkins"
	cp "${DISTDIR}/jenkins-${PV}.war" "${ED}/usr/lib/jenkins/jenkins.war"

	newinitd "${FILESDIR}/init.sh" jenkins
	newconfd "${FILESDIR}/conf" jenkins

	systemd_newunit "${FILESDIR}/jenkins.service" jenkins.service

	exeinto /usr/libexec
	newexe "${FILESDIR}/launch_script.sh" jenkins

	fowners jenkins:jenkins /var/log/jenkins /var/lib/jenkins /var/lib/jenkins/home /var/lib/jenkins/backup
}
