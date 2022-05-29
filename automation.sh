#-----------------------------------------------------#
#Automation Script for Installing and running apache2 #
#Script_name: automation.sh                           #
#Author:Remya R                                       #
#Version : 1                                          #
#-----------------------------------------------------#
#---------------Declaring Variable--------------------#
timestamp=$(date '+%d%m%Y-%H%M%S')
my_bucket=upgrad-remya
my_name=remya
echo "----------------------------------------- UPDATING THE PACKAGES --------------------------------"
apt update -y
echo "---------------------------------------- CHECKING IF THE PACKAGE IS INSTALLED-------------------"
dpkg -l | grep "apache2"
echo "----------------------------------------INSTALLING APACHE2--------------------------------------"
apt-get -qq -y  install apache2
echo "----------------------------------------ENSURING APACHE2 IS RUNNING-----------------------------"
service apache2 status
echo "----------------------------------------ENABLING APACHE SERVICE---------------------------------"
systemctl enable apache2
echo "----------------------------------------CREATING THE TAR FILE FROM THE LOGS---------------------"
tar -czvf /tmp/${my_name}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
echo "----------------------------------------COPYING TO S3 BUCKET------------------------------------"
aws s3 cp /tmp/${my_name}-httpd-logs-${timestamp}.tar  s3://${my_bucket}/${log_name}-${timestamp}.tar
