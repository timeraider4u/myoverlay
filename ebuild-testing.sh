#!/bin/bash
# ...
# 
whoami
groups
ls -la /var/tmp
ls -la /var/tmp/portage
for FILE in $(find -name "*.ebuild"); do 
  python ../portage-${PORTAGE_VER}/bin/ebuild $FILE install;
done
