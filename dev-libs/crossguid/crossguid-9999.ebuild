# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs git-r3

DESCRIPTION="Lightweight cross platform C++ GUID/UUID library"
HOMEPAGE="https://github.com/graeme-hill/crossguid"
EGIT_REPO_URI="https://github.com/graeme-hill/crossguid.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	$(tc-getCXX) -c guid.cpp -o guid.o ${CXXFLAGS} -std=c++11 -DGUID_LIBUUID || die "compile failed"
	$(tc-getAR) rvs libcrossguid.a guid.o
}

src_install() {
	dolib.a libcrossguid.a
	insinto /usr/include
	doins guid.h
}
