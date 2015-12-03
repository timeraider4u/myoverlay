# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils autotools

DESCRIPTION="Axel is an algebraic geometric modeling platform."
HOMEPAGE="http://dtk.inria.fr/axel/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

SRC_URI="https://github.com/timeraider4u/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="sci-libs/vtk[rendering]"
DEPEND="${RDEPEND}"

PREFIX="/opt/axel-sdk"
PREFIX2="${ROOT}${PREFIX}"
CMAKE_INSTALL_PREFIX="${PREFIX}"

QT_DIR="/opt/Qt5.5.0/5.5/gcc_64"

src_prepare() {
	cp "${FILESDIR}/axel-sdk.conf" "${S}/axel-sdk.conf" || "could not copy axel-sdk.conf"
	cp "${FILESDIR}/AxelConfig.cmake" "${S}/AxelConfig.cmake" || die "could not copy AxelConfig.cmake"
	epatch "${FILESDIR}/${PN}-${PV}-CMakeLists.txt.patch"
	./script/config_anonym || die "config_anonym could not be executed"
	epatch "${FILESDIR}/${PN}-${PV}-axel-CMakeLists.txt.patch"
	epatch "${FILESDIR}/${PN}-${PV}-dtk-CMakeLists.txt.patch"
}

src_configure() {
   # general configuration
   local mycmakeargs=(
       -DVTK_QT_VERSION:STRING=5
       -DQT_QMAKE_EXECUTABLE:PATH="${QT_DIR}"/bin/qmake 
       -DCMAKE_PREFIX_PATH:PATH="${QT_DIR}"/lib/cmake
   #    -DVTK_DIR=/Users/cg/Documents/axel-sdk/build-vtk
   )
   
   cmake-utils_src_configure
}

src_install() {
	default_src_install
	cmake-utils_src_install
	elog "executing installation adjustments"
	
	fowners ${rootuser}:video ${PREFIX}/plugins
	fperms 0775 "${PREFIX}/plugins"
	dodir /opt/bin
	dosym ${PREFIX}/bin/axel /opt/bin/axel
	dodir ${PREFIX}/cmake/plugins
	fowners ${rootuser}:video ${PREFIX}/cmake/plugins
	fperms 0775 "${PREFIX}/cmake/plugins"
	# add symlinks for include directories
	dosym ${PREFIX}/include/dtk/dtkConfig.h ${ROOT}/usr/include/dtkConfig.h
	for FILE in $(find "${D}/${PREFIX}/include/" -type d); do
		NAME=$(basename ${FILE})
		dosym ${PREFIX}/include/${NAME} ${ROOT}/usr/include/${NAME}
	done
	# add symlink for axlCoreExport.h
	#dodir ${PREFIX}/include/axlCore/
	#dosym ${PREFIX}/include/axlCore/axlCoreExport.h ${ROOT}/usr/include/axlCore/axlCoreExport.h
	# add symlinks for lib64-files in /opt/axel-sdk
	for FILE in $(ls ${D}/${PREFIX}/lib64); do
		NAME=$(basename ${FILE})
		dosym ${PREFIX}/lib64/${NAME} ${PREFIX2}/lib/${NAME}
	done
	# add ld.so.config file 
	dodir /etc/ld.so.conf.d
	insinto /etc/ld.so.conf.d
	doins axel-sdk.conf
}

pkg_postinst() {
	# update ldconfig
    ldconfig
}
