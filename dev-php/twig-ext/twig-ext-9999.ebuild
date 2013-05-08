# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-stomp/pecl-stomp-1.0.5.ebuild,v 1.1 2013/03/05 10:50:44 olemarkus Exp $

EAPI="5"

PHP_EXT_NAME="twig"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-4 php5-3"

inherit php-ext-source-r2 git-2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension to speed up twig"
LICENSE=""
SLOT="0"
IUSE=""
SRC_URI=""
EGIT_REPO_URI="git://github.com/derickr/Twig.git"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git-2_src_unpack

	for slot in $(php_get_slots); do
		cp -r "${S}/ext/twig" "${WORKDIR}/${slot}"
	done
}
