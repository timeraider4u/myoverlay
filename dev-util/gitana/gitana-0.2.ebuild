# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
#PYTHON_REQ_USE="xml"

inherit distutils-r1

DESCRIPTION="SQL-based Git Repository Inspector"
HOMEPAGE="https://github.com/SOM-Research/Gitana"
SRC_URI="https://github.com/SOM-Research/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/python-2.7.6
	dev-python/mysql-connector-python:0
	dev-python/networkx:0
	dev-python/git-python:0
	dev-python/python-bugzilla:0
	dev-python/PyGithub:0
	>=dev-vcs/git-1.9.4
	>=virtual/mysql-5.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Gitana-${PV}"

python_prepare_all() {
	cp "${FILESDIR}/${P}-init.py" "${S}/__init.py" \
		|| die "Could not copy '${FILESDIR}/${P}-init.py' to '${S}/__init.py'"
	cp "${FILESDIR}/${P}-setup.py" "${S}/setup.py" \
		|| die "Could not copy '${FILESDIR}/${P}-setup.py' to '${S}/setup.py'"
#	python_setup
#	echo VERSION="${PV}" "${PYTHON}" setup.py set_version
#	VERSION="${PV}" "${PYTHON}" setup.py set_version
	distutils-r1_python_prepare_all
}
