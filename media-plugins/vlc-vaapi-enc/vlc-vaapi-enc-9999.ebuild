# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="VLC VAAPI Encoding Plugin"
HOMEPAGE="https://github.com/BtbN/vlc-vaapi-enc"
EGIT_REPO_URI="git://github.com/BtbN/vlc-vaapi-enc.git"
# EGIT_BRANCH="rewrite"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-video/vlc"
RDEPEND="${DEPEND}"
