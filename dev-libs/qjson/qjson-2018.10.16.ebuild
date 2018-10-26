# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Library for mapping JSON data to QVariant objects"
HOMEPAGE="http://qjson.sourceforge.net"
EGIT_REPO_URI="https://github.com/flavio/qjson.git"
EGIT_BRANCH="master"
EGIT_COMMIT="2d8624d44677c33dcd6df7e9d5c77aa7fa4d3554"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_configure() {
	local mycmakeargs=(
		-DQJSON_BUILD_TESTS=$(usex test)
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
	)

	cmake-utils_src_configure
}
