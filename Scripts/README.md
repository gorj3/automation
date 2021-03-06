# scripts
Scripts in Bash, Python and PowerShell.
Download the scripts and make them executable
```
chmod +x create_windows_instance.py
```
**create_windos_instance.py**
* Creates an AWS EC2 Windows instance
* Waits 5 minutes to decrypt the password
* Returns DNS address, Admin and password

**ubuntu_setup.py**
* Updates and upgrades packages
* Install selected software
* Logs output to a log file

**ubuntu_setup.sh**
* Accomplishes the same than ubuntu_setup.py but in Bash
* Doesn't log to a file, but displays output to terminal

**windows10_setup.ps1**
- Two parts PowerShell script
  - First part downloads software, sets up WSL and ask to restart the PC
  - Second part updates the WSL kernel and finishes configuration
