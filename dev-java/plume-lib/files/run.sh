# Taken from java/Makefile
JAR="/usr/bin/jar"

mkdir jar-contents
mkdir jar-contents/plume
cp -p src/plume/*.class jar-contents/plume
(cd jar-contents; "${JAR}" xf ../lib/backport-util-concurrent-3.1.jar)
(cd jar-contents; "${JAR}" xf ../lib/bcel.jar)
(cd jar-contents; "${JAR}" xf ../lib/checker-qual-2.1.1.jar)
(cd jar-contents; "${JAR}" xf ../lib/commons-codec-1.10.jar)
(cd jar-contents; "${JAR}" xf ../lib/commons-io-2.5.jar)
# ical4j 1.0.6 requrires the legacy library commons-lang-2.6.jar
(cd jar-contents; "${JAR}" xf ../lib/commons-lang-2.6.jar)
(cd jar-contents; "${JAR}" xf ../lib/commons-lang3-3.4.jar)
(cd jar-contents; "${JAR}" xf ../lib/commons-logging-1.2.jar)
(cd jar-contents; "${JAR}" xf ../lib/guava-19.0.jar)
(cd jar-contents; "${JAR}" xf ../lib/ical4j-1.0.6.jar)
(cd jar-contents; "${JAR}" xf ../lib/ini4j-0.5.4.jar)
# Do not include junit.jar in plume.jar; JUnit is needed only for testing
#	(cd jar-contents; "${JAR}" xf ../lib/hamcrest-core-1.3.jar)
#	(cd jar-contents; "${JAR}" xf ../lib/junit-4.12.jar)
(cd jar-contents; "${JAR}" xf ../lib/svnkit-1.8.10-complete.jar)
(cd jar-contents; "${JAR}" xf ../lib/tagsoup-1.2.1.jar)
(cd jar-contents; "${JAR}" xf ../lib/xom-1.2.10.jar)
#(cd jar-contents; "${JAR}" xf "$(TOOLS_JAR_7)" com/sun/javadoc)
rm -rf jar-contents/meta-inf jar-contents/META-INF
# Put contents in alphabetical order.
(cd jar-contents; find * -type f | ../../bin/sort-directory-order > jar-contents.txt)
# Temporarily commented out so that plume-lib can be built with Java 8;
# but I need to find a good way to double-check most builds.
(cd jar-contents; "${JAR}" cf ../plume.jar @jar-contents.txt)
rm -rf jar-contents
