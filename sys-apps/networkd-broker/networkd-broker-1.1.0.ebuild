# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo systemd

DESCRIPTION="An event broker daemon for systemd-networkd"
HOMEPAGE="https://github.com/bpetlert/networkd-broker"
SRC_URI="https://github.com/bpetlert/networkd-broker/archive/refs/tags/1.1.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

PROPERTIES="live"

DOCS=(
	README.adoc
)

src_unpack() {
	default
	PV=9999 cargo_live_src_unpack
}

src_install() {
	cargo_src_install

	keepdir /etc/networkd/broker.d/{carrier.d,degraded.d,dormant.d,no-carrier.d,off.d,routable.d}
	systemd_dounit networkd-broker.service
	einstalldocs
}
