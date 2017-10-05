# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit torch

DESCRIPTION="A set of useful functions to extend Lua (string, table, ...)"
IUSE=""

COMMON_DEPEND+="~dev-lua/torch7-${PV}"
DEPEND+="${COMMON_DEPEND}"
RDEPEND+="${COMMON_DEPEND}"
