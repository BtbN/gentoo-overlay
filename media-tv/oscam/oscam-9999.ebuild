# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
ESVN_REPO_URI="http://streamboard.de.vu/svn/oscam/trunk"

inherit eutils cmake-utils subversion

DESCRIPTION="OSCam is an Open Source Conditional Access Module software"
HOMEPAGE="http://streamboard.gmc.to:8001/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

PROTOCOLS="camd33 camd35 camd35_tcp newcamd cccam cccshare gbox radegast serial constcw pandora ghttp"
for share in ${PROTOCOLS}; do
	IUSE_PROTOCOLS+=" +protocol_${share}"
done

READERS="nagra irdeto conax cryptoworks seca viaccess videoguard dre tongfang bulcrypt griffin dgcrypt"
for card in ${READERS}; do
	IUSE_READERS+=" +reader_${card}"
done

CARD_READERS="phoenix internal sc8in1 mp35 smargo smartreader db2com stapi"
for cardreader in ${CARD_READERS}; do
	IUSE_CARDREADERS+=" +cardreader_${cardreader}"
done

IUSE="${IUSE_PROTOCOLS} ${IUSE_READERS} ${IUSE_CARDREADERS}
	pcsc +reader usb +www touch +dvbapi irdeto_guessing +anticasc debug +monitor +ssl loadbalancing cacheex cw_cycle_check lcd led ipv6"

REQUIRED_USE="
	protocol_camd35_tcp?    ( protocol_camd35 )
	reader_nagra?           ( reader )
	reader_irdeto?          ( reader irdeto_guessing )
	reader_conax?           ( reader )
	reader_cryptoworks?     ( reader )
	reader_seca?            ( reader )
	reader_viaccess?        ( reader )
	reader_videoguard?      ( reader )
	reader_dre?             ( reader )
	reader_tongfang?        ( reader )
	reader_bulcrypt?        ( reader )
	reader_griffin?         ( reader )
	reader_dgcrypt?         ( reader )
	cardreader_db2com?      ( reader )
	cardreader_internal?    ( reader )
	cardreader_mp35?        ( reader usb )
	cardreader_phoenix?     ( reader usb )
	cardreader_sc8in1?      ( reader usb )
	cardreader_smargo?      ( reader usb )
	cardreader_smartreader? ( reader usb )
	cardreader_stapi?       ( reader )
	pcsc?                   ( reader usb )
"

DEPEND="dev-libs/openssl
	usb? ( virtual/libusb:1
	       dev-libs/libusb-compat )
	pcsc? ( sys-apps/pcsc-lite )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch_user
}

src_configure() {
	local mycmakeargs="
		-DCS_CONFDIR=/etc/oscam
		$(cmake-utils_use debug WITH_DEBUG)
		$(cmake-utils_use www WEBIF)
		$(cmake-utils_use touch TOUCH)
		$(cmake-utils_use dvbapi HAVE_DVBAPI)
		$(cmake-utils_use irdeto_guessing IRDETO_GUESSING)
		$(cmake-utils_use anticasc CS_ANTICASC)
		$(cmake-utils_use monitor MODULE_MONITOR)
		$(cmake-utils_use ssl WITH_SSL)
		$(cmake-utils_use loadbalancing WITH_LB)
		$(cmake-utils_use cacheex CS_CACHEEX)
		$(cmake-utils_use led LEDSUPPORT)
		$(cmake-utils_use lcd LCDSUPPORT)
		$(cmake-utils_use ipv6 IPV6SUPPORT)
		$(cmake-utils_use cw_cycle_check CW_CYCLE_CHECK)
		$(cmake-utils_use protocol_camd33 MODULE_CAMD33)
		$(cmake-utils_use protocol_camd35 MODULE_CAMD35)
		$(cmake-utils_use protocol_camd35_tcp MODULE_CAMD35_TCP)
		$(cmake-utils_use protocol_newcamd MODULE_NEWCAMD)
		$(cmake-utils_use protocol_cccam MODULE_CCCAM)
		$(cmake-utils_use protocol_cccshare MODULE_CCCSHARE)
		$(cmake-utils_use protocol_gbox MODULE_GBOX)
		$(cmake-utils_use protocol_radegast MODULE_RADEGAST)
		$(cmake-utils_use protocol_serial MODULE_SERIAL)
		$(cmake-utils_use protocol_constcw MODULE_CONSTCW)
		$(cmake-utils_use protocol_pandora MODULE_PANDORA)
		$(cmake-utils_use protocol_ghttp MODULE_GHTTP)
		$(cmake-utils_use reader WITH_CARDREADER)
		$(cmake-utils_use reader_nagra READER_NAGRA)
		$(cmake-utils_use reader_irdeto READER_IRDETO)
		$(cmake-utils_use reader_conax READER_CONAX)
		$(cmake-utils_use reader_cryptoworks READER_CRYPTOWORKS)
		$(cmake-utils_use reader_seca READER_SECA)
		$(cmake-utils_use reader_viaccess READER_VIACCESS)
		$(cmake-utils_use reader_videoguard READER_VIDEOGUARD)
		$(cmake-utils_use reader_dre READER_DRE)
		$(cmake-utils_use reader_tongfang READER_TONGFANG)
		$(cmake-utils_use reader_bulcrypt READER_BULCRYPT)
		$(cmake-utils_use reader_griffin READER_GRIFFIN)
		$(cmake-utils_use reader_dgcrypt READER_DGCRYPT)
		$(cmake-utils_use cardreader_phoenix CARDREADER_PHOENIX)
		$(cmake-utils_use cardreader_internal CARDREADER_INTERNAL)
		$(cmake-utils_use cardreader_sc8in1 CARDREADER_SC8IN1)
		$(cmake-utils_use cardreader_mp35 CARDREADER_MP35)
		$(cmake-utils_use cardreader_smargo CARDREADER_SMARGO)
		$(cmake-utils_use cardreader_smartreader CARDREADER_SMART)
		$(cmake-utils_use cardreader_db2com CARDREADER_DB2COM)
		$(cmake-utils_use cardreader_stapi CARDREADER_STAPI)"

	use usb && mycmakeargs="-DSTATIC_LIBUSB=0 ${mycmakeargs}"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use cardreader_smargo; then
		dobin "${WORKDIR}"/"${P}"_build/utils/list_smargo|| die
	fi

	insinto "/etc/oscam"
	doins -r Distribution/doc/example/*
	fperms 0755 /etc/oscam || die
	newinitd "${FILESDIR}/oscam.initd" oscam
	newconfd "${FILESDIR}/oscam.confd" oscam

	dodir "/var/log/oscam"
}

