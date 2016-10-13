# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 java-pkg-2 java-ant-2

SLOT="0"
DESCRIPTION="ProjectLibre is the open source replacement of Microsoft Project."

HOMEPAGE="http://www.projectlibre.org/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz" 
EGIT_REPO_URI="git://git.code.sf.net/p/projectlibre/code" # projectlibre-code"
EGIT_BRANCH="dev"

LICENSE="CPAL1.0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jdk-1.6"
DEPEND="${RDEPEND}"

ENC="iso-8859-1"

src_compile() {
	#einfo("SRC_COMPILE of ${P}")
	export JAVA_TOOL_OPTIONS="-Dfile.encoding=${ENC}"
	ANT_TASKS="" ant -buildfile openproj_build/build.xml "zip" \
		"-Dfile.encoding=${ENC}"
}

MYDEST_DIR="opt/LibreProject"
SYM_DEST="/opt/bin/${PN}"
src_install() {
	dodir "/opt/bin"
	dodir "/${MYDEST_DIR}"
	unzip ${WORKDIR}/${P}/openproj_build/packages/${P}.zip -d "${D}${MYDEST_DIR}"
	fperms 0755 "/${MYDEST_DIR}/${P}/${PN}.sh"
	echo "#!/bin/bash" > ${D}${SYM_DEST}
	echo "/${MYDEST_DIR}/${P}/${PN}.sh" >> ${D}${SYM_DEST}
	fperms 0755 ${SYM_DEST}
}
