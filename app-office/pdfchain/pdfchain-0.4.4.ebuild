# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 eutils autotools

SLOT="0"
DESCRIPTION="PDF Chain: a graphical user interface for the PDF Toolkit (PDFtk)."

HOMEPAGE="http://sourceforge.net/projects/pdfchain/"
EGIT_REPO_URI="git://git.code.sf.net/p/pdfchain/code" # pdfchain-code
EGIT_BRANCH="master"

LICENSE="GNU GPLv3"
KEYWORDS="~amd64"

RDEPEND="app-text/pdftk
		 dev-cpp/gtkmm
		 dev-cpp/glibmm"
DEPEND="${RDEPEND}"

src_prepare() {
	#cp "${FILESDIR}/install-sh" "${S}/install-sh" || die "Could not copy file install-sh"	
	
	eautoreconf || die "Could not autoconfigure project"
	#eautomake
}

src_configure() {
	econf || die "Could not configure project"
}

src_install() {
	emake DESTDIR="${D}" install || die "Could not install into sandbox"
}
