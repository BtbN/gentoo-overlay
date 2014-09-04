# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 apache-module

DESCRIPTION="Apache module for a replacement of the CGI protocol, similar to FastCGI"
HOMEPAGE="http://python.ca/scgi/ http://pypi.python.org/pypi/scgi http://github.com/BtbN/scgi"
SRC_URI=""
EGIT_REPO_URI="git://github.com/BtbN/scgi.git"

LICENSE="CNRI"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/scgi-${PV}"

APXS2_S="${S}/apache2"
APACHE2_MOD_FILE="${S}/apache2/.libs/${PN}.so"
APACHE2_MOD_CONF="20_mod_scgi"
APACHE2_MOD_DEFINE="SCGI"

DOCFILES="LICENSE.txt apache2/README.txt"

need_apache2
