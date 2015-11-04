# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Modded watch module"
HOMEPAGE="https://github.com/BtbN/znc-betterwatch"
EGIT_REPO_URI="https://github.com/BtbN/znc-betterwatch.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-irc/znc"
RDEPEND="${DEPEND}"

src_compile() {
	znc-buildmod betterwatch.cpp || die "buildmod failed"
}

src_install() {
	mkdir -p "${ED}/usr/$(get_libdir)/znc" || die "mkdir failed"
	cp betterwatch.so "${ED}/usr/$(get_libdir)/znc" || die "cp failed"
}
