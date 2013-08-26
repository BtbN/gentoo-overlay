# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mono-addins/mono-addins-0.6.2.ebuild,v 1.5 2012/05/04 03:56:57 jdhore Exp $

EAPI="4"

inherit mono multilib

DESCRIPTION="A generic framework for creating extensible applications"
HOMEPAGE="http://www.mono-project.com/Mono.Addins"
SRC_URI="http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=monoaddins&DownloadId=509482&FileTime=129948574181430000&Build=20717 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="+gtk"

RDEPEND=">=dev-lang/mono-3
	gtk? ( >=dev-dotnet/gtk-sharp-2.12.21 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	sed -i "s;Mono.Cairo;Mono.Cairo, Version=4.0.0.0, Culture=neutral, PublicKeyToken=0738eb9f132ed756;g" Mono.Addins.Gui/Mono.Addins.Gui.csproj || die "sed failed"
}

src_configure() {
	econf $(use_enable gtk gui)
}

src_compile() {
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	mono_multilib_comply
}

