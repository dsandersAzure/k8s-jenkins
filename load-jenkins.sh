#!/bin/bash
# -------------------------------------------------------------------
#
# Module:         k8s-jenkins
# Submodule:      load-jenkins.sh
# Environments:   all
# Purpose:        Bash shell script to apply any yaml files found in
#                 the jenkins directory. 
#
# Created on:     30 July 2019
# Created by:     David Sanders
# Creator email:  dsanderscanada@nospam-gmail.com
#
# -------------------------------------------------------------------
# Modifed On   | Modified By                 | Release Notes
# -------------------------------------------------------------------
# 30 Jul 2019  | David Sanders               | First release.
# -------------------------------------------------------------------

# Include the banner function for logging purposes (see
# templates/banner.sh)
#
source ./banner.sh

log_banner "load-jenkins.sh" "Apply NFS Provisioner"

lbip=$(cat ~/lbip.txt | grep "export LBIP" | cut -d'=' -f2)
yaml_files=$(ls -1 ./[0-9]*.yaml)
for file in $yaml_files
do
    short_banner "Applying yaml for: $file"
    sed '
            s/\${lbip}/'"$lbip"'/g;
        ' $file | kubectl apply -f -
    if [ "$?" != "0" ]; then short_banner "Error applying Jenkins!"; exit 1; fi
    echo
done

short_banner "Done."
echo