# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Axel is an algebraic geometric modeling platform"
HOMEPAGE="http://dtk.inria.fr/axel/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_URI="https://github.com/timeraider4u/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="~sci-libs/dtk-${PV}"
DEPEND="${RDEPEND}"
