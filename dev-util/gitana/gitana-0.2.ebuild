# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
#PYTHON_REQ_USE="xml"

inherit distutils-r1 eutils

DESCRIPTION="SQL-based Git Repository Inspector"
HOMEPAGE="https://github.com/SOM-Research/Gitana"
SRC_URI="https://github.com/SOM-Research/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

# problem with https://github.com/SOM-Research/Gitana/issues/5
# wait for release and update version of git-python as soon as possible

DEPEND="dev-lang/python:2.7[tk]
	dev-python/git-python:0
	dev-python/mysql-connector-python:0
	dev-python/networkx:0
	dev-python/pillow:0[tk]
	dev-python/PyGithub:0
	dev-python/python-bugzilla:0
	dev-python/simplejson:0
	>=dev-vcs/git-1.9.4
	>=virtual/mysql-5.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Gitana-${PV}"

src_prepare() {
	cp "${FILESDIR}/${PV}/init.py" "${S}/__init.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/init.py' to '${S}/__init.py'"
	cp "${FILESDIR}/${PV}/setup.py" "${S}/setup.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/setup.py' to '${S}/setup.py'"
	epatch "${FILESDIR}/${PV}/gitana_gui.py.patch"
	distutils-r1_python_prepare_all
	eapply_user
}

#src_install() {
# ewarn edit ../gitana/config_db.py
# ...
# ewarn https://dev.mysql.com/doc/refman/5.7/en/stored-programs-logging.html
# mysqlclient -p
# > SET GLOBAL log_bin_trust_function_creators = 1;
# otherwise we get
# Traceback (most recent call last):
#  File "/usr/lib64/python2.7/site-packages/gitana/git2db_gui.py", line 171, in execute_import
#   g.init_dbschema(schema)
#  File "/usr/lib64/python2.7/site-packages/gitana/gitana.py", line 29, in init_dbschema
#    i.execute()
#  File "/usr/lib64/python2.7/site-packages/gitana/init_dbschema.py", line 619, in execute
#    self.init_database()
#  File "/usr/lib64/python2.7/site-packages/gitana/init_dbschema.py", line 22, in init_database
#    self.init_functions()
#  File "/usr/lib64/python2.7/site-packages/gitana/init_dbschema.py", line 360, in init_functions
#    cursor.execute(get_file_history)
#  File "/usr/lib64/python2.7/site-packages/mysql/connector/cursor.py", line 515, in execute
#    self._handle_result(self._connection.cmd_query(stmt))
#  File "/usr/lib64/python2.7/site-packages/mysql/connector/connection.py", line 488, in cmd_query
#    result = self._handle_result(self._send_cmd(ServerCmd.QUERY, query))
#  File "/usr/lib64/python2.7/site-packages/mysql/connector/connection.py", line 395, in _handle_result
#    raise errors.get_exception(packet)
#DatabaseError: 1418 (HY000): This function has none of DETERMINISTIC, NO SQL, 
#or READS SQL DATA in its declaration and binary logging is enabled
#(you *might* want to use the less safe log_bin_trust_function_creators variable)
#
# python2.7 /usr/lib64/python2.7/site-packages/gitana/gitana_gui.py
#}
#
# TODO: handle the following error message
# Traceback (most recent call last):
#  File "/usr/lib64/python2.7/site-packages/gitana/git2db_gui.py", line 175, in execute_import
#    self.buttonFinish.config(state=NORMAL)
#  File "/usr/lib64/python2.7/lib-tk/Tkinter.py", line 1326, in configure
#    return self._configure('configure', cnf, kw)
#  File "/usr/lib64/python2.7/lib-tk/Tkinter.py", line 1317, in _configure
#    self.tk.call(_flatten((self._w, cmd)) + self._options(cnf))
#TclError: out of stack space (infinite loop?)

#Exception in thread Thread-1:
#Traceback (most recent call last):
#  File "/usr/lib64/python2.7/threading.py", line 810, in __bootstrap_inner
#    self.run()
#  File "/usr/lib64/python2.7/threading.py", line 763, in run
#    self.__target(*self.__args, **self.__kwargs)
#  File "/usr/lib64/python2.7/site-packages/gitana/git2db_gui.py", line 146, in validator_import
#    self.execute_import()
#  File "/usr/lib64/python2.7/site-packages/gitana/git2db_gui.py", line 180, in execute_import
#    self.buttonFinish.config(state=NORMAL)
#  File "/usr/lib64/python2.7/lib-tk/Tkinter.py", line 1326, in configure
#   return self._configure('configure', cnf, kw)
#  File "/usr/lib64/python2.7/lib-tk/Tkinter.py", line 1317, in _configure
#    self.tk.call(_flatten((self._w, cmd)) + self._options(cnf))
#TclError: out of stack space (infinite loop?)
