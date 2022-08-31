# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd git-r3

DESCRIPTION="Dendrite is a second-generation Matrix homeserver written in Go."
HOMEPAGE="https://github.com/matrix-org/dendrite"

EGIT_REPO_URI="https://github.com/matrix-org/dendrite.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

DEPEND="acct-group/dendrite
	acct-user/dendrite"
RDEPEND="$DEPEND"

src_unpack() {
	git-r3_src_unpack

	cd "${S}" || die
	ego mod download
}

src_compile() {
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"

	export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -v"
	export CGO_ENABLED=1

	ego build "./cmd/dendrite-monolith-server"
	ego build "./cmd/generate-config"
	ego build "./cmd/generate-keys"
	ego build "./cmd/create-account"
}

src_install() {
	exeinto /usr/bin
	newexe dendrite-monolith-server "${PN}"
	newexe generate-config "${PN}-generate-config"
	newexe generate-keys "${PN}-generate-keys"
	newexe create-account "${PN}-create-account"

	insinto "/etc/${PN}"
	newins dendrite-sample.monolith.yaml config.yaml
	fowners root:dendrite "/etc/${PN}"
	fperms 0750 "/etc/${PN}"

	keepdir "/var/log/${PN}"
	fowners dendrite:dendrite "/var/log/${PN}"
	fperms 0755 "/var/log/${PN}"

	systemd_newunit "${FILESDIR}"/dendrite.service "${PN}.service"
}
