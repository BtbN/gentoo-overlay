# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="VA driver for Intel G45 & HD Graphics family"
HOMEPAGE="https://github.com/01org/intel-hybrid-driver"
SRC_URI="https://github.com/01org/intel-hybrid-driver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/libva-1.6.0
	>=dev-libs/cmrt-1.0.6
	>=x11-libs/libdrm-2.4.45"
RDEPEND="${DEPEND}"

S="${WORKDIR}/intel-hybrid-driver-${PV}"

src_prepare() {
	sed -i 's|AM_CPPFLAGS =|AM_CPPFLAGS = -I$(top_srcdir)/src|' src/vp9hdec/Makefile.am || die 'sed failed'
	autotools-utils_src_prepare
}
