#!/usr/bin/env python3
import boto3
from botocore.exceptions import ClientError
import subprocess
import base64
from Crypto.Cipher import PKCS1_v1_5
from Crypto.PublicKey import RSA
import time


#create a new Key
ec2 = boto3.resource('ec2')
try:
    outfile = open('windows.pem','w')
    key_pair = ec2.create_key_pair(KeyName='windows')
    KeyPairOut = str(key_pair.key_material)
    outfile.write(KeyPairOut)
    subprocess.call(['chmod 400 windows.pem'], shell=True)
    print('Created Windows key')
except:
    print("Windows key is already created")


#create security group
ec2 = boto3.client('ec2')
response = ec2.describe_vpcs()
vpc_id = response.get('Vpcs', [{}])[0].get('VpcId', '')
try:
    response = ec2.create_security_group(GroupName='windows-rdp',
                                         Description='RDP port open',
                                         VpcId=vpc_id)
    security_group_id = response['GroupId']
    
    data = ec2.authorize_security_group_ingress(
        GroupId=security_group_id,
        IpPermissions=[
            {'IpProtocol': 'tcp',
             'FromPort': 3389,
             'ToPort': 3389,
             'IpRanges': [{'CidrIp': '0.0.0.0/0'}]}
        ])
    print('Created Security Group %s in vpc %s.' % (security_group_id, vpc_id))
except:
    print('Security group windows-rdp already created')


# create a new EC2 instance
ec2 = boto3.resource('ec2')
print('Creating EC2 instance')
instances = ec2.create_instances(
    ImageId='ami-00843a337042b9b8b',
    MinCount=1,
    MaxCount=1,
    InstanceType='t2.micro',
    KeyName='windows',
    SecurityGroupIds=['windows-rdp'])
instance = instances[0]

# Wait for the instance to enter the running state
instance.wait_until_running()

# Reload the instance attributes
instance.load()
print('')
print('Wait until the administrator password is created')


# define the countdown func. 
def countdown(t): 
    while t: 
        mins, secs = divmod(t, 60) 
        timer = '{:02d}:{:02d}'.format(mins, secs) 
        print(timer, end="\r") 
        time.sleep(1) 
        t -= 1
#start the countdown
countdown(360)

#function to decrypt password from https://stackoverflow.com/questions/62305567/using-boto3-to-get-windows-password
def decrypt(key_text, password_data):
    key = RSA.importKey(key_text)
    cipher = PKCS1_v1_5.new(key)
    return cipher.decrypt(base64.b64decode(password_data), None).decode('utf8')

private_key_file = './windows.pem'
region = 'us-east-2'
instance_id = instance.instance_id

#read the saved key
with open(private_key_file, 'r') as key_file:
    key_text = key_file.read()

#get encrypted password
ec2_client = boto3.client('ec2', region)
response = ec2_client.get_password_data(InstanceId=instance_id)

print("")
print("Finished!")
#print DNS address
print('DNS: ' + instance.public_dns_name)
#Print username and password
print('User: Administrator') 
print("Password: " + decrypt(key_text, response['PasswordData']))