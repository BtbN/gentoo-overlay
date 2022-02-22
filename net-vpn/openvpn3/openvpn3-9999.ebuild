# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="Next generation OpenVPN client"
HOMEPAGE="https://openvpn.net"
EGIT_REPO_URI="https://github.com/OpenVPN/openvpn3-linux.git"

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
fi

LICENSE="AGPL-3+"
SLOT="0"
IUSE="mbedtls dco"

DEPEND="
	acct-group/openvpn
	acct-user/openvpn
	dev-libs/jsoncpp:=
	sys-libs/libcap-ng:=
	app-arch/lz4:=
	dev-libs/glib:=
	>=dev-libs/tinyxml2-8.0.0:=
	mbedtls? ( net-libs/mbedtls:= )
	!mbedtls? ( >=dev-libs/openssl-1.0.2:= )
	dco? (
		net-vpn/ovpn-dco:=
		dev-libs/protobuf:=
		dev-libs/libnl:=
	)"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/autoconf-archive"

src_prepare() {
	eapply_user
	./update-version-m4.sh
	eautoreconf
}

src_configure() {
	export DCO_SOURCEDIR="/usr/share/ovpn-dco"
	econf \
		--with-crypto-library=$(usex mbedtls mbedtls openssl) \
		$(use_enable dco)
}
