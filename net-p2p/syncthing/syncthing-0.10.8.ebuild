# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 eutils systemd

DESCRIPTION="p2p file syncthing"
HOMEPAGE="http://syncthing.net/"
EGIT_REPO_URI="https://github.com/syncthing/syncthing.git"

EGIT_COMMIT="v${PV}"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="+tools"

RDEPEND="dev-lang/go"
DEPEND="${RDEPEND}
	dev-vcs/mercurial
	dev-vcs/git
	dev-util/godep"

export GOPATH="${WORKDIR}"
GO_PN="github.com/syncthing/syncthing"
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"

src_compile() {
	godep go run build.go || die "build.go failed"
}

src_install() {
	dobin bin/syncthing
	use tools && dobin bin/{stindex,stevents}

	dodoc README.md AUTHORS CONTRIBUTING.md

	newinitd "${FILESDIR}/syncthing_initd" syncthing
	newconfd "${FILESDIR}/syncthing_confd" syncthing

	systemd_newunit "${FILESDIR}/syncthing.system_service" "syncthing@.service"
	systemd_newuserunit "${FILESDIR}/syncthing.user_service" "syncthing.service"
}
