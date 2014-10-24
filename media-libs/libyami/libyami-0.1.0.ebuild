# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF="yes"
inherit autotools-utils

DESCRIPTION="It is YUMMY to your video experience on Linux like platform"
HOMEPAGE="https://github.com/01org/libyami"
SRC_URI="https://github.com/01org/libyami/archive/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/libva-1.4.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	echo 'INCLUDES = -I$(top_srcdir)' >> codecparsers/Makefile.am
	echo 'INCLUDES = -I$(top_srcdir)' >> common/Makefile.am
	echo 'INCLUDES = -I$(top_srcdir)' >> tests/Makefile.am
	echo 'INCLUDES = -I$(top_srcdir)' >> vaapi/Makefile.am

	autotools-utils_src_prepare
}
