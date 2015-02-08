# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DL_PN="autogen"
DL_P="${DL_PN}-${PV}"

inherit eutils

DESCRIPTION="Program and text file generation"
HOMEPAGE="http://www.gnu.org/software/autogen/"
SRC_URI="mirror://gnu/${DL_PN}/rel${PV}/${DL_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

S="${WORKDIR}/${DL_P}"

src_prepare() {
	# stub out pkg creation script, as it needs full autogen
	echo -e "#/bin/sh\nexit 0" > pkg/libopts/mklibsrc.sh || die "echo failed"

	# Make it use a dummy libsrc file instead
	sed -i 's/libsrc\s*=.*/libsrc = dummy.tar.gz/' autoopts/Makefile.in || die "sed failed"

	# Create that dummy
	touch autoopts/dummy.tar.gz || die "touch failed"
}

src_configure() {
	econf $(use_enable static-libs static) \
		--with-libxml2=no \
		--with-libguile=no \
		--with-guile-ver=1.8
}

src_compile() {
	emake config/shdefs

	pushd snprintfv
	emake
	popd

	pushd autoopts
	emake
	popd
}

src_install() {
	pushd snprintfv
	emake DESTDIR="${ED}" install
	popd

	pushd autoopts
	emake DESTDIR="${ED}" install
	popd

	rm -r "${ED}/usr/share/autogen" || die "rm failed"

	prune_libtool_files
}
