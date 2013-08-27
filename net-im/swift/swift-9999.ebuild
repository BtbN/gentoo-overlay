# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

LANGS=" ca de es fr hu nl pl ru se sk"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-2" || VCS_ECLASS=""

inherit multilib toolchain-funcs linux-info qt4-r2 scons-utils ${VCS_ECLASS}

DESCRIPTION="Your friendly chat client"
HOMEPAGE="http://swift.im/"
EGIT_REPO_URI="git://swift.im/swift"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="avahi debug doc examples +expat qt4 ssl static-libs"

RDEPEND="
	dev-libs/boost
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )
	ssl? ( dev-libs/openssl )
	avahi? ( net-dns/avahi )
	net-dns/libidn
	sys-libs/zlib
	qt4? (
		x11-libs/libXScrnSaver
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)
"
DEPEND="${RDEPEND}
	doc? (
		>=app-text/docbook-xsl-stylesheets-1.75
		>=app-text/docbook-xml-dtd-4.5
		dev-libs/libxslt
	)
"
scons_targets=()
set_scons_targets() {
	scons_targets=( Swiften )
	use qt4 && scons_targets+=( Swift )
	use avahi && scons_targets+=( Slimber )
	use examples && scons_targets+=(
		Documentation/SwiftenDevelopersGuide/Examples
		Limber
		Sluift
		Swiften/Config
		Swiften/Examples
		Swiften/QA
		SwifTools
	)
}

scons_vars=()
set_scons_vars() {
	scons_vars=(
		V=1
		allow_warnings=1
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CXXFLAGS}"
		linkflags="${LDFLAGS}"
		qt="${S}/local-qt"
		openssl="${EPREFIX}/usr"
		docbook_xsl="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets"
		docbook_xml="${EPREFIX}/usr/share/sgml/docbook/xml-dtd-4.5"
		$(use_scons debug)
		$(use !static-libs && use_scons !static-libs swiften_dll)
		$(use_scons ssl openssl)
	)
}

src_prepare() {
	mkdir local-qt
	ln -s "${EPREFIX}"/usr/$(get_libdir)/qt4 local-qt/lib || die
	ln -s "${EPREFIX}"/usr/include/qt4 local-qt/include || die

	cd 3rdParty || die
	# TODO CppUnit, Lua
	rm -rf Boost CAres DocBook Expat LCov LibIDN OpenSSL SCons SQLite ZLib || die
	cd .. || die

	for x in ${LANGS}; do
		if use !linguas_${x}; then
			rm -f Swift/Translations/swift_${x}.ts || die
		fi
	done

	# Richard H. <chain@rpgfiction.net> (2012-03-29): SCons ignores us,
	# just delete unneeded stuff!
	if use !avahi; then
		rm -rf Slumber || die
	fi

	if use !examples; then
		rm -rf Documentation/SwiftenDevelopersGuide/Examples \
                Limber \
                Slimber \
                Sluift \
                Swiften/Examples \
                Swiften/QA \
                Swiftob || die
	fi

	if use !qt4; then
		rm -rf Swift || die
	fi

	sed -i BuildTools/SCons/Tools/qt4.py \
		-e "s/linux2/linux${KV_MAJOR}/" \
		|| die
}

src_compile() {
	set_scons_targets
	set_scons_vars

	escons "${scons_vars[@]}" "${scons_targets[@]}"
}

src_test() {
	set_scons_targets
	set_scons_vars

	escons "${scons_vars[@]}" test=unit QA
}

src_install() {
	set_scons_targets
	set_scons_vars

	escons "${scons_vars[@]}" SWIFT_INSTALLDIR="${D}/usr" SWIFTEN_INSTALLDIR="${D}/usr" "${D}" "${scons_targets[@]}"

	if use avahi ; then
		newbin Slimber/Qt/slimber slimber-qt
		newbin Slimber/CLI/slimber slimber-cli
	fi

	if use examples ; then
		for i in EchoBot{1,2,3,4,5,6} EchoComponent ; do
			newbin "Documentation/SwiftenDevelopersGuide/Examples/EchoBot/${i}" "${PN}-${i}"
		done

		dobin Limber/limber
		dobin Sluift/sluift
		dobin Swiften/Config/swiften-config

		for i in BenchTool ConnectivityTest LinkLocalTool ParserTester SendFile SendMessage ; do
			newbin "Swiften/Examples/${i}/${i}" "${PN}-${i}"
		done
		newbin Swiften/Examples/SendFile/ReceiveFile "${PN}-ReceiveFile"
		use avahi && dobin Swiften/Examples/LinkLocalTool/LinkLocalTool

		for i in ClientTest NetworkTest StorageTest TLSTest ; do
			newbin "Swiften/QA/${i}/${i}" "${PN}-${i}"
		done

		newbin SwifTools/Idle/IdleQuerierTest/IdleQuerierTest ${PN}-IdleQuerierTest
	fi

	use doc && dohtml "Documentation/SwiftenDevelopersGuide/Swiften Developers Guide.html"
}
