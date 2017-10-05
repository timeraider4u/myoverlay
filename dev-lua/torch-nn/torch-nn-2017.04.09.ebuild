# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit torch

DESCRIPTION="easy modular way to train neural networks using dev-lua/torch7"
IUSE="doc"

COMMON_DEPEND="~dev-lua/torch7-${PV}"
DEPEND+="${COMMON_DEPEND}"
RDEPEND+="${COMMON_DEPEND}"
