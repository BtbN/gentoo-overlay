# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-r3

DESCRIPTION="p2p file syncthing"
HOMEPAGE="http://syncthing.net/"
EGIT_REPO_URI="https://github.com/syncthing/syncthing.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+tools"

RDEPEND="dev-lang/go"
DEPEND="${RDEPEND}
	dev-vcs/mercurial
	dev-vcs/git
	dev-util/godep"

export GOPATH="${S}"
GO_PN="github.com/syncthing/syncthing"
EGIT_CHECKOUT_DIR="${S}/src/${GO_PN}"
S="${EGIT_CHECKOUT_DIR}"

src_compile() {
	godep go run build.go || die "build.go failed"
}

src_install() {
	dobin bin/syncthing
	use tools && dobin bin/{stindex,stevents}

	dodoc README.md CONTRIBUTORS CONTRIBUTING.md
}
