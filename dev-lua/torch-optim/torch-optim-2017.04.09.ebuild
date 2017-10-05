# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit torch

DESCRIPTION="An optimization library for dev-lang/torch7"
IUSE="doc"

COMMON_DEPEND="~dev-lua/torch7-${PV}"
DEPEND+="${COMMON_DEPEND}"
RDEPEND+="${COMMON_DEPEND}"
