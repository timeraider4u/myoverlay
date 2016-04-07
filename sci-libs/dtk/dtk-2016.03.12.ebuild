# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="dtk is a meta-platform for modular scientific platform development"
HOMEPAGE="https://github.com/d-tk/dtk"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_URI="https://github.com/timeraider4u/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtquick1:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
DEPEND="${RDEPEND}
	dev-lang/swig:0"

src_configure() {
	local mycmakeargs=(
		-DDTK_BUILD_SUPPORT_COMPOSER=ON
		-DDTK_BUILD_SUPPORT_CORE=ON
		-DDTK_BUILD_SUPPORT_CONTAINER=ON
		-DDTK_BUILD_SUPPORT_DISTRIBUTED=ON
		-DDTK_BUILD_SUPPORT_GUI=ON
		-DDTK_BUILD_SUPPORT_MATH=ON
	)
	cmake-utils_src_configure
}
