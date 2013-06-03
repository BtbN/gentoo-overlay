# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Spotify client developer library"
HOMEPAGE="https://developer.spotify.com/technologies/libspotify/"
LICENSE="libspotify"
SLOT="0"
IUSE="doc"

#KEYWORDS="~x86 ~amd64"

SRC_URI="
amd64? ( https://developer.spotify.com/download/libspotify/${P}-Linux-x86_64-release.tar.gz ) 
x86? ( https://developer.spotify.com/download/libspotify/${P}-Linux-i686-release.tar.gz )"

if use amd64; then
	S="${WORKDIR}/${P}-Linux-x86_64-release"
fi

if use x86; then
	S="${WORKDIR}/${P}-Linux-i686-release"
fi

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	doman share/man3/*.3spotify

	if use doc; then
		dohtml share/doc/libspotify/html/*
	fi

	dodir usr/lib64
	dodir usr/lib64/pkgconfig
	dodir usr/include/libspotify

	dolib.so lib/libspotify.so*

	insinto /usr/lib64/pkgconfig
	doins lib/pkgconfig/libspotify.pc
	
	insinto /usr/include/libspotify
	doins include/libspotify/api.h
}
