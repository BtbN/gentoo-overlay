# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="Dependency tool for go"
HOMEPAGE="https://github.com/tools/godep"
EGIT_REPO_URI="https://github.com/tools/godep.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/go"
RDEPEND="${DEPEND}"

export GOPATH="${S}"
GO_PN="github.com/tools/${PN}"
EGIT_CHECKOUT_DIR="${S}/src/${GO_PN}"

src_prepare() {
	go get "${GO_PN}" || die "go get failed"
}

src_compile() {
	go build -v -x -work "${GO_PN}" || die "go build failed"
}

src_install() {
	dobin godep
}
