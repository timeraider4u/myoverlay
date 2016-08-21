# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils user

DESCRIPTION="LibreOffice on-line."
HOMEPAGE="https://www.collaboraoffice.com/"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

MIN="-1"
SERVER="loolwsd"
JS="loleaflet"

SRC_URI="https://github.com/LibreOffice/online/archive/${PV}${MIN}.tar.gz -> ${P}.tar.gz"

# libreoffice[odk]???
RDEPEND=">=app-office/libreoffice-5.2
		>=dev-libs/poco-1.7.4
		dev-python/polib
		media-libs/libpng:0
		net-libs/nodejs
		sys-libs/libcap"
DEPEND="${RDEPEND}"

pkg_setup() {
	local MYPATH="var/lib/libreoffice-online"
	enewgroup www-data
	enewuser lool -1 -1 "/${MYPATH}/home" "www-data"
}

src_unpack() {
	unpack ${A}
	local MYPATH="${WORKDIR}/online-${PV}${MIN}/"
	mv "${MYPATH}" "${S}" || die "Could not move directory '${MYPATH}' to '${S}'"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-${SERVER}-Makefile.am.patch"
	epatch "${FILESDIR}/${P}-${JS}-Makefile.patch"
	eapply_user
}

src_configure() {
	cd "${S}/${SERVER}" || die "Could not change dir to '${S}/${SERVER}'"
	local myeconfargs=( \
		--with-lokit-path="${S}/${SERVER}/bundled/include/" \
		# $(use_enable foo) \
	)
	eautoreconf
	econf ${myeconfargs}
}

src_compile() {
	# compile server component
	elog "Building ${SERVER}"
	cd "${S}/${SERVER}" || die "Could not change dir to '${S}/${SERVER}'"
	emake
	# compile JavaScript component
	elog "Building ${JS}"
	cd "${S}/${JS}" || die "Could not change dir to '${S}/${JS}'"
	emake dist
}

src_install() {
	# install server component
	cd "${S}/${SERVER}" || die "Could not change dir to '${S}/${SERVER}'"
	emake DESTDIR="${D}" install
	# install JavaScript component
	local MYPATH="var/lib/libreoffice-online"
	local MYPATH_JS="${MYPATH}/${JS}"
	dodir "/${MYPATH_JS}"
	cp -R "${S}/${JS}/${JS}-${PV}/dist"/* "${D}/${MYPATH_JS}" || die \
		"could not copy '${S}/${JS}/${JS}-${PV}/' to '${D}/${MYPATH_JS}'"
	# prepare other things
	
	dodir "/${MYPATH}/cache"
	fowners lool:www-data "/${MYPATH}/cache"
	dodir "/${MYPATH}/home"
	fowners lool:www-data "/${MYPATH}/home"
	dodir "/${MYPATH}/jails"
	fowners lool:www-data "/${MYPATH}/jails"
	fperms 0700 "/${MYPATH}/jails"
	# start /usr/bin/loolwsd
	# set lo_template_path to /usr/lib64/libreoffice
	# see loolwsd/debian/loolwsd.postinst for more installation hints
	# su - lool -c mkdir /home/lool/systemplate
	# su - lool -c loolwsd-systemplate-setup ./systemplate /usr/lib64/libreoffice/
}
