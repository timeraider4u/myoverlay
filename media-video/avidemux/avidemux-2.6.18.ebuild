# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"

inherit cmake-utils eutils flag-o-matic l10n

SLOT="2.6"

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
IUSE="debug opengl nls qt4 qt5 sdl vaapi vdpau video_cards_fglrx xv"
KEYWORDS="~amd64 ~x86"

MY_PN="avidemux"
if [[ ${PV} == *9999* ]] ; then
	KEYWORDS=""
	#PROPERTIES="live"
	EGIT_REPO_URI="git://github.com/mean00/${MY_PN}2"

	inherit git-r3
else
	SRC_URI="https://github.com/mean00/${MY_PN}2/archive/${PV}.tar.gz -> ${MY_PN}_${PV}.tar.gz"
fi

DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nls?,sdl?,vaapi?,vdpau?,video_cards_fglrx?,xv?]
	opengl? ( virtual/opengl:0 )
	qt4? ( >=dev-qt/qtgui-4.8.3:4 )
	qt5? ( dev-qt/qtgui:5 )
	vaapi? ( x11-libs/libva:0 )
	video_cards_fglrx? ( >=x11-drivers/ati-drivers-14.12-r3 )"
RDEPEND="$DEPEND"
PDEPEND="~media-libs/avidemux-plugins-${PV}:${SLOT}[opengl?,qt4?,qt5?]"

S="${WORKDIR}/${MY_P}"

src_prepare() {

	# Fix icon name -> avidemux-2.6.png
	sed -i -e "/^Icon/ s:${PN}:${PN}-2.6:" ${PN}2.desktop || die "Icon name fix failed."

	# The desktop file is broken. It uses avidemux2 instead of avidemux3
	# so it will actually launch avidemux-2.5 if it is installed.
	sed -i -e "/^Exec/ s:${PN}2:${PN}3:" ${PN}2.desktop || die "Desktop file fix failed."
	sed -i -re '/^Exec/ s:(avidemux3_)gtk:\1qt'$(usex qt5 5 4)':' ${PN}2.desktop || die "Desktop file fix failed."

	# Fix QA warnings that complain a trailing ; is missing and Application is deprecated.
	sed -i -e 's/Application;AudioVideo/AudioVideo;/g' ${PN}2.desktop || die "Desktop file fix failed."

	# Now rename the desktop file to not collide with 2.5.
	mv ${PN}2.desktop ${PN}-2.6.desktop || die "Collision rename failed."

	# Remove "Build Option" dialog because it doesn't reflect what the GUI can or has been built with. (Bug #463628)
	sed -i -e '/Build Option/d' avidemux/common/ADM_commonUI/myOwnMenu.h || die "Couldn't remove \"Build Option\" dialog."

	# Fix underlinking to work with gold linker
	sed -i -e 's/\( ADM_core6\)/ Xext\1/' avidemux/common/ADM_render/CMakeLists.txt || die "Couldn't fix underlinking"

	cmake-utils_src_prepare
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

	processes="buildCLI:avidemux/cli"
	if use qt5 ; then
		mycmakeargs+=( -DENABLE_QT5=True )
		#export QT_SELECT=5
		processes+=" buildQt5:avidemux/qt4"
		#append-cxxflags $(test-flags-CXX -std=gnu++11)
	fi
	if use qt4 ; then
		#export QT_SELECT=4
		processes+=" buildQt4:avidemux/qt4"
		# Needed for gcc-6
		#append-cxxflags $(test-flags-CXX -std=gnu++98)
	fi

	if use debug ; then
		mycmakeargs+=( -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug -DADM_DEBUG=1 )
	fi

	# Filter problematic flags
	filter-flags -ftracer -flto

	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	for process in ${processes} ; do
		local build="${process%%:*}"

		mkdir "${S}"/${build} || die "Can't create build folder."
		cd "${S}"/${build} || die "Can't enter build folder."
		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${S}"/${build} cmake-utils_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		BUILD_DIR="${S}/${process%%:*}" cmake-utils_src_compile
	done
}

DOCS=( AUTHORS README )

src_install() {
	for process in ${processes} ; do
		BUILD_DIR="${S}/${process%%:*}" cmake-utils_src_install
	done

	if [[ -f "${ED}"/usr/bin/avidemux3_cli ]] ; then
		fperms +x /usr/bin/avidemux3_cli
	fi

	if [[ -f "${ED}"/usr/bin/avidemux3_jobs ]] ; then
		fperms +x /usr/bin/avidemux3_jobs
	fi

	cd "${S}" || die "Can't enter source folder."
	newicon ${PN}_icon.png ${PN}-2.6.png

	if use qt4 ; then
		fperms +x /usr/bin/avidemux3_qt4
		domenu ${PN}-2.6.desktop
	fi
	if use qt5; then
		fperms +x /usr/bin/avidemux3_qt5
		domenu ${PN}-2.6.desktop
	fi

}