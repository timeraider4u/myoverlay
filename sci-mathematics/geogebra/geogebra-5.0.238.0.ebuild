# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Mathematics software for geometry"
HOMEPAGE="http://www.geogebra.org/cms/en"
PORTABLE="GeoGebra-Linux-Portable-${PV}"
SRC_URI="http://download.geogebra.org/installers/5.0/${PORTABLE}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3 CC-BY-SA-3.0 BSD public-domain GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jdk-1.6.0-r1
	${DEPEND}"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PORTABLE}" "${WORKDIR}/${P}" || die "could not rename directory in workdir"
}

src_install() {
	dodir "/usr/share/${PN}/"
	dodir /usr/bin
	cp -R "${WORKDIR}/${P}/${PN}" "${D}/usr/share/" || die "install failed"
	dosym "../share/${PN}/${PN}" "/usr/bin/${PN}"
}