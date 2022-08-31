# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 systemd git-r3

DESCRIPTION="A bouncer-style Matrix IRC bridge."
HOMEPAGE="https://github.com/hifi/heisenbridge"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-user/heisenbridge
	acct-group/heisenbridge"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/irc-19[${PYTHON_USEDEP}]
		<dev-python/irc-21[${PYTHON_USEDEP}]
		>=dev-python/ruamel-yaml-0.15.35[${PYTHON_USEDEP}]
		<dev-python/ruamel-yaml-0.18[${PYTHON_USEDEP}]
		>=dev-python/mautrix-0.15[${PYTHON_USEDEP}]
		<dev-python/mautrix-0.17[${PYTHON_USEDEP}]
		>=dev-python/python-socks-1.2.4[${PYTHON_USEDEP}]
	')"
