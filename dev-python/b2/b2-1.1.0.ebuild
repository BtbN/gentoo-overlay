# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
inherit distutils-r1

DESCRIPTION="Commandline tool and library for Backblaze B2"
HOMEPAGE="https://pypi.python.org/pypi/b2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/arrow-0.8.0[${PYTHON_USEDEP}]
	<dev-python/arrow-0.12.1[${PYTHON_USEDEP}]
	>=dev-python/logfury-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.5.0[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
