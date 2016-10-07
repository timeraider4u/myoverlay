# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
#PYTHON_REQ_USE="xml"

inherit distutils-r1 eutils

DESCRIPTION="SQL-based Git Repository Inspector"
HOMEPAGE="https://github.com/SOM-Research/Gitana"
SRC_URI="https://github.com/SOM-Research/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

# problem with https://github.com/SOM-Research/Gitana/issues/5
# wait for release and update version of git-python as soon as possible

DEPEND="dev-lang/python:2.7[tk]
	dev-python/git-python:0
	dev-python/mysql-connector-python:0
	dev-python/networkx:0
	dev-python/pillow:0[tk]
	dev-python/PyGithub:0
	dev-python/python-bugzilla:0
	dev-python/simplejson:0
	>=dev-vcs/git-1.9.4
	>=virtual/mysql-5.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Gitana-${PV}"

src_prepare() {
	cp "${FILESDIR}/${PV}/init.py" "${S}/__init__.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/init__.py' to '${S}/__init.py'"
	cp "${FILESDIR}/${PV}/setup.py" "${S}/setup.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/setup.py' to '${S}/setup.py'"
	epatch "${FILESDIR}/${PV}/db2json_gui.py.patch"
	epatch "${FILESDIR}/${PV}/git2db_gui.py.patch"
	epatch "${FILESDIR}/${PV}/gitana_gui.py.patch"
	epatch "${FILESDIR}/${PV}/init_dbschema.py.patch"
	epatch "${FILESDIR}/${PV}/updatedb_gui.py.patch"
	distutils-r1_python_prepare_all
	eapply_user
}

python_install() {
	distutils-r1_python_install
	# install config file
	dodir /etc/
	local MY_SITEDIR=$(python_get_sitedir)
	local MY_FILE="${MY_SITEDIR}/${PN}/config_db.py"
	local MY_CONF="/etc/gitana_db.conf"
	mv "${D}${MY_FILE}" "${D}${MY_CONF}" \
		|| die "Could not move '${D}${MY_FILE}' to '${D}${MY_CONF}"
	dosym "${MY_CONF}" "${MY_FILE}"
	ewarn "Please edit /etc/gitana_db.conf with settings for your MySQL server."
	# install executable gitana_gui in /usr/bin
	local MY_SCRIPT="${MY_SITEDIR}/${PN}/gitana_gui.sh"
	echo "${PYTHON} ${MY_SITEDIR}/${PN}/gitana_gui.py" \
		>> "${D}${MY_SCRIPT}" \
		|| die "Could not create '${D}${MY_SCRIPT}"
	chmod +x "${D}${MY_SCRIPT}" || die "Could not chmod for '${D}${MY_SCRIPT}'"
	dodir /usr/bin
	dosym "${MY_SCRIPT}" "/usr/bin/gitana_gui"
}
