# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Jake - the JavaScript build tool for Node.js"
HOMEPAGE="http://jakejs.com/"
SRC_URI="https://github.com/jakejs/${PN}/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

RDEPEND="net-libs/nodejs:0"
DEPEND="${RDEPEND}"

src_prepare(){
	epatch "${FILESDIR}/Makefile.patch"
	eapply_user
	#[[ ${PV} == 9999 ]] && eautoreconf
}

#src_configure() {
#	econf \
#		$(use_enable doc docs) \
#		$(use_enable valgrind memory_tests)
#}

#src_compile() { :; }

#src_test() {
#	tc-export CXX
#	default
#}

#src_install() {
#	emake DESTDIR=
#}
