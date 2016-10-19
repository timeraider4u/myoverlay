# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit git-r3 eutils autotools

SLOT="0"
DESCRIPTION="PDF Chain: a graphical user interface for the PDF Toolkit (PDFtk)."

IUSE=""
HOMEPAGE="http://sourceforge.net/projects/pdfchain/"
EGIT_REPO_URI="git://git.code.sf.net/p/pdfchain/code"
EGIT_BRANCH="master"

LICENSE="GPL-3"
KEYWORDS="~amd64"

RDEPEND="app-text/pdftk
	dev-cpp/gtkmm:2.4
	dev-cpp/glibmm"
DEPEND="${RDEPEND}"

src_prepare() {
	#cp "${FILESDIR}/install-sh" "${S}/install-sh" || die "Could not copy file install-sh"	
	eautoreconf || die "Could not autoconfigure project"
	eapply_user
}

src_configure() {
	econf || die "Could not configure project"
}

src_install() {
	emake DESTDIR="${D}" install || die "Could not install into sandbox"
}
