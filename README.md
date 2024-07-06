# DataCenterFileDownloader
a Bash script designed for Quantum ESPRESSO users, allowing them to effortlessly download their data center output files to their local computers. The script includes customizable time monitoring and "JOB DONE" detection, enabling users to efficiently manage the transfer process.
```
$Download_pwscfJOB.sh /home/bekk14/PATH/scf/pwscf.out
```
The script will prompt for the target path and file if not provided as arguments. Upon using default values, the script will initiate the download process and continuously monitor the data center until the job is completed. A hidden file named ```".info_${Date}"``` will be created to log the process. To view the hidden file, use the shortcut "Ctrl+H".
e.g :    
```.info_${Date}
+---------------H.B----------------------+
Target path : /home/bekk14/PATH/scf
Target file : pwscf.out
Username    : bekk14
Host        : 20.20.1.1
Code test   : grep 'JOB DONE' '/home/bekk14/PATH/scf/pwscf.out' >/dev/null 2>&1;
Command     : scp @10.20.2.11:/home/bekk14/PATH/scf/pwscf.out .
Times steps : 60  
+----------------------------------------+
:: operation date  2024-03-10 18:02:51
 
:: strat 
*** 2 min _ 0h
******************************  33 min _ 0h 
_______| JOB DONE |__________________
Happy job on 20.20.1.1 is done :) 
:: time elapsed: 1983 seconds 2024-03-10 18:36:55
```
