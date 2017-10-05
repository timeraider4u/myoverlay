# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="master"
EGIT_COMMIT="1b36900e1bfa6ee7f48db52c577bdeb7d9e85909"

inherit git-r3 torch

DESCRIPTION="Provide browseable help inside of dev-lua/torch-trepl"
IUSE=""

COMMON_DEPEND="~dev-lua/torch-sundown-ffi-${PV}"
DEPEND+="${COMMON_DEPEND}"
RDEPEND+="${COMMON_DEPEND}"

src_install() {
	torch_src_install
	#dodoc "docinstall/."
	#dodoc "docluajit/README.md"
	dodoc "doctutorial/README.md"
}
