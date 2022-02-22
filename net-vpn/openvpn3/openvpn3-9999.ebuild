# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9,10} )

inherit git-r3 autotools python-single-r1

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

DEPEND="${PYTHON_DEPS}
	acct-group/openvpn
	acct-user/openvpn
	dev-libs/jsoncpp:=
	sys-libs/libcap-ng:=
	app-arch/lz4:=
	dev-libs/glib:=
	dev-libs/tinyxml2:=
	mbedtls? ( net-libs/mbedtls:= )
	!mbedtls? ( >=dev-libs/openssl-1.0.2:= )
	dco? (
		net-vpn/ovpn-dco:=
		>=dev-libs/protobuf-2.4.0:=
		>=dev-libs/libnl-3.2.29:=
	)"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep 'dev-python/pyopenssl[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')"
BDEPEND="${PYTHON_DEPS}
	sys-devel/autoconf-archive"

src_prepare() {
	eapply_user
	./update-version-m4.sh
	eautoreconf
}

src_configure() {
	export DCO_SOURCEDIR="/usr/share/ovpn-dco"
	export OPENVPN3_STATEDIR="/var/lib/openvpn3"
	econf \
		--with-crypto-library=$(usex mbedtls mbedtls openssl) \
		$(use_enable dco)
}

src_install() {
	default
	python_fix_shebang "${ED}"
	keepdir /var/lib/openvpn3/configs
}
