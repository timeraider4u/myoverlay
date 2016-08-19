# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="LibreOffice on-line."
HOMEPAGE="https://www.collaboraoffice.com/"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

MIN="-1"
SERVER="loolwsd"

SRC_URI="https://github.com/LibreOffice/online/archive/${PV}${MIN}.tar.gz -> ${P}.tar.gz"

RDEPEND=">=dev-libs/poco-1.7.4
		media-libs/libpng:0
		sys-libs/libcap"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	local MYPATH="${WORKDIR}/online-${PV}${MIN}/"
	mv "${MYPATH}" "${S}" || die "Could not move directory"
}

src_prepare() {
	# server component only (at the moment)
	cd "${S}/${SERVER}" || die "Could not change dir to '${S}/${SERVER}'"
	epatch "${FILESDIR}/${P}-Makefile.am.patch"
	eapply_user
}

src_configure() {
	# server component only (at the moment)
	cd "${S}/${SERVER}" || die "Could not change dir to '${S}/${SERVER}'"
	local myeconfargs=(
		--with-lokit-path="${S}/${SERVER}/bundled/include/"
		# $(use_enable foo)
	)
	eautoreconf
	econf ${myeconfargs}
}

src_compile() {
	# server component only (at the moment)
	cd "${S}/${SERVER}" || die "Could not change dir to '${S}/${SERVER}'"
	emake
}

src_install() {
	# server component only (at the moment)
	cd "${S}/${SERVER}" || die "Could not change dir to '${S}/${SERVER}'"
	emake DESTDIR="${D}" install
	# add user 'lool' ???
	# mdir /var/lib/cache/loolwsd/
	# mkdir /usr/bin/jails/
	# mkdir loleaflet
	# --o:file_server_root_path
	# start /usr/bin/loolwsd
	# libreoffice[odk]???
	# set lo_template_path to /usr/lib64/libreoffice
}
