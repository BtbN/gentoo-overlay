# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 python3_6 )
inherit distutils-r1

DESCRIPTION="Responsible, low-boilerplate logging of method calls for python libraries"
HOMEPAGE="https://github.com/ppolewicz/logfury"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/six-1.10[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
