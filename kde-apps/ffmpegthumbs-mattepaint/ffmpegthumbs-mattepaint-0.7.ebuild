# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit kde5 cmake-utils

DESCRIPTION="Is an alternative version of the standard KDE ffmpegthumbs..."
HOMEPAGE="http://kde-apps.org/content/show.php/FFMpegThumbs-MattePaint?content=153902"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1467623621/153902-Upload2016060900.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5"
RDEPEND="dev-libs/qjson
	>media-video/ffmpeg-2.9"

src_unpack() {
	unpack ${A}
	local DIR=$(ls -d "${WORKDIR}/Upload"*"/KF5/${PV}"*"/${PN}/")
	test -d "${DIR}" || die "Could not find '${DIR}'"
	mv "${DIR}" "${S}" \
		|| die "Could not move '${DIR}' to '${S}'"
	sed -i -s 's|) and (|) \&\& (|g' "${S}/ffmpegthumbnailer/imagewriter.cpp" \
		|| die "Could not replace and with && in C++ file"
}

src_configure(){
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=$(kf5-config --prefix)
		-DCMAKE_BUILD_TYPE=Release
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON
	)
	cmake-utils_src_configure
}
