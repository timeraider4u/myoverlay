# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="master"
EGIT_COMMIT="705393fabf51581b98142c9223c5aee6b62bb131"

inherit torch

DESCRIPTION="An Image toolbox for dev-lang/torch7"
IUSE="doc"

COMMON_DEPEND="~dev-lua/torch-dok-${PV}
		~dev-lua/torch-sys-${PV}
		~dev-lua/torch7-${PV}
		~dev-lua/torch-xlua-${PV}"
DEPEND+="${COMMON_DEPEND}"
RDEPEND+="${COMMON_DEPEND}"
