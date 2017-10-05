# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit torch

DESCRIPTION="Lua-based suite for scientific computations based on multidimensional tensors."
IUSE="doc"

COMMON_DEPEND="dev-lua/luafilesystem
		dev-lua/penlight
		dev-lua/lua-cjson
		~dev-lua/torch-cwrap-${PV}
		~dev-lua/torch-paths-${PV}
		virtual/blas
		virtual/lapack"
DEPEND+="${COMMON_DEPEND}
		sys-devel/gcc[fortran]"
RDEPEND+="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}/cmake-TorchConfig.cmake.patch"
)
