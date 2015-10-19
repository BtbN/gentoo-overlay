# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit git-r3 autotools-utils

DESCRIPTION="VA driver for Intel G45 & HD Graphics family"
HOMEPAGE="https://github.com/01org/intel-hybrid-driver"
EGIT_REPO_URI="https://github.com/01org/intel-hybrid-driver.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=x11-libs/libva-1.6.0
	>=dev-libs/cmrt-0.10.0
	>=x11-libs/libdrm-2.4.45"
RDEPEND="${DEPEND}"

