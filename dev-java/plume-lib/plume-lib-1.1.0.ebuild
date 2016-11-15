# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

JAVA_PKG_IUSE=""

inherit eutils java-pkg-2

DESCRIPTION="Library of useful abstractions for programming"
HOMEPAGE="https://mernst.github.io/plume-lib/"
SRC_URI="https://github.com/mernst/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

COMMON_DEPS=""
#unbundling in progress...
#COMMON_DEPS="dev-java/backport-util-concurrent:0
#	dev-java/bcel:0
#	dev-java/commons-codec:0
#	dev-java/commons-io:0
#	dev-java/commons-lang:0
#	dev-java/commons-logging:0
#	dev-java/guava:*
#	dev-java/ical4j:0
#	dev-java/ini4j:0
#	dev-java/tagsoup:0
#	dev-java/xom:0"
#TEST_DEPS="dev-java/hamcrest-core:*
#	dev-java/junit:*"
DEPEND="${COMMON_DEPS}
	app-text/dos2unix
	>=virtual/jdk-1.6"
RDEPEND="${COMMON_DEPS}
	>=virtual/jre-1.6"

#S="${WORKDIR}/${PN}-master"

src_prepare() {
#	epatch "${FILESDIR}/Makefile.patch"
	cp "${FILESDIR}/run.sh" "${S}/java/" \
		|| die "Could not copy '${FILESDIR}/run.sh' to '${S}/java'"
	chmod +x "${S}/java/run.sh" || die "Could not chmod +x '${S}/java/run.sh'"
	eapply_user
}

src_compile() {
	emake bin
	cd java || die "Could not change dir to '${S}/java'"
	einfo "Changed to dir '${S}/java'"
	emake very_clean
	#emake showvars
	emake compile_without_testing
	./run.sh || die "Could not execute '${S}/java/run.sh'"
}

src_install() {
	java-pkg_dojar "java/plume.jar"
#	dodir /usr/bin
#	emake "DESTDIR='${D}'" install
#	#dosym "${MY_SCRIPT}" "/usr/bin/busfactor_gui"
}
