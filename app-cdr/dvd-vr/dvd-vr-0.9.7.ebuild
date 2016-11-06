# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="identify and copy recordings from a DVD-VR format disc"
HOMEPAGE="http://www.pixelbeat.org/programs/dvd-vr/"
SRC_URI="http://www.pixelbeat.org/programs/dvd-vr/dvd-vr-0.9.7.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"

#src_prepare() {
#	epatch "${FILESDIR}/Makefile.patch"
#	eapply_user
#}

src_install() {
	emake "DESTDIR='${D}'" install
	mv "${D}/usr/local/bin" "${D}/usr/" || die
	rm -r "${D}/usr/local" || die
}
