# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mono-tools/mono-tools-2.10.ebuild,v 1.7 2012/05/04 17:51:44 jdhore Exp $

EAPI="4"

inherit go-mono mono autotools

DESCRIPTION="Set of useful Mono related utilities"
HOMEPAGE="http://www.mono-project.com/"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=virtual/monodoc-${GO_MONO_REL_PV}*
	>=dev-dotnet/gtk-sharp-2.12.21
	>=dev-dotnet/webkit-sharp-0.2-r1
	"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

#PATCHES=( "${FILESDIR}/${PN}-2.10-autoconf.patch" )

#Fails parallel make.
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	go-mono_src_prepare

	# Stop getting ACLOCAL_FLAGS command not found problem like bug #298813
	sed -i -e '/ACLOCAL_FLAGS/d' Makefile.am || die

	eautoreconf
}

src_configure() {
	econf	--disable-dependency-tracking \
		--disable-gecko \
		--disable-gtkhtml \
		--enable-webkit \
		--disable-monowebbrowser
}

