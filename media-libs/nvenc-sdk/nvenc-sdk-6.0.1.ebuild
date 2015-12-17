# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Required development files for Nvidia NVENC"
HOMEPAGE="https://developer.nvidia.com/nvidia-video-codec-sdk"
SRC_URI="http://developer.download.nvidia.com/assets/cuda/files/nvidia_video_sdk_${PV}.zip"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	insinto /usr/include
	doins nvidia_video_sdk_${PV}/Samples/common/inc/nvEncodeAPI.h
}
