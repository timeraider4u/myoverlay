# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# commit from 2016-12-10
EGIT_BRANCH="master"
EGIT_COMMIT="4379f5002eb7ad71e50befa44a07e6b31d2bd407"
EGIT_REPO_URI="https://github.com/jcjohnson/neural-style.git"

inherit git-r3 eutils

DESCRIPTION="dev-lua/torch7 implementation of paper 'A Neural Algorithm of Artistic Style'"
HOMEPAGE="https://github.com/jcjohnson/neural-style"
#SRC_URI="https://timeraider4u.github.io/distfiles/files/${P}.tar.gz
SRC_URI="
	https://gist.githubusercontent.com/ksimonyan/3785162f95cd2d5fee77/raw/bb2b4fe0a9bb0669211cf3d0bc949dfdda173e9e/VGG_ILSVRC_19_layers_deploy.prototxt
	http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_19_layers.caffemodel"

# additional files are downloaded by download bash script
# which do not provide clear copyright information
LICENSE="MIT
	all-rights-reserved"

SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="~dev-lua/loadcaffe-${PV}
		~dev-lua/torch-image-${PV}
		~dev-lua/torch-optim-${PV}"
RDEPEND="${DEPENDS}"

src_unpack() {
	unpack "${P}.tar.gz"
	cp "${DISTDIR}/VGG_ILSVRC_19_layers_deploy.prototxt" "${S}/models" || \
		die "Could not unpack VGG_ILSVRC_19_layers_deploy.prototxt"
	cp "${DISTDIR}/VGG_ILSVRC_19_layers.caffemodel" "${S}/models/" || \
		die "Could not unpack VGG_ILSVRC_19_layers.caffemodel"
	# download missing models (ignore invalid certificate)
	cd "${S}" || die "Could not change dir to '${S}'"
	chmod +x "${S}/models/download_models.sh" || die \
		"Download script not executeable"
	"${S}/models/download_models.sh" || die "Could not download missing models!"
}

src_install() {
	local MYDIR="/usr/share/${PN}"
	insinto "${MYDIR}"
	doins "neural_style.lua"
	ln -s "${ED}/${MYDIR}/neural_style.lua" "${ED}/${MYDIR}/init.lua" \
		|| die "Could not create symlink for init.lua"
	use examples && doins -r "examples"
	doins -r "models"
	local LUA_MOD_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD 'lua')"
	dodir "${LUA_MOD_DIR}"
	ln -s "../../neural-style" "${ED}/${LUA_MOD_DIR}/neural-style" \
		|| die "Could not create symlink for neural-style directory"
	exeinto "/usr/bin"
	doexe "${FILESDIR}/neural-style-cpu.sh"
}
