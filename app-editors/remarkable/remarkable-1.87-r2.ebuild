# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 )
PYTHON_REQ_USE=""

inherit eutils git-r3 python-r1

DESCRIPTION="A free fully featured markdown editor for Linux."
HOMEPAGE="http://remarkableapp.github.io"

EGIT_REPO_URI="https://github.com/timeraider4u/Remarkable.git"
EGIT_BRANCH="webkit2gtk"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
#IUSE="doc +spell"
COMMON_DEPEND="
		dev-python/beautifulsoup:4
		dev-python/markdown
		dev-python/pycairo
		dev-python/pygobject:=
		media-gfx/wkhtmltopdf
		"
DEPEND="${COMMON_DEPEND}"
# use same net-libs/webkit-gtk version as dependency dev-python/pywebkitgtk
RDEPEND="${COMMON_DEPEND}
		net-libs/webkit-gtk:4
		x11-libs/gtksourceview:3.0
		"
# https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/python-gtkspellcheck
# python-gtkspellcheck not available in Gentoo yet!
# spell? ( dev-python/gtkspell-python )

S="${WORKDIR}/${P}/"

pkg_setup() {
	PREFIX="${S}/usr"
}

src_prepare() {
	cp "${FILESDIR}/${PV}/install.sh" "${S}/" \
		|| die "Could not execute cp '${FILESDIR}/${PV}/install.sh' '${S}'"
	sed -i "s/import styles/from remarkable import styles/" \
		"${S}/remarkable/RemarkableWindow.py" \
		|| die "Could not replace 'import styles' with" \
			"'from remarkable import styles'"
	eapply_user
}

src_install() {
	# install files as if we are unzipping the debian binary package (.deb)
	(source ./install.sh) || die "Could not install files!"
	
	# install files/folders for real
	exeinto "/usr/bin"
	doexe "usr/bin/remarkable"
	insinto "/usr/share/"
	doins -r "usr/lib/mime"
	doins -r "usr/share/"{applications,glib-2.0,help,icons,remarkable}
	use doc && dodoc README.md
	#use doc && dodoc "usr/share/doc/remarkable"/*
	
	# install dist-packages
	python_setup
	python_export PYTHON_SITEDIR
	insinto "${PYTHON_SITEDIR}"
	doins -r "usr/lib/python3/dist-packages"/*
}
