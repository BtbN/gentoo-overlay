# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/snapcore/${PN}"
EGO_VENDOR=(
)

inherit golang-vcs-snapshot golang-build systemd

DESCRIPTION="Service and tools for management of snap packages"
HOMEPAGE="http://snapcraft.io/"

SRC_URI="https://github.com/snapcore/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
${EGO_VENDOR_URI}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

DEPEND="sys-apps/systemd
	sys-libs/libseccomp
	sys-fs/squashfs-tools:0
	dev-go/go-tools
	sys-libs/libcap
	sys-fs/xfsprogs
	dev-vcs/git"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.31-cmd-snap-seccomp-drop-link-flags-that-will-be-reject.patch"
)
