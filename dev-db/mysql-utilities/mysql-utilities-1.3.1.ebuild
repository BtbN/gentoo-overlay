# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
inherit distutils-r1

DESCRIPTION="Various usefull mysql utilities"
HOMEPAGE="http://dev.mysql.com/downloads/tools/utilities"
SRC_URI="http://cdn.mysql.com/Downloads/MySQLGUITools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/mysql-connector-python"
RDEPEND="${DEPEND}"

src_install()
{
	distutils-r1_src_install

	cd "${D}"
	rm usr/lib*/python*/site-packages/mysql/__init__.py
}
