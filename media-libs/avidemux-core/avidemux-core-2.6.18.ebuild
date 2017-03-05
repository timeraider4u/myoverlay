# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils eutils flag-o-matic

SLOT="2.6"

DESCRIPTION="Core libraries for media-video/avidemux"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
IUSE="debug nls sdl vaapi vdpau video_cards_fglrx xv"
KEYWORDS="~amd64 ~x86"

SRC_URI="https://github.com/mean00/avidemux2/archive/${PV}.tar.gz -> avidemux_${PV}.tar.gz"

# Trying to use virtual; ffmpeg misses aac,cpudetection USE flags now though, are they needed?
DEPEND="
	!<media-video/avidemux-${PV}:${SLOT}
	dev-db/sqlite:3
	sdl? ( media-libs/libsdl:0 )
	xv? ( x11-libs/libXv:0 )
	vaapi? ( x11-libs/libva:0 )
	vdpau? ( x11-libs/libvdpau:0 )
	video_cards_fglrx? ( >=x11-drivers/ati-drivers-14.12-r3 )
"
RDEPEND="
	$DEPEND
	nls? ( virtual/libintl:0 )
"
DEPEND="
	$DEPEND
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/avidemux_${PV}"
BUILD_DIR="${S}/buildCore"

DOCS=( AUTHORS README )

src_prepare() {
	mkdir "${BUILD_DIR}" || die "Can't create build folder."

	# Avoid existing avidemux installations from making the build process fail, bug #461496.
	sed -i -e "s:getFfmpegLibNames(\"\${sourceDir}\"):getFfmpegLibNames(\"${S}/buildCore/ffmpeg/source/\"):g" cmake/admFFmpegUtil.cmake \
		|| die "Failed to avoid existing avidemux installation from making the build fail."

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	# Filter problematic flags
	filter-flags -fwhole-program -flto

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DAVIDEMUX_SOURCE_DIR="'${S}'"
		-DGETTEXT="$(usex nls)"
		-DSDL="$(usex sdl)"
		-DLIBVA="$(usex vaapi)"
		-DVDPAU="$(usex vdpau)"
		-DXVBA="$(usex video_cards_fglrx)"
		-DXVIDEO="$(usex xv)"
	)

	if use debug ; then
		mycmakeargs+=( -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug -DADM_DEBUG=1 )
	fi

	CMAKE_USE_DIR="${S}"/avidemux_core cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -j1
}

src_install() {
	# revert edit from src_prepare prior to installing
	sed -i \
		-e "s:getFfmpegLibNames(\"${S}/buildCore/ffmpeg/source/\"):getFfmpegLibNames(\"\${sourceDir}\"):g" \
		cmake/admFFmpegUtil.cmake  || die "${error}"
	cmake-utils_src_install -j1
}
