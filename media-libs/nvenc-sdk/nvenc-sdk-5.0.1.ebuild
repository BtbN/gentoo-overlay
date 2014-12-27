# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Required development files for Nvidia NVENC"
HOMEPAGE="https://developer.nvidia.com/nvidia-video-codec-sdk"
SRC_URI="http://developer.download.nvidia.com/compute/nvenc/v5.0_beta/nvenc_5.0.1_sdk.zip"

RESTRICT="mirror"

LICENSE="NVENC_SDK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	insinto /usr/include
	doins Samples/common/inc/nvEncodeAPI.h
}
