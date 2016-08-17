#!/bin/bash
# update-git2.sh
# 
# run as a monthly cron-job
# 
# 
MY_OVERLAY="/usr/local/myoverlay"
MY_FILES="files"
MY_STORE="${MY_OVERLAY}/${MY_FILES}"
MY_TIMESTAMP=".timestamp"
MY_DATE="$(date +'%Y.%m.%d')"
MY_GIT_B="gh-pages"
EXT=".tar.gz"
MY_INDEX="index.html"

function die() {
	local MSG="${1}"
	echo "${MSG}"
	exit 1
}

function cloneAndCompress() {
	# arguments
	local REPO="${1}"
	local URI="${2}"
	local BRANCH="${3}"
	if [ -z "${BRANCH}" ]; then
		BRANCH="master"
	fi
	# prepare
	local TMP_DIR="/tmp/git-temp"
	rm -rf "${TMP_DIR}" || die "Could not clean-up '${TMP_DIR}'"
	mkdir "${TMP_DIR}" || die "Could not create '${TMP_DIR}'"
	cd "${TMP_DIR}" || die "Could not change to '${TMP_DIR}'"
	local PKG="${REPO}-${MY_DATE}"
	local ZIP="${PKG}${EXT}"
	# do clone
	git clone -q "${URI}" -b "${BRANCH}" "${PKG}" \
		|| die "Could not clone '${URI}' with branch '${BRANCH}'"
	echo "git clone ${URI} -b ${BRANCH} ${REPO}" > ${PKG}/.git-clone.sh \
		|| die "Could not create '${PKG}/.git-clone.sh' "
	rm -rf "${PKG}/.git" || die "Could not remove '${PKG}/.git' directory"
	# do compress
	tar -czf "${ZIP}" "${PKG}" || die "Could not compress '${PKG}'"
	# add to git
	cp "${ZIP}" "${MY_STORE}/" || die "Could not copy '${ZIP}' to ${MY_STORE}/'"
	#clean-up
	cd "${MY_OVERLAY}" || die "Could not change to '${MY_OVERLAY}'"
	rm -rf "${TMP_DIR}" || die "Could not clean-up '${TMP_DIR}'"
}

function generateWebPageStart() {
	echo "<html><head><title>${MY_OVERLAY} - ${MY_DATE}</title>" > "${MY_INDEX}" \
		|| die "Could not generate web-page header!"
	echo "<body><h1>${MY_OVERLAY} - ${MY_DATE}</h1>" >> "${MY_INDEX}" \
		|| die "Could not generate web-page header!"
}

function generateWebPageMain() {
	echo "<table style=\"width:100%\""  >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
	echo "<tr><td width=\"50%\">Filename</td>"  >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
	echo "<td width=\"50%\">Size</td></tr>"  >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
	for FILE in $(ls ${MY_FILES}/*${EXT}); do
		local SIZE=$(ls -sh "${FILE}" | cut -d\  -f1) \
			|| die "Could not generate web-page main for '${FILE}'!"
		echo "<tr>" >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
		echo "	<td><a href=\"${FILE}\">${FILE}</a></td>"  >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
		echo "	<td>${SIZE}</td>" >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
		echo "</tr>"  >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
	done
	echo "</table>"  >> "${MY_INDEX}" \
			|| die "Could not generate web-page main for '${FILE}'!"
}

function generateWebPageEnd() {
	echo "</body></html>" >> "${MY_INDEX}" \
		|| die "Could not generate web-page header"
}

# prepare
cd "${MY_OVERLAY}" || die "Could not change to '${MY_OVERLAY}'"
git checkout "${MY_GIT_B}" -q || die "Could not change to branch '${MY_GIT_B}'"
#git rm -rf --ignore-unmatch "${MY_FILES}" || die "Could not delete '${MY_STORE}'"
#rm -rf "${MY_FILES}" || die "Could not delete '${MY_STORE}'"
mkdir -p "${MY_STORE}" || die "Could not create '${MY_STORE}'"

# call function		repo-name	remote uri					branch-name
cloneAndCompress	dtk		https://github.com/d-tk/dtk.git	
cloneAndCompress	axel		git://dtk.inria.fr/axel/axel.git
cloneAndCompress	axel-sdk	git://dtk.inria.fr/axel/axel-sdk.git
cloneAndCompress	axel-vtkview	git://dtk.inria.fr/axel/vtkview.git
cloneAndCompress	gismo 		https://github.com/filiatra/gismo.git		stable

# generate index.html
generateWebPageStart
generateWebPageMain
generateWebPageEnd

echo "${MY_DATE}" > "${MY_TIMESTAMP}" || die "Could not write timestamp file"

# and finish
git add "${MY_INDEX}" || die "Could not add '${MY_INDEX}' to git vcs"
git add "${MY_FILES}" || die "Could not add '${MY_STORE}' to git vcs"
git add "${MY_TIMESTAMP}" || die "Could not add '${MY_TIMESTAMP}' to git vcs"
git commit -q -m "fcron monthly update at '${MY_DATE}'" \
	|| die "Could not commit to git vcs"
git push -q || die "Could not push to git vcs"
git checkout master -q || die "Could not change to branch 'master'"
