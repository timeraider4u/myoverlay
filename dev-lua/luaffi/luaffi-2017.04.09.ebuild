# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="master"
EGIT_COMMIT="abc638c9341025580099dcf77795c4b320ba0e63"
EGIT_REPO_URI="https://github.com/jmckaskill/luaffi.git"

inherit git-r3 eutils

DESCRIPTION="FFI package for dev-lang/lua-5.1 or dev-lang/lua-5.2"
HOMEPAGE="https://github.com/jmckaskill/luaffi"
LICENSE="MIT"
IUSE=""
#IUSE="doc"

DEPEND=">=dev-lang/lua-5.1:="

src_install() {
	local LUA_LIB_SUB_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD 'lua')"
	dodir "${LUA_LIB_SUB_DIR}"
	cp "${S}/ffi.so" "${ED}/${LUA_LIB_SUB_DIR}" || die "Could not install ffi.so"
}
