#!/bin/bash

security() {
  tfsec --no-color .
}

tfsec_exclusion_file=".tfsec-exclude"

for dir in $(ls);do
  if [[ -d $dir ]];then
    echo "=========== PROCESSING COMPONENT: ${dir} ==========="
    cd $dir
    if [[ -f "./main.tf" ]];then
      if [[ ! -f $tfsec_exclusion_file ]];then
        echo "=========== DOWNLOADING MODULES: ${dir} ==========="
        terraform get
        echo "=========== STARTING TERRAFORM SECURITY SCAN: ${dir} ==========="
        echo "Starting scan"
        tfsec .
      else
        printf "TFSec exculusion exists. Skipping.\nReason: $(cat $tfsec_exclusion_file)\n"
      fi
    else
      printf "No terraform in this directory, skipping\n"
    fi
    cd ..
  fi
done
