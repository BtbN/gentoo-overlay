# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} python{3_1,3_2,3_3} )
inherit distutils-r1

DESCRIPTION="Mysql connector python library"
HOMEPAGE="http://dev.mysql.com/downloads/tools/utilities"
SRC_URI="http://cdn.mysql.com/Downloads/Connector-Python/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
