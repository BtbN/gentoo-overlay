# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://gist.github.com/6ed4eeea60f6277c3e39.git"

inherit apache-module git-2

DESCRIPTION="Module for apache 2.4 that allows you to use e.g. mod_proxy_fcgi in AddHandler or SetHandler directives."
HOMEPAGE="https://gist.github.com/progandy/6ed4eeea60f6277c3e39/"
LICENSE="Apache-2.0"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

APACHE2_MOD_CONF="90_${PN}"
APACHE2_MOD_DEFINE="PROXY_HANDLER"

APXS2_ARGS="-o ${PN}.so -c *.c"

need_apache2_4
