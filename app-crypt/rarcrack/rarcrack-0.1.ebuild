# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Brute force guess encrypted compressed file's password"
HOMEPAGE="http://rarcrack.sourceforge.net/"
SRC_URI="https://github.com/jaredsburrows/rarcrack/archive/master.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-master"

src_prepare() {
	epatch "${FILESDIR}/Makefile.patch"
	eapply_user
}

src_install() {
	dodir /usr/bin
	emake "DESTDIR='${D}'" install
	#dosym "${MY_SCRIPT}" "/usr/bin/busfactor_gui"
}
