# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="FFmpeg version of headers required to interface with Nvidias codec APIs"
HOMEPAGE="https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git"
EGIT_REPO_URI="https://git.videolan.org/git/ffmpeg/nv-codec-headers.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_compile() {
	emake PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)"
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)" DESTDIR="${D}" install

	dodir /usr/share
	mv -- "${ED}"/usr/$(get_libdir)/pkgconfig "${ED}"/usr/share || die
}
