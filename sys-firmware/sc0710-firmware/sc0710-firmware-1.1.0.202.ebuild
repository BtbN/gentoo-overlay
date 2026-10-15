# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PV follows the 4K Pro driver; the others are pinned by media-video/sc0710's
# scripts/extract-firmware.sh and have to be kept in sync with it.
CLP_PV=1.1.0.194.6
STUDIO_PV=1.1.0.1714

DESCRIPTION="Elgato ECP5 FPGA firmware and EDID profiles for media-video/sc0710"
HOMEPAGE="https://github.com/Nakildias/sc0710 https://www.elgato.com/"
SRC_URI="
	4k-pro? ( https://edge.elgato.com/egc/windows/drivers/4K_Pro/Elgato_4KPro_${PV}.exe )
	cam-link-pro? ( https://edge.elgato.com/egc/windows/drivers/cam_link_pro/Cam_Link_Pro_${CLP_PV}.exe )
	edid? ( https://edge.elgato.com/egc/windows/estw/$(ver_cut 1-3 ${STUDIO_PV})/Elgato.Studio_${STUDIO_PV}_x64.msix )
"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+4k-pro cam-link-pro edid"
REQUIRED_USE="|| ( 4k-pro cam-link-pro edid )"
RESTRICT="bindist mirror"

BDEPEND="
	4k-pro? ( app-arch/7zip )
	cam-link-pro? ( app-arch/7zip )
	edid? ( app-arch/unzip )
"

src_unpack() {
	if use 4k-pro; then
		7zz e -y -o4k-pro "${DISTDIR}/Elgato_4KPro_${PV}.exe" \
			Final/Game_Capture_4K_Pro/SC0710.FWI.HEX >/dev/null || die
	fi

	if use cam-link-pro; then
		7zz e -y -ocam-link-pro "${DISTDIR}/Cam_Link_Pro_${CLP_PV}.exe" \
			CamLinkPro.HEX >/dev/null || die
	fi

	if use edid; then
		unzip -q "${DISTDIR}/Elgato.Studio_${STUDIO_PV}_x64.msix" 'EDIDFiles/*' || die
	fi
}

# Map Elgato's EDIDFiles/*.bin name to the edid= profile name the driver
# expects, mirroring edid_profile_name() in upstream's extract-firmware.sh.
# Returns 1 for files belonging to other cards.
_edid_profile_name() {
	local stem=${1%.bin}
	case ${stem} in
		EDID_4K_Pro) echo stock; return 0 ;;
		Custom_EDID_4K_Pro_*) stem=${stem#Custom_EDID_4K_Pro_} ;;
		Custom_EDID_4K_S_*|Custom_EDID_4K_X_*) return 1 ;;
		Custom_EDID_*) stem=${stem#Custom_EDID_} ;;
		*) return 1 ;;
	esac
	stem=${stem,,}
	stem=${stem//_/-}
	echo "${stem//-for-/-}"
}

src_install() {
	insinto /lib/firmware/sc0710

	use 4k-pro && doins 4k-pro/SC0710.FWI.HEX
	use cam-link-pro && newins cam-link-pro/CamLinkPro.HEX CAMLINKPRO.FWI.HEX

	if use edid; then
		insinto /lib/firmware/sc0710/edid

		local f name
		local -A seen=()
		# 4K Pro-specific files first so they win name collisions (e.g. 3440x1440).
		for f in EDIDFiles/*4K_Pro*.bin EDIDFiles/*.bin; do
			[[ -n ${seen[${f}]} ]] && continue
			seen[${f}]=1
			name=$(_edid_profile_name "${f##*/}") || continue
			while [[ -e ${ED}/lib/firmware/sc0710/edid/${name}.bin ]]; do
				cmp -s "${f}" "${ED}/lib/firmware/sc0710/edid/${name}.bin" && continue 2
				name+=-b
			done
			newins "${f}" "${name}.bin"
		done
	fi
}

pkg_postinst() {
	elog "The driver uploads the ECP5 firmware when it binds the card."
	elog "If sc0710 was already loaded, reload it to pick up the new files:"
	elog "  modprobe -r sc0710 && modprobe sc0710"
	if use edid; then
		elog
		elog "Select an EDID profile with the edid= module parameter, e.g. in"
		elog "/etc/modprobe.d/sc0710.conf:"
		elog "  options sc0710 edid=1440p"
	fi
}
