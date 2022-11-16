# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EGO_PN=github.com/moby/libnetwork
GIT_COMMIT=f6ccccb1c082a432c2a5814aaedaca56af33d9ea
inherit go-module

DESCRIPTION="Docker container networking"
HOMEPAGE="https://github.com/moby/libnetwork"
SRC_URI="https://github.com/moby/libnetwork/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 ~riscv ~x86"

S=${WORKDIR}/${P}/src/${EGO_PN}

# needs dockerd
RESTRICT="strip test"

src_unpack() {
	mkdir -p "${S}" || die
	tar -C "${S}" -x --strip-components 1 -f "${DISTDIR}/${P}.tar.gz" || die
}

src_compile() {
	GO111MODULE=off GOPATH="${WORKDIR}/${P}" \
		go build -o "bin/docker-proxy" ./cmd/proxy || die
}

src_install() {
	dobin bin/docker-proxy
	dodoc README.md CHANGELOG.md
}
