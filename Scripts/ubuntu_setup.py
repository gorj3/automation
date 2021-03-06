#!/usr/bin/env python3
import subprocess
import time

print('Welcome to WSL automatic set up for Ubuntu 20 - 18 WS')
print("")
#create variables to use later, get time to start and create log file
installed = []
skipped = []
t = time.localtime()
current_time = time.strftime("%H.%M.%S", t)
logs = open("log"+str(current_time)+".txt", "w")

#upgrade packages only if upgrade is y or Y. All installations follow this logic.
upgrade = input("Upgrate all packages before installing new software? [y/n] ")

#class for each software to be installed
#name to be displayed, commands to install and if installing is true or false for logic.
class Software:
    def __init__(self, name, commands, installing):
        self.name = name
        self.commands = commands

    #if answered y or Y it will be marked to be installed and the name added to installed list
    def install_question(self):
        y = input("Do you want to install "+self.name+"? [y/n]: ")
        if y == 'y' or y == 'Y':
            installed.append(self.name)
            self.installing = True 
        else:
            self.installing = False 
            skipped.append(self.name)
    #funtion run the installation commands and add the output to the log file
    def install_commands(self):
        print("Installing "+self.name+", please wait")
        for i in self.commands:
            subprocess.call([i], shell=True, stdout=logs, stderr=logs)

#the list where the Software objects will be stored 
softwareList = []

#list of commands needs to be created before adding the object to the list
ansible_commands=['sudo apt install ansible -y']
softwareList.append(Software('Ansible', ansible_commands, False))

aws_commands=['sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"', 
    'sudo apt install unzip -y', 
    'sudo unzip awscliv2.zip',
    'sudo ./aws/install']
softwareList.append(Software('AWS CLI', aws_commands, False))

azure_commands=['curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash']
softwareList.append(Software('Azure CLI', azure_commands, False))

npm_commands=['sudo apt install npm -y']
softwareList.append(Software('Node.js and npm', npm_commands, False))

pip3_commands=['sudo apt-get -y install python3-pip', 'sudo pip3 install boto3']
softwareList.append(Software('pip3 and boto3', pip3_commands, False))

terraform_commands=['curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -', 
    'sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"', 
    'sudo apt-get update',
    'sudo apt-get install terraform -y']
softwareList.append(Software('Terraform', terraform_commands, False))

#for each program in the list, run the question function and mark them as installing
for i in softwareList:
    i.install_question()

#update repos and upgrade if marked to do so
print("Updating packages, please wait")
subprocess.call(['sudo apt update -y'], shell=True, stdout=logs, stderr=logs)
if upgrade == 'y' or upgrade == "Y":
    subprocess.call(['sudo apt upgrade -y'], shell=True, stdout=logs, stderr=logs)
else:
    print("Skipping packages upgrade")

#for each program in the list, run the install function if marked for installing
for i in softwareList:
    if i.installing == True:
        i.install_commands()
    else:
        print('Skipping '+i.name)

print('Installed Software:')
for i in installed:
    print(i)
print("")
print('Skipped Software:')
for i in skipped:
    print(i)