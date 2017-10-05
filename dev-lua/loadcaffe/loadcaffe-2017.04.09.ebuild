# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="master"
EGIT_COMMIT="e691592773d8acda7371c229fdfd6c22e7c76f02"
EGIT_REPO_URI="https://github.com/szagoruyko/loadcaffe.git"

inherit git-r3 torch

DESCRIPTION="Load Caffe networks in dev-lua/torch7."
HOMEPAGE="https://github.com/szagoruyko/loadcaffe"
LICENSE="BSD-2"
IUSE=""

COMMON_DEPEND="~dev-lua/torch-trepl-${PV}
		~dev-lua/torch-nn-${PV}"
DEPEND+="${COMMON_DEPEND}
		=dev-libs/protobuf-3.1.0"
RDEPEND+="${COMMON_DEPEND}"

src_configure() {
	local TARGET="${WORKDIR}/${P}_build"
	local SYMLINK="${WORKDIR}/${P}/build"
	ln -s "${TARGET}" "${SYMLINK}" || die \
		"Could not create symlink '${SYMLINK}' -> '${TARGET}'"
	torch_src_configure
}
