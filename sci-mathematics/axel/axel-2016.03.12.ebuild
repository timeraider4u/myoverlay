# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils # flag-o-matic

DESCRIPTION="Axel is an algebraic geometric modeling platform"
HOMEPAGE="http://dtk.inria.fr/axel/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_URI="https://github.com/timeraider4u/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="~sci-libs/dtk-${PV}"
DEPEND="${RDEPEND}"

#AXEL_DATA_DIR="/usr/share/axel/data"
AXEL_PLUGINS_DIR="/usr/lib/axel-plugins"

src_prepare() {
	epatch "${FILESDIR}/CMakeLists-${PV}.txt.patch"
	cp "${FILESDIR}/install-AxelConfig-${PV}.cmake.in" \
		"${S}/cmake/install-AxelConfig.cmake.in" || \
		die "Could not copy 'install-AxelConfig-${PV}.cmake.in' to '${S}/cmake/'"
	#cp "${FILESDIR}/install-axel-config-${PV}.h.in" \
	#	"${S}/cmake/install-axel-config.h.in" || \
	#	die "Could not copy 'install-axel-config-${PV}.h.in' to '${S}/cmake/'"
	epatch "${FILESDIR}/install-axel-config-${PV}.h.in"
}

src_configure() {
	#append-cxxflags -std=c++11
	local mycmakeargs=(
		-DDTK_USED=ON
		-DBUILD_FOR_RELEASE=ON
		-Daxel-sdk_VERSION_MAJOR=2
		-Daxel-sdk_VERSION_MINOR=4
		-Daxel-sdk_VERSION_PATCH=0
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodir "${AXEL_PLUGINS_DIR}"
	keepdir "${AXEL_PLUGINS_DIR}"
}
