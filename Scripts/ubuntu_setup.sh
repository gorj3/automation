#!/usr/bin/env bash

#declare lists to print what was installed and what wasn't
declare -a $INSTALLED >& sample.s
declare -a $SKIPPED >& sample.s
rm sample.s

echo "Welcome to WSL automatic set up for Ubuntu 20 - 18 WSL"

#if the input is y or Y, it will install the packages, else nothing happens
echo "Upgrate all packages before installing new software? [y/n]"
read UPGRADE
echo 'Do you want to install Ansible? [y/n]'
read ANSIBLE
echo 'Do you want to install AWS CLI? [y/n]'
read AWSCLI
echo 'Do you want to install Azure CLI? [y/n]'
read AZURE
echo 'Do you want to install Azure CLI? [y/n]'
read AZURE
echo 'Do you want to install Node.js and NPM? [y/n]'
read NPM
echo 'Do you want to install pip3 and boto3? [y/n]'
read PIP3
echo 'Do you want to install Terraform? [y/n]'
read TERRAFORM

#update packages before installing
sudo apt update

#here starts the logic based in the questions
if [ $UPGRADE == 'y' ] || [ $UPGRADE == 'Y' ]
then
    sudo apt upgrade -y
fi

if [ $ANSIBLE == 'y' ] || [ $ANSIBLE == 'Y' ]
then
    sudo apt install ansible -y
    INSTALLED+=('Ansible')
else
    echo 'Skipping Ansible'
    SKIPPED+=('Ansible')
fi

if [ $AWSCLI == 'y' ] || [ $AWSCLI == 'Y' ]
then
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt install unzip -y
    sudo unzip awscliv2.zip
    sudo ./aws/install
    INSTALLED+=('AWS CLI')
else
    echo 'Skipping AWS CLI'
    SKIPPED+=('AWS CLI')
fi

if [ $AZURE == 'y' ] || [ $AZURE == 'Y' ]
then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    INSTALLED+=('Azure CLI')
else
    echo 'Skipping Azure CLI'
    SKIPPED+=('Azure CLI')
fi

if [ $PIP3 == 'y' ] || [ $PIP3 == 'Y' ]
then
    sudo apt-get -y install python3-pip
    sudo pip3 install boto3
    INSTALLED+=('pip3 and boto3')
else
    echo 'Skipping pipi3 and boto3'
    SKIPPED+=('pip3 and boto3')
fi

if [ $NPM == 'y' ] || [ $NPM == 'Y' ]
then
    sudo apt install npm -y
    INSTALLED+=('Node.js and NPM')
else
    echo 'Skipping Ansible'
    SKIPPED+=('Node.js and NPM')
fi

if [ $TERRAFORM == 'y' ] || [ $TERRAFORM == 'Y' ]
then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update 
    sudo apt-get install terraform -y
    INSTALLED+=('Terraform')
else
    echo 'Skipping Terraform'
    SKIPPED+=('Terraform')
fi

#prints the result of the installation
echo ""
echo "Installation finished."
echo 'Installed: '
for each in "${INSTALLED[@]}"
do
  echo "$each"
done

echo ""
echo 'Skipped: '
for each in "${SKIPPED[@]}"
do
  echo "$each"
done

echo ""
echo "Docker installed and running in the Windows 10 host: "
docker version --format '{{.Server.Version}}'