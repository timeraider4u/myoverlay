# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils

SLOT="0"
DESCRIPTION="PDF Chain: a graphical user interface for the PDF Toolkit (PDFtk)."

IUSE=""
HOMEPAGE="http://sourceforge.net/projects/pdfchain/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"

RDEPEND="app-text/pdftk
	>=dev-cpp/atkmm-1.6
	>=dev-cpp/glibmm-2.4
	dev-cpp/gtkmm:3.0
	dev-libs/libsigc++:2"
DEPEND="${RDEPEND}"
