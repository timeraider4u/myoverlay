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

LICENSE="Unknown"
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
	#epatch "${FILESDIR}/${PV}/db2json_gui.py.patch"
	#epatch "${FILESDIR}/${PV}/git2db_gui.py.patch"
	#epatch "${FILESDIR}/${PV}/gitana_gui.py.patch"
	#epatch "${FILESDIR}/${PV}/init_dbschema.py.patch"
	#epatch "${FILESDIR}/${PV}/updatedb_gui.py.patch"
	distutils-r1_python_prepare_all
	eapply_user
}

#python_install() {
#	distutils-r1_python_install
#	# install config file
#	dodir /etc/
#	local MY_SITEDIR=$(python_get_sitedir)
#	local MY_FILE="${MY_SITEDIR}/${PN}/config_db.py"
#	local MY_CONF="/etc/gitana_db.conf"
#	mv "${D}${MY_FILE}" "${D}${MY_CONF}" \
#		|| die "Could not move '${D}${MY_FILE}' to '${D}${MY_CONF}"
#	dosym "${MY_CONF}" "${MY_FILE}"
#	ewarn "Please edit /etc/gitana_db.conf with settings for your MySQL server."
#	# install executable gitana_gui in /usr/bin
#	local MY_SCRIPT="${MY_SITEDIR}/${PN}/gitana_gui.sh"
#	echo "${PYTHON} ${MY_SITEDIR}/${PN}/gitana_gui.py" \
#		>> "${D}${MY_SCRIPT}" \
#		|| die "Could not create '${D}${MY_SCRIPT}"
#	chmod +x "${D}${MY_SCRIPT}" || die "Could not chmod for '${D}${MY_SCRIPT}'"
#	dodir /usr/bin
#	dosym "${MY_SCRIPT}" "/usr/bin/gitana_gui"
#}
