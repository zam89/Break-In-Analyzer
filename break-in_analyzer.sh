#!/bin/bash
#
# Break-In Analyzer - A script that analyze the log files /var/log/auth.log*(for Debian based systems), /var/log/secure* (for RHEL based systems), utmp/wtmp for possible SSH break-in attempts
#
# Author
# -------
# Azam <M.Khairulazam@gmail.com>
#
# Changelogs
# ----------
# 1.0  (15 Oct 2021): First version of the script.
# 1.1  (17 Oct 2021): Refined few search pattern.
# 1.2  (18 Oct 2021): Add save output/result into txt file.
#
# License
# -------
# MIT License. Copyright (c) 2021 Mohd Khairulazam. See [License](LICENSE).
# Please email us for any suggestion and feedback.

echo -e "_____________________________________
|				    |
|	Break-In Analyzer 1.2	    |
|___________________________________|
"
echo -e "Please Select:\n1) Analyze auth logs\n2) Analyze secure logs\n3) Analyze utmp/wtmp log\n4) Exit script\n\n* This script is checking for failed attempt on valid/existed account/username only! \n"
read -e -r -p "Menu selection: " userinput

if [[ ! -d output ]]
then
	mkdir -p output
fi

if [[ $userinput == 1 ]]
then
	read -e -r -p "Input auth.log location..: " logfile #insert full path - /home/user/var_logs/auth*
	{
		echo "File location:" $logfile >> output/auth_output.log
		
		resultipfail=`cat $logfile | grep "Failed password" | grep -v -e "invalid" | awk '{if($6=="Failed"&&$7=="password"){users[$9]++;ips[$11]++}}END{for(ip in ips){print ip, ips[ip]}}' | sort -k2 -rn`
		echo -e "\nPossible Break-in Attempts - IP\n$resultipfail\n"
		
		resultuserfail=`cat $logfile | grep "Failed password" | grep -v -e "invalid" | awk '{if($6=="Failed"&&$7=="password"){users[$9]++;ips[$11]++}}END{for(user in users){print user, users[user]}}' | sort -k2 -rn`
		echo -e "\nPossible Break-in Attempts - Username\n$resultuserfail\n"
		
		resultipsuccess=`awk '{if($6=="Accepted"&&$7=="password"){ips[$11]++;users[$9]++}}END{for(ip in ips){print ip, ips[ip]}}' $logfile | sort -k2 -rn`
		echo -e "\nSuccessful Logins - IP\n$resultipsuccess\n"
		
		resultusersuccess=`awk '{if($6=="Accepted"&&$7=="password"){ips[$11]++;users[$9]++}}END{for(user in users){print user, users[user]}}' $logfile | sort -k2 -rn`
		echo -e "\nSuccessful Logins - Users\n$resultusersuccess\n"
	} | tee -a output/auth_output.log
	
	echo -e "Done!\n"
elif [[ $userinput == 2 ]]
then
	read -e -r -p "Input secure.log location..: " logfile #insert full path - /home/user/var_logs/secure*
	{
		echo "File location:" $logfile >> output/secure_output.log
		
		#awk '{if($6=="Failed"&&$7=="password"){if($9=="invalid"){ips[$13]++;users[$11]++}else{users[$9]++;ips[$11]++}}}END{for(ip in ips){print ip, ips[ip]}}' $logfile | sort -k2 -rn
		
		resultipfail=`cat $logfile | grep "Failed password" | grep -v -e "invalid" | awk '{if($6=="Failed"&&$7=="password"){if($9=="invalid"){ips[$13]++;users[$11]++}else{users[$9]++;ips[$11]++}}}END{for(ip in ips){print ip, ips[ip]}}' | sort -k2 -rn`
		echo -e "\nPossible Break-in Attempts - IP\n$resultipfail\n"
		
		resultuserfail=`cat $logfile | grep "Failed password" | grep -v -e "invalid" | awk '{if($6=="Failed"&&$7=="password"){if($9=="invalid"){ips[$13]++;users[$11]++}else{users[$9]++;ips[$11]++}}}END{for(user in users){print user, users[user]}}' | sort -k2 -rn`
		echo -e "\nPossible Break-in Attempts - Username\n$resultuserfail\n"
		
		resultipsuccess=`awk '{if($6=="Accepted"&&$7=="password"){ips[$11]++;users[$9]++}}END{for(ip in ips){print ip, ips[ip]}}' $logfile | sort -k2 -rn`
		echo -e "\nSuccessful Logins - IP\n$resultipsuccess\n"
		
		resultusersuccess=`awk '{if($6=="Accepted"&&$7=="password"){ips[$11]++;users[$9]++}}END{for(user in users){print user, users[user]}}' $logfile | sort -k2 -rn`
		echo -e "\nSuccessful Logins - Users\n$resultusersuccess\n"
	} | tee -a output/secure_output.log
	
	echo -e "Done!\n"
elif [[ $userinput == 3 ]]
then
	read -e -r -p "Input utmp/wtmp location..: " logfile #/home/user/var_logs/utmp
	
	if [[ $logfile =~ "utmp" ]]
	then
		{
			echo "File location:" $logfile >> output/utmp_output.log
			
			for f in $logfile*
			do
				utmpdump $f >> output/utmpdump_output.txt
			done
			
			resultip=`awk -F"[][{}]" '{print $14}' output/utmpdump_output.txt | sort | uniq -c | sort -rn` #IP
			echo -e "\nSuccessful Logins - IP\n$resultip\n"
			
			resultuser=`awk -F"[][{}]" '{print $8}' output/utmpdump_output.txt | sort | uniq -c | sort -rn` #username
			echo -e "\nSuccessful Logins - Username\n$resultuser\n"
		} | tee -a output/utmp_output.log
	elif [[ $logfile =~ "wtmp" ]]
	then
		{
			echo "File location:" $logfile >> output/wtmp_output.log
			
			for f in $logfile*
			do
				utmpdump $f >> output/wtmpdump_output.txt
			done
			
			resultip=`awk -F"[][{}]" '{print $14}' output/wtmpdump_output.txt | sort | uniq -c | sort -rn` #IP
			echo -e "\nSuccessful Logins - IP\n$resultip\n"
			
			resultuser=`awk -F"[][{}]" '{print $8}' output/wtmpdump_output.txt | sort | uniq -c | sort -rn` #username
			echo -e "\nSuccessful Logins - Username\n$resultuser\n"
		} | tee -a output/wtmp_output.log
	else
		echo -e "\nUnrecognized file/path!\n"
	fi
	
	echo -e "Done!\n"
elif [[ $userinput == 4 ]]
then
	echo -e "Exiting...\n"
	exit 1
else
	echo -e "\nUnknown menu selection!\n"
fi
