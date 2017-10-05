# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit torch

DESCRIPTION="Lua-based, lightweight REPL for dev-lua/torch7"
IUSE="doc"

COMMON_DEPEND="~dev-lua/torch7-${PV}"
DEPEND+="${COMMON_DEPEND}
		sys-libs/readline"
RDEPEND+="${COMMON_DEPEND}
		~dev-lua/torch-ffi-${PV}
		~dev-lua/torch-sys-${PV}
		~dev-lua/torch-xlua-${PV}
		doc? ( ~dev-lua/torch-dok-${PV} )"

src_install() {
	torch_src_install
	# default script will fail if dev-lang/luajit is not installed, 
	# use indirection to execute with dev-lang/lua
	local SRC="${ED}/usr/bin/th"
	local DST="${ED}/${LUA_MOD_DIR}/trepl/th"
	mv "${SRC}" "${DST}" || die "Could not move '${SRC}' to '${DEST}'"
	dobin "${FILESDIR}/th"
}
