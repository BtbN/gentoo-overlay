# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="ZNC per client buffer plugin"
HOMEPAGE="https://github.com/jpnurmi/znc-clientbuffer"
EGIT_REPO_URI="https://github.com/BtbN/znc-clientbuffer.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-irc/znc"
RDEPEND="${DEPEND}"

src_compile() {
	znc-buildmod clientbuffer.cpp || die "buildmod failed"
}

src_install() {
	mkdir -p "${ED}/usr/$(get_libdir)/znc" || die "mkdir failed"
	cp clientbuffer.so "${ED}/usr/$(get_libdir)/znc" || die "cp failed"
}
