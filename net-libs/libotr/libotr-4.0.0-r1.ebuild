# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libotr/libotr-4.0.0.ebuild,v 1.3 2014/02/14 20:56:01 mrueg Exp $

EAPI=5

inherit eutils

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="https://otr.cypherpunks.ca"
SRC_URI="https://otr.cypherpunks.ca/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-libs/libgcrypt-1.2
	dev-libs/libgpg-error"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README UPGRADING )

src_prepare() {
	epatch "${FILESDIR}/libotr-4.0.0-fix.patch"
	default_src_prepare
}
