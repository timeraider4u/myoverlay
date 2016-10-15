# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="kde-service multifunction"
HOMEPAGE="https://opendesktop.org/content/show.php/kde-services?content=147065"
SRC_URI="http://sourceforge.net/projects/${PN}/files/Source-Code/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

inherit eutils

KEYWORDS="~amd64"
IUSE="aqua"

RDEPEND=">=kde-frameworks/oxygen-icons-4.13:4[aqua=]"
DEPEND="${RDEPEND}
	dev-qt/qtcore:4
	sys-apps/dmidecode
	app-text/poppler
	media-video/ffmpeg
	media-video/transcode
	app-text/ghostscript-gpl
	dev-util/android-tools
	net-misc/youtube-dl
	media-sound/sox
	sys-fs/fuseiso
	media-fonts/liberation-fonts
	media-video/mkvtoolnix
	net-misc/wget
	x11-misc/shared-mime-info
	x11-misc/xdg-utils
	sys-process/procps
	app-arch/unar
	sys-apps/util-linux
	app-misc/mc
	sys-apps/gawk
	app-text/pdftk
	media-video/dvdauthor
	net-fs/samba
	media-video/vlc
	sys-process/psmisc
	app-crypt/gnupg
	app-text/recode
	app-accessibility/festival
	media-gfx/imagemagick
	sys-apps/findutils
	sys-process/htop
	media-libs/exiftool
	net-fs/cifs-utils
	www-client/lynx
	app-cdr/cdrtools
	net-fs/sshfs
	dev-haskell/iproute
	sys-apps/diffutils
	virtual/pkgconfig
	>=kde-base/kdelibs-4.4:4[aqua=]"

#### for isomd5sum --> layman -a sabayon  ##
#app-cdr/isomd5sum

S=${WORKDIR}/${PN}-${PV}

src_install() {
	sed -e '/mkdir\ -p \$\(PREFIXservicetypes5\)/ s/^#*/#/' -i Makefile || die
	sed -e '/servicetypes\/\*/ s/^#*/#/' -i Makefile || die
	sed -e '/xdg-mime/ s/system/user/' -i Makefile || die
	sed -e '/xdg-mime install/ s/^#*/#/' -i Makefile || die
	sed -e '/update-mime-database/ s/^#*/#/' -i Makefile || die
	sed -e '/xdg-icon-resource/ s/^#*/#/' -i Makefile || die
	sed -e '/xdg-desktop-menu/ s/^#*/#/' -i Makefile || die

	emake "RPM_BUILD_ROOT=${D}" install
	rm "${D}"/usr/share/applications/System_Tools*kernel* || die
	#rm "${D}"/usr/share/applications/*package* || die
	#cp "${S}"/ServiceMenus/System-Tools_addtoservicemenu.desktop \
	#"${D}"/usr/share/kde4/services/ServiceMenus/System-Tools_addtoservicemenu.desktop \
	# || die
}
