# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.88.0"
inherit cargo git-r3 systemd

DESCRIPTION="Standalone Anki sync server"
HOMEPAGE="https://docs.ankiweb.net/sync-server.html"
EGIT_REPO_URI="https://github.com/ankitects/anki.git"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS=""

DEPEND="sys-apps/systemd"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/protobuf"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	PROTOC=protoc cargo_src_compile --locked -p anki-sync-server
}

src_install() {
	dobin "$(cargo_target_dir)"/anki-sync-server

	insinto /etc
	doins "${FILESDIR}"/anki-sync-server.env
	fperms 0600 /etc/anki-sync-server.env

	systemd_dounit "${FILESDIR}"/anki-sync-server.service
}
