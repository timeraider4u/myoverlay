# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: torch.eclass
# @MAINTAINER:
# Harald Weiner <harald.weiner@jku.at>
# @BLURB: Shared code for dev-lua/torch* packages

inherit cmake-utils

EXPORT_FUNCTIONS pkg_setup src_configure src_install

case "${EAPI}" in
	6) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

HOMEPAGE="http://torch.ch/"
#SRC_URI="https://timeraider4u.github.io/distfiles/files/${P}.tar.gz"
EGIT_REPO_URI="https://github.com/torch/${PN#*torch-}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/lua-5.1:=
		virtual/pkgconfig"
RDEPEND=">=dev-lang/lua-5.1:="
		#dev-lang/luajit:2

# @ECLASS-VARIABLE: LUA_PKG_REQ
# @INTERNAL
# @DESCRIPTION:
# Lua/LuaJIT request string for pkg-config
LUA_PKG_REQ='lua'

# @ECLASS-VARIABLE: LUA_EXECUTEABLE
# @DESCRIPTION:
# Lua/LuaJIT executeable
LUA_EXECUTEABLE="/usr/bin/lua"
#LUA_EXECUTEABLE="/usr/bin/luajit"

# @ECLASS-VARIABLE: LUA_VERSION
# @DESCRIPTION:
# Lua/LuaJIT version to use
LUA_VERSION="52"

# @FUNCTION: torch_pkg_setup
# @DESCRIPTION:
# Set-up Lua/LuaJIT variables for usage in ebuild scope
torch_pkg_setup() {
	LUA_BIN_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_BIN ${LUA_PKG_REQ})"
	LUA_INC_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_INC ${LUA_PKG_REQ})"
	#LUA_LIB_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LIB ${LUA_PKG_REQ})"
	LUA_LIB_SUB_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${LUA_PKG_REQ})"
	LUA_MOD_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${LUA_PKG_REQ})"
	LUA_LIB_DIR="${LUA_LIB_SUB_DIR}"
}

# @FUNCTION: torch_src_configure
# @DESCRIPTION:
# Pass Lua/LuaJIT variables to cmake
torch_src_configure() {
	local mycmakeargs=(
		"-DLUA=${LUA_EXECUTEABLE}"
		"-DLUA_BINDIR=${LUA_BIN_DIR}"
		"-DSCRIPTS_DIR=${LUA_BIN_DIR}"
		"-DLUA_INCDIR=${LUA_INC_DIR}"
		"-DLIBDIR=${LUA_LIB_DIR}"
		"-DLUA_LIBDIR=${LUA_LIB_SUB_DIR}"
		"-DLUADIR=${LUA_MOD_DIR}"
		"-DTORCH_LUA_VERSION=${LUA_VERSION}"
		#"-DWITH_LUA_JIT=1"
	)
	cmake-utils_src_configure
}

# @FUNCTION: torch_src_install
# @DESCRIPTION:
# Install documents if any exist
torch_src_install() {
	if [ -d "doc" ]; then
		use doc && DOCS+=( "doc/." )
	fi
	cmake-utils_src_install
	local MY_PN="${PN#*torch-}"
	local REDUNDANT_DOCDIR="${ED}/${LUA_MOD_DIR}/${MY_PN}/doc"
	if [ -d "${REDUNDANT_DOCDIR}" ]; then
		rm -r "${REDUNDANT_DOCDIR}" || \
			die "Could not delete '${REDUNDANT_DOCDIR}'"
	fi
}
