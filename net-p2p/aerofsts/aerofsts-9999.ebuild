# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="File sync without servers."
HOMEPAGE="https://www.aerofs.com/"
SRC_URI=""

LICENSE="" # unknown
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
    app-arch/sharutils
    virtual/jre
"
RDEPEND="${DEPEND}"
S="${WORKDIR}/aerofs"

src_unpack()
{
	cd "${WORKDIR}"
	curl "http://cache.client.aerofs.com/${PN}-installer.tgz" | tar xz
}

src_prepare() {
    cd "${S}"

    # see http://support.aerofs.com/forums/147816-linux-problems/suggestions/3578017-aerofs-and-arch-linux
    sed 's#uudecode -o /dev/stdout \$0 | tar xzf - -C \$TMP_DIR 2>/dev/null#(cd $TMP_DIR \&\& uudecode "$0" \&\& tar xzf bin -C . 2>/dev/null; rm bin)#' -i "${PN}" || die "uudecode sed failed"

    # see http://support.aerofs.com/forums/147816-linux-problems/suggestions/3135916-daemon-exited-with-code-127
    sed 's#^JRE_BASE=.*#JRE_BASE="$JAVA_HOME"#' -i "${PN}" || die "JRE_BASE sed failed"
}

src_install() {
    cd "${S}"

    dobin "${PN}"                                                                                                                                    
    for t in cli gui sh; do                                                                                                                          
        dosym "${PN}" "${DESTTREE}/bin/${PN}-${t}"                                                                                                   
    done                                                                                                                                             
}
