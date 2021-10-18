Break-In Analyzer
===

A script that analyze the log files `/var/log/auth.log*`, `/var/log/secure*`, `utmp/wtmp` for illegal break-in attempts and writes all output to text file.

Features
===
- Analyze logs from: 
  - /var/log/auth.log*
  - /var/log/secure*
  - /var/log/wtmp
  - /var/run/utmp
- Script tested on Ubuntu 20.04.

How to Run
===
 - Copy <b>break-in_analyzer</b> your host machine
 - Give execution permission by running `chmod +x breakins_analyzer.sh`
 - Then run the script as below:
```
  $ ./breakins_analyzer.sh
```
- Specify with logs to be analyzed e.g. auth, secure, utmp or wtmp
- Specify <b>FULL</b> path of the logs location together with wildcard symbol (if you analyzing more than 1 logs) e.g. `/home/user/var_logs/auth*`
- Wait until it finished analyzing the logs
- The result with be shown on the terminal & written into `output` folder together with file named:
  - auth_output.log
  - secure_output.log
  - utmp_output.log
  - wtmp_output.log

Screenshot
===
![Menu](/screenshot/break-in1.png)
![Auth.log analysis](/screenshot/break-in2.png)
![Secure log analysis](/screenshot/break-in3.png)
![wtmp analysis](/screenshot/break-in4.png)

Changelogs
===
- 1.0  (15 Oct 2021): First version of the script.
- 1.1  (17 Oct 2021): Refined few search pattern.
- 1.2  (18 Oct 2021): Add save output/result into txt file.

To-Do-List (In Future)
===
- [ ] Adding more file to be analyzed

License
===
MIT License. Copyright (c) 2021 Mohd Khairulazam. See [License](LICENSE).
