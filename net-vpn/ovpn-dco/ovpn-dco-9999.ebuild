# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

DESCRIPTION="OpenVPN Data Channel Offload in the linux kernel"
HOMEPAGE="https://github.com/OpenVPN/ovpn-dco"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/OpenVPN/${PN}/archive/refs/tags/linux-client-v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"

	S="${WORKDIR}/ovpn-dco-linux-client-v${PV}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenVPN/ovpn-dco.git"
fi

LICENSE="GPL-2"
SLOT="0/15"
IUSE="debug"

MODULE_NAMES="ovpn-dco(updates:.:drivers/net/ovpn-dco)"
BUILD_TARGETS="all"

src_compile() {
	BUILD_PARAMS+=" KERNEL_SRC='${KERNEL_DIR}'"
	[[ ${PV} != 9999 ]] && BUILD_PARAMS+=" REVISION='${PV}'"
	use debug && BUILD_PARAMS+=" DEBUG=1"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	insinto /usr/share/${PN}
	doins -r include
}
