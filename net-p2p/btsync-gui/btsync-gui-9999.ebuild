# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_{5,6,7} )

[[ "${PV}" == "9999" ]] && inherit git-r3
inherit python-single-r1 eutils versionator

DESCRIPTION="Unofficial Bittorrent Sync GUI for Linux desktops"
HOMEPAGE="https://github.com/tuxpoldo/btsync-deb"
SRC_URI="http://syncapp.bittorrent.com/18TDE4IPRO/BitTorrentSyncUserGuide.pdf"
[[ "${PV}" == "9999" ]] || SRC_URI="${SRC_URI} https://github.com/tuxpoldo/btsync-deb/archive/${PN}-$(get_version_component_range 1-3)-$(get_version_component_range 4).tar.gz"
EGIT_REPO_URI="https://github.com/tuxpoldo/btsync-deb.git"

RESTRICT="mirror"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
	S="${WORKDIR}/${P}/btsync-gui"
else
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/btsync-deb-${PN}-$(get_version_component_range 1-3)-$(get_version_component_range 4)/btsync-gui"
fi

DEPEND="${PYTHON_DEPS}
	net-p2p/btsync
	sys-devel/gettext
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	media-gfx/qrencode-python[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	sed -i '1s;^;#!/usr/bin/env python2\n;' *.py || die "sed failed"
}

src_install() {
	python_scriptinto /usr/bin
	python_fix_shebang btsync-gui
	python_doexe btsync-gui

	python_scriptinto /usr/lib/btsync-gui
	python_doscript *.py

	insinto /usr/lib/btsync-gui
	doins "${FILESDIR}/btsync-gui.key" *.glade

	mkdir -p "${ED}/usr/share/icons/hicolor" || die "mkdir failed"
	cp -R "${S}"/icons/* "${ED}/usr/share/icons/hicolor" || die "cp failed"

	domenu btsync-gui.desktop

	doman btsync-gui.7

	dodoc *.md
	dodoc "${DISTDIR}/BitTorrentSyncUserGuide.pdf"

	cd po
	for PO in *.po; do
		LANG_CODE="$(basename "${PO}" .po)"
		mkdir -p "${ED}/usr/share/locale/${LANG_CODE}/LC_MESSAGES" || die "mkdir failed"
		msgfmt -c "${PO}" -o "${ED}/usr/share/locale/${LANG_CODE}/LC_MESSAGES/btsync-gui.mo" 2>/dev/null || die "msgfmt failed"
	done
}
