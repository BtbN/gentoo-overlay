# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="ProjectM Visualzation Plugin for Kodi"
HOMEPAGE="https://github.com/notspiff/visualization.projectm"
EGIT_REPO_URI="https://github.com/notspiff/visualization.projectm.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=media-tv/kodi-16
	media-libs/glew
	media-libs/libprojectm"
RDEPEND="${DEPEND}"
