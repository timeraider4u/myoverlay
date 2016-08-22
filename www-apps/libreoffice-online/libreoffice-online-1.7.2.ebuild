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
MYUSER="lool"
MYGROUP="www-data"

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
	enewgroup "${MYGROUP}"
	enewuser "${MYUSER}" -1 -1 "/${MYPATH}/home" "${MGROUP}"
}

src_unpack() {
	unpack ${A}
	local MYPATH="${WORKDIR}/online-${PV}${MIN}/"
	mv "${MYPATH}" "${S}" || die "Could not move directory '${MYPATH}' to '${S}'"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-${SERVER}-Makefile.am.patch"
	epatch "${FILESDIR}/${P}-${SERVER}-LOOLKit.cpp.patch"
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
	fowners "${MYUSER}:${MGROUP}" "/${MYPATH}/cache"
	dodir "/${MYPATH}/home"
	fowners "${MYUSER}:${MGROUP}" "/${MYPATH}/home"
	dodir "/${MYPATH}/jails"
	fowners "${MYUSER}:${MGROUP}" "/${MYPATH}/jails"
	fperms 0700 "/${MYPATH}/jails"
	dodir "/${MYPATH}/systemplate"
	fowners "${MYUSER}:${MGROUP}" "/${MYPATH}/systemplate"
	# move /usr/bin/... /usr/sbin/ ???
	# start /usr/bin/${MYUSER}wsd
	# set lo_template_path to /usr/lib64/libreoffice
	# see ${MYUSER}wsd/debian/${MYUSER}wsd.postinst for more installation hints
	# su - ${MYUSER} -c mkdir /home/${MYUSER}/systemplate
	# su - ${MYUSER} -c ${MYUSER}wsd-systemplate-setup ./systemplate /usr/lib64/libreoffice/
	## RC script ##
    #    newinitd "${FILESDIR}/${PN}.init" "${PN}"
    #    newconfd "${FILESDIR}/${PN}.conf" "${PN}"
    local LOGDIR="/var/log/libreoffice-online/"
    dodir "${LOGDIR}"
    fowners "${MYUSER}:${MGROUP}" "${LOGDIR}"

}

pkg_postinst() {
	local MYPATH="var/lib/libreoffice-online" 
	/usr/bin/loolwsd-systemplate-setup \
		"/${MYPATH}/systemplate" \
		"/usr/lib64/libreoffice/"
#	elog "su -l ${MYUSER} -s /bin/bash -c '/usr/bin/loolwsd-systemplate-setup" \
#		"/${MYPATH}/systemplate" \
#		"/usr/lib64/libreoffice/'"
#	su -l "${MYUSER}" -s /bin/bash -c "/usr/bin/loolwsd-systemplate-setup" \
#		"/${MYPATH}/systemplate" \
#		"/usr/lib64/libreoffice/"
}
