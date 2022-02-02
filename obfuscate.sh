#! /bin/bash

tmp=$(mktemp)
tmpjs=$(mktemp)
path=$(pwd)
repo_path=$1
template_files=${repo_path}/app/static/assets/js/
stop_script="./run.sh"
run_script="./run.sh"
test -d ${repo_path} || { echo "Directory ${repo_path} not found, aborting..."; exit 1; } 
test -f ofuscator.js || { echo "ofuscator.js file not found, aborting..."; exit 1; }
echo "INFO: Updating Repo...."
cd ${repo_path}
test -f ${repo_path}/${stop_script} && {
  ${repo_path}/${stop_script} -s
}
echo "-----UPDATING-REPO-----" | tee ${path}/auto_pull
git pull &>> $tmp
test $(grep -Eic "error|fatal|unable" $tmp) -gt 0 && { 
  cat $tmp | tee -a ${path}/auto_pull; 
  rm -f $tmp; 
  exit 1;}
cat $tmp | tee -a ${path}/auto_pull
cd ${path}
echo "-----OBFUSCATING-FILES-----" | tee -a ${path}/auto_pull
node ofuscator.js ${repo_path} &>> $tmpjs
test $(grep -Eic "error|fatal|unable|illegal" $tmpjs) -gt 0 && { 
  cat $tmpjs | tee -a ${path}/auto_pull; 
  rm -f $tmpjs; 
  exit 1;}
cat $tmpjs | tee -a ${path}/auto_pull
rm -f $tmp $tmpjs
cd ${repo_path}
echo "Cleaning js blueprints..." | tee -a ${path}/auto_pull
rm ${template_files}*
test -f ${run_script} && {
  ${run_script} -r 
}
echo "Website running..." | tee -a ${path}/auto_pull
