# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF="yes"
inherit git-r3 autotools-utils

DESCRIPTION="It is YUMMY to your video experience on Linux like platform"
HOMEPAGE="https://github.com/01org/libyami"
EGIT_REPO_URI="https://github.com/01org/libyami.git"

KEYWORDS=""
LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/libva-1.4.0"
RDEPEND="${DEPEND}"
