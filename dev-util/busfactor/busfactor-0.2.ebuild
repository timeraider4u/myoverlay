# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
#PYTHON_REQ_USE="xml"

inherit distutils-r1 eutils

DESCRIPTION="A bus factor analyzer for Git repositories"
HOMEPAGE="https://github.com/SOM-Research/busfactor"
SRC_URI="https://timeraider4u.github.io/myoverlay/files/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/python:2.7"
RDEPEND="${DEPEND}
		~dev-util/gitana-${PV}"

#S="${WORKDIR}/Gitana-${PV}"

src_prepare() {
	cp "${FILESDIR}/${PV}/init.py" "${S}/__init__.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/init__.py' to '${S}/__init.py'"
	cp "${FILESDIR}/${PV}/setup.py" "${S}/setup.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/setup.py' to '${S}/setup.py'"
	epatch "${FILESDIR}/${PV}/bus_factor_gui.py.patch"
	distutils-r1_python_prepare_all
	eapply_user
}

python_install() {
	distutils-r1_python_install
	# install executable script in /usr/bin
	local MY_SITEDIR=$(python_get_sitedir)
	local MY_SCRIPT="${MY_SITEDIR}/${PN}/bus_factor_gui.sh"
	echo "${PYTHON} ${MY_SITEDIR}/${PN}/bus_factor_gui.py" \
		>> "${D}${MY_SCRIPT}" \
		|| die "Could not create '${D}${MY_SCRIPT}"
	chmod +x "${D}${MY_SCRIPT}" || die "Could not chmod for '${D}${MY_SCRIPT}'"
	dodir /usr/bin
	dosym "${MY_SCRIPT}" "/usr/bin/busfactor_gui"
}
