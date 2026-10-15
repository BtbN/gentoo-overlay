# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_KERNEL_MIN=6.12

inherit linux-mod-r1 optfeature git-r3

DESCRIPTION="Driver for Elgato 4K60 Pro MK.2, 4K Pro and Cam Link Pro capture cards"
HOMEPAGE="https://github.com/Nakildias/sc0710"
EGIT_REPO_URI="https://github.com/Nakildias/sc0710.git"

LICENSE="GPL-2"
SLOT="0"

pkg_setup() {
	local CONFIG_CHECK="
		PCI
		VIDEO_DEV
		VIDEOBUF2_DMA_SG
		VIDEOBUF2_VMALLOC
		SND_PCM
		~FW_LOADER
	"
	local ERROR_VIDEOBUF2_DMA_SG="CONFIG_VIDEOBUF2_DMA_SG has no prompt, enable a driver that selects it (e.g. VIDEO_IPU3_CIO2, as a module is enough)"
	local ERROR_VIDEOBUF2_VMALLOC="CONFIG_VIDEOBUF2_VMALLOC has no prompt, enable a driver that selects it (e.g. USB_VIDEO_CLASS)"
	local WARNING_FW_LOADER="CONFIG_FW_LOADER is required to load the ECP5 firmware of the 4K Pro and Cam Link Pro"

	linux-mod-r1_pkg_setup
}

src_compile() {
	local modlist=( sc0710=kernel/drivers/media/pci:.:build:all )
	local modargs=( KBUILD_DIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	dodoc README.md COPYRIGHT
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst

	optfeature "Elgato 4K Pro / Cam Link Pro support (ECP5 FPGA firmware)" sys-firmware/sc0710-firmware
}
