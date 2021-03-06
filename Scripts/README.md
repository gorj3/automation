# scripts
Scripts in Bash, Python and PowerShell.

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

### Instructions
Python and Bash scripts need to be executables
```
chmod +x create_windows_instance.py
```
PowerShell scripts need to be run like this
```
powershell -ExecutionPolicy Bypass -File windows10_setup.ps1
```
