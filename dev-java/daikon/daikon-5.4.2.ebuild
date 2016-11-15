# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Implementation of dynamic detection of likely invariants"
HOMEPAGE="https://plse.cs.washington.edu/daikon/"
SRC_URI="https://github.com/codespecs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

#COMMON_DEPS="dev-java/plum:0"
COMMON_DEPS=""
DEPEND="${COMMON_DEPS}"
RDEPEND="${COMMON_DEPS}"

#S="${WORKDIR}/${PN}-master"

src_prepare() {
	epatch "${FILESDIR}/java-Makefile.patch"
	eapply_user
}

src_compile() {
	emake very-clean
	#emake compile
	cd java || die "Could not change dir to '${S}/java'"
	emake all_directly
	# cd ..
	# emake jar
}

#src_install() {
#	dodir /usr/bin
#	emake "DESTDIR='${D}'" install
#	#dosym "${MY_SCRIPT}" "/usr/bin/busfactor_gui"
#}
