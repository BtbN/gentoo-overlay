# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION="VLC RawIO Plugin"
HOMEPAGE="https://github.com/BtbN/vlc-raw-io"
EGIT_REPO_URI="git://github.com/BtbN/vlc-raw-io.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-video/vlc"
RDEPEND="${DEPEND}"

