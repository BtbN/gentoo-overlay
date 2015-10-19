# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="Media GPU kernel manager for Intel G45 & HD Graphics family"
HOMEPAGE="https://github.com/01org/cmrt"
SRC_URI="https://github.com/01org/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/libva-1.6.0
	>=x11-libs/libdrm-2.4.23"
RDEPEND="${DEPEND}"
