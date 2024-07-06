#!/bin/bash
############
#   By : bekk@14
############
USER="userName"    #change to user default username 
PASSWORD="PASSWORDHERE"  #default password
HOSTNAME="20.10.3.4" 
TIME=60 #sconds
file_info=".info_"+$(date +"%d_%m_%H_%M")
# Prompt user for target path  read from args  : e.g target_path /home/userName/Path_To_File/pwscf.out   
if [ $# -eq 1 ]; then
  target_path="${1%/*}"
  target_file="${1##*/}" 
else
  read -p "Enter target path where the file exists: " target_path
  read -p "Enter the file in the target path to download: " target_file
fi

user_name=${USER:-default_user}
host=${HOSTNAME:-default_host}
code_test="grep 'JOB DONE' '$target_path/$target_file' >/dev/null 2>&1;"
time_step=${TIME:-default_time}
PASSWORD=${PASSWORD:-default_password}
echo "------------------------------------------------"
echo "Target path : $target_path"
echo "Target file : $target_file"
echo "Username    : $user_name"
echo "Host        : $host"
echo "Code test   : $code_test"
echo "-----------------------------------------------"

read -p "Use default values? (Y/n) " use_default

if [[ $use_default =~ ^[Yy]$ ]]; then
  echo "Using default values."
else
  read -p "Enter username: " user_name
  read -p "Entre password: " PASSWORD
  read -p "Enter host: " host
  read -p "Entre time steps in scond : " time_step
  read -p "Enter code test (default: preferable): " code_test
  code_test=${code_test:-preferable}


echo " new configuration : "
echo "Target path: $target_path"
echo "Username: $user_name"
echo "Host: $host"
echo "Code test: $code_test"
echo " Times steps : " $time_step
fi

echo " setting .. saved here .info"
echo "+---------------H.B----------------------+"> $file_info
echo "Target path : $target_path" >> $file_info
echo "Target file : $target_file" >> $file_info
echo "Username    : $user_name" >> $file_info
echo "Host        : $host" >> $file_info
echo "Code test   : $code_test" >> $file_info 
echo "Command     : scp $usr_name@$host:$target_path/$target_file ." >> $file_info
echo "Times steps : $time_step  " >> $file_info 
date=$(date +"%Y-%m-%d %H:%M:%S")
echo "+----------------------------------------+" >> $file_info
echo ":: operation date  $date" >>  $file_info
echo " "  >> $file_info 
echo ":: strat ">> $file_info
echo "Downloading file..."
desrt_time=120

target_path="$target_path/$target_file"
start_time=$(date +%s)

while ! sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$user_name@$host" "grep 'JOB DONE' \"$target_path\"" >/dev/null 2>&1; do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  echo "$host is not done yet. $((elapsed_time/60)) min $((elapsed_time/3600)) h"
  echo -n "*" >> "$file_info"
  if [ $elapsed_time -ge $desrt_time ]; then
    echo -n " $((elapsed_time/60)) min _ $((elapsed_time/3600))h" >> "$file_info"
    echo "" >> "$file_info"
    desrt_time=$((elapsed_time + 3600))
  fi
# optimization Case usnig bfgs algo 
  sshpass -p "$PASSWORD" scp "$user_name@$host:$target_path" ./
  grep_line=$(grep "number of bfgs steps    =" "$target_file" | tail -1)
  bfgs_steps=$(echo "$grep_line" | awk '{print $NF}')
  if [[ $bfgs_steps -ne 0 && $bfgs_steps != $prev_value ]]; then
    echo "::> bfgs cicle achive : $bfgs_steps" >> "$file_info"
    prev_value=$bfgs_steps
fi
  
  sleep ${time_step}
done

echo "_______| JOB DONE |__________________" 
echo " " >> "$file_info"
echo "_______| JOB DONE |__________________" >> "$file_info"
echo "Happy job on $host is done :) " >> "$file_info"
date_end=$(date +"%Y-%m-%d %H:%M:%S")
echo ":: time elapsed: $elapsed_time seconds $date_end" >> "$file_info"
exit

