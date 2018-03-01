# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
inherit distutils-r1 bash-completion-r1

DESCRIPTION="Commandline tool and library for Backblaze B2"
HOMEPAGE="https://pypi.python.org/pypi/b2"
SRC_URI="https://github.com/Backblaze/B2_Command_Line_Tool/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

S="${WORKDIR}/B2_Command_Line_Tool-${PV}"

src_prepare() {
	eapply_user

	# The b2 commandline util collides with boost-build, rename to b2cli
	sed -i 's|b2=b2|b2cli=b2|' setup.py || die "sed failed"
	sed -i 's|b2|b2cli|g' contrib/bash_completion/b2 || die "sed failed"

	# For some reason it installs test as a package if present.
	rm -r test || die "rm failed"

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	newbashcomp contrib/bash_completion/b2 b2cli
}
