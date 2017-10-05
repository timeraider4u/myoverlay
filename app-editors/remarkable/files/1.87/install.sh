#!/bin/bash
# 
# Copyright (C) 2017 Harald Weiner
# 
# Use to install files from GIT repository to same locations as
# debian binary package (*.deb) would do, but without registering
# them to Linux distribution package managers.
# 
# Set PREFIX environment variable to set root-directory of
# installation procedure (e.g., export PREFIX="/usr/local").
# 
# TODO: doc files are still missing!
#

function die() {
	echo "${1}"
	exit 1
}

function setString() {
	local VARNAME="${1}"
	local DEFAULT="${2}"
	if [ -z "${!VARNAME}" ]; then
		eval ${VARNAME}="${DEFAULT}" || die "Could not set '${VARNAME}'"
	fi
	#echo "${VARNAME}='${!VARNAME}'"
}

function createDirectory() {
	local VARNAME="${1}"
	local DEFAULT="${2}"
	setString "${VARNAME}" "${DEFAULT}"
	local DIRNAME="${!VARNAME}"
	mkdir -p "${DIRNAME}" || die "Could not create '${DIRNAME}'"
	#echo "mkdir -p '${DIRNAME}'"
}

function installFolders() {
	local SRC="${MYDIR}/${1}"
	local DST="${2}"
	#local MSG="${3}"
	cp -R "${SRC}" "${DST}" \
		|| die "Could not copy (recursively) '${SRC}' to '${DST}'"
}

function installFiles() {
	local SRC="${MYDIR}/${1}"
	local DST="${2}"
	#local MSG="${3}"
	cp "${SRC}" "${DST}" || die "Could not copy '${SRC}' to '${DST}'"
}

# change to directory in which this script is located
cd "$( dirname "${BASH_SOURCE[0]}" )"
MYDIR=$(pwd)
#echo "MYDIR='${MYDIR}'"

# install prefix directory
createDirectory "PREFIX" "/app"

# install binary
createDirectory "BIN_DIR" "${PREFIX}/bin"
installFiles bin/remarkable "${BIN_DIR}"/

# install library directory
createDirectory "LIB_DIR" "${PREFIX}/lib"

# install python packages
createDirectory "PYTHON_DIR" "${LIB_DIR}/python3/dist-packages"
installFolders markdown "${LIB_DIR}/python3/dist-packages"
installFolders pdfkit "${LIB_DIR}/python3/dist-packages"
installFolders remarkable "${LIB_DIR}/python3/dist-packages"
installFolders remarkable_lib "${PYTHON_DIR}"/
#installFiles appimage/*.egg-info "${PYTHON_DIR}"/

# install mime type
createDirectory "MIME_DIR" "${LIB_DIR}/mime/packages"
installFiles debian/remarkable.mime "${MIME_DIR}"/

# install share directory
createDirectory "SHARE_DIR" "${PREFIX}/share"

# install desktop entry
createDirectory "DESKTOP_DIR" "${SHARE_DIR}/applications"
installFiles remarkable.desktop "${DESKTOP_DIR}"/

# install documentation
createDirectory "DOC_DIR" "${SHARE_DIR}/doc/remarkable"
#TODO: install documentation
#(license file, changelog, README file, etc.)

# install glib
createDirectory "GLIB_DIR" "${SHARE_DIR}/glib-2.0/schemas"
installFiles data/glib-2.0/schemas/* "${GLIB_DIR}"/

# install help
createDirectory "HELP_DIR" "${SHARE_DIR}/help"
#TODO: install help files

# install icon(s)
createDirectory "ICON_DIR" "${SHARE_DIR}/icons/"
createDirectory "ICON_PNG_DIR" "${ICON_DIR}/hicolor/256x256/apps/"
installFiles data/media/remarkable.png "${ICON_PNG_DIR}"/
createDirectory "ICON_SVG_DIR" "${ICON_DIR}/hicolor/scalable/apps/"
installFiles data/media/remarkable.svg "${ICON_SVG_DIR}"/

# install remarkable data
createDirectory "APP_DIR" "${SHARE_DIR}/remarkable"
installFolders data/media "${APP_DIR}"/
installFolders data/ui "${APP_DIR}"/
