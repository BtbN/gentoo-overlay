# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_{3,4,5} )

inherit python-any-r1 cmake-multilib

MY_PN="Vulkan-LoaderAndValidationLayers-sdk"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://www.khronos.org/vulkan/"
SRC_URI="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers/archive/sdk-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND=""

DOCS=( README.md LICENSE.txt )

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_TESTS=False
		-DBUILD_LAYERS=False
		-DBUILD_DEMOS=False
		-DBUILD_VKJSON=False
		-DBUILD_LOADER=True
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	cd "${BUILD_DIR}/loader"
	dolib libvulkan.so.1.*
	dosym libvulkan.so.1.* /usr/$(get_libdir)/libvulkan.so.1
	dosym libvulkan.so.1.* /usr/$(get_libdir)/libvulkan.so

	cd "${S}"
	insinto /usr/include/vulkan
	doins include/vulkan/*.h
	einstalldocs
}
