# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils versionator

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE"
HOMEPAGE="http://jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/${PN}/${PN}IU-$(get_version_component_range 2-3).tar.gz"
LICENSE="IntelliJ-IDEA"
IUSE=""
KEYWORDS="~x86 ~amd64"

SLOT="eap"
RDEPEND=">=virtual/jdk-1.6"
DEPEND="${RDEPEND}"
MY_PV="$(get_version_component_range 2-3)"

RESTRICT="strip mirror"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

S="${WORKDIR}/${PN}-IU-${MY_PV}"

src_install() {
	local dir="/opt/${P}"
	local exe="${PN}-$(get_major_version)"

	insinto "${dir}"
	doins -r * || die
	fperms 755 "${dir}/bin/${PN}.sh" "${dir}/bin/fsnotifier" "${dir}/bin/fsnotifier64" || die

	newicon "bin/${PN}.png" "${exe}.png" || die
	make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh" || die
	make_desktop_entry ${exe} "IntelliJ IDEA $(get_version_component_range 1-3)" "${exe}" "Development;IDE" || die
}
