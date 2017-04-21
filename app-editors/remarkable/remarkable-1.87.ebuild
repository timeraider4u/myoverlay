# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 )

inherit python-r1

DESCRIPTION="A free fully featured markdown editor for Linux."
HOMEPAGE="http://remarkableapp.github.io"
SRC_URI="http://remarkableapp.github.io/files/${PN}_${PV}_all.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
		dev-python/beautifulsoup:4
		dev-python/markdown
		dev-python/pycairo
		dev-python/pygobject:=
		dev-python/pywebkitgtk
		media-gfx/wkhtmltopdf
		"
	# python-gtkspellcheck
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
		net-libs/webkit-gtk:3
		x11-libs/gtksourceview:3.0"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}/data.tar.xz"
}

src_install() {
	exeinto "/usr/bin"
	doexe "usr/bin/remarkable"
	insinto "/usr/share/"
	doins -r "usr/lib/mime"
	doins -r "usr/share/"{applications,glib-2.0,help,icons,remarkable}
	dodoc "usr/share/doc/remarkable"/*
	# install dist-packages
	python_setup 'python3*'
	python_export PYTHON_SITEDIR
	insinto "${PYTHON_SITEDIR}"
	doins -r "usr/lib/python3/dist-packages"/*
}
