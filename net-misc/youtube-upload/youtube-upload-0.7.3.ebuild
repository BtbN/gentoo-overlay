# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Upload videos to Youtube from the command-line"
HOMEPAGE="http://code.google.com/p/youtube-upload/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tgz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/gdata-1.2.4"
RDEPEND="${DEPEND}"

DOCS="README CHANGELOG"

