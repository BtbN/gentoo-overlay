# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-utils git-r3

DESCRIPTION="Twitch TMI helper plugin for ZNC"
HOMEPAGE="https://github.com/BtbN/ZncTwitchTMI"
EGIT_REPO_URI="https://github.com/BtbN/ZncTwitchTMI.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-irc/znc"
RDEPEND="${DEPEND}"
