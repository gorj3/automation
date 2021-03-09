# open PS with admin rights and run the file with this command: powershell -ExecutionPolicy Bypass -File windows10_setup.ps1

Write-Host @"
Welcome to Windows 10 dev workstation set up.
This installation has two parts:
1. Download installation files, make WSL configurations and restart the PC
2. Install some files and finish configuration
Please select the part that you need.
"@

$NeedPart = Read-Host -Prompt '[1/2]: '

#function to do the initial setup of WSL and download software with Chrome
function Invoke-Part-One {
    Write-Host "Download WSL2 Kernel, Docker, GitHub Desktop, Git and Visual Studio Code?"
    $DownloadTools = Read-Host -Prompt 'The download links will be open in Chrome for faster speed [y/n]'

    if ( $DownloadTools -eq 'y' -or $age -eq 'Y' )
    {
        Start-Process "chrome.exe" "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
        Start-Process "chrome.exe" "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
        Start-Process "chrome.exe" "https://central.github.com/deployments/desktop/desktop/latest/win32"
        Start-Process "chrome.exe" "https://git-scm.com/download/win"
        Start-Process "chrome.exe" "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        Write-Host "The configuration has been completed. The PC needs to restart before installing the WSL2 update."
        Write-Host "Do you want to restart now? Some files might still be downloading"
        $RestartPC = Read-Host -Prompt '[y/n]'
        if ( $RestartPC -eq 'y' -or $age -eq 'Y' )
        {
            Restart-Computer -Force
        }
    }
}

#second funtion to finish WSL setup
function Invoke-Part-Two {
    Write-Host "Installing WSL2 update"
    Start-Process "$home\Downloads\wsl_update_x64.msi" /passive
    wsl --set-default-version 2

    #configure Ansible
    $url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
    $file = "C:\Users\Jorge\Downloads\Upgrade-PowerShell.ps1"
    (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
    &$file -Version 5.1

    $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
    $file = "$env:temp\ConfigureRemotingForAnsible.ps1"

    (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
    powershell.exe -ExecutionPolicy ByPass -File $file

    $Password = Read-Host -Prompt 'Write password for Ansible account: ' -AsSecureString 
    New-LocalUser "ansible" -Password $Password -FullName "Ansible Admin" -Description "Ansible administratoin account"
    Add-LocalGroupMember -Group "Administrators" -Member "ansible"
}

#logic to see which part of the script is needed
if ( $NeedPart -eq '1' )
    {
        Invoke-Part-One
    }
elseif( $NeedPart -eq '2' )
    {
        Invoke-Part-Two
    }