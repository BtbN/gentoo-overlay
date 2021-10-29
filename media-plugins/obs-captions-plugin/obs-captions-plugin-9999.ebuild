# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

if [[ ${PV} != *9999 ]]; then
	KEYWORDS="~amd64"
	EGIT_COMMIT="${PV}"
fi

EGIT_REPO_URI="https://github.com/ratwithacompiler/OBS-captions-plugin.git"
DESCRIPTION="Closed captioning via Google Cloud Speech Recognition API"
HOMEPAGE="https://github.com/ratwithacompiler/OBS-captions-plugin"

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	media-video/obs-studio
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	net-libs/grpc:=
	dev-libs/protobuf:="
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_CUSTOM_API_KEY=ON
		-DSPEECH_API_GOOGLE_GRPC_V1=ON
		-DBUILD_SHARED_LIBS=ON
		-DOBS_SOURCE_DIR="${EPREFIX}"/usr/include/obs
		-DOBS_LIB_DIR="${EPREFIX}"/usr/"$(get_libdir)"
		-DCMAKE_CXX_FLAGS="-isystem '${EPREFIX}/usr/include/obs'"
	)
	cmake_src_configure
}
