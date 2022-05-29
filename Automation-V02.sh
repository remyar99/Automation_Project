root@ip-172-31-21-201:~/Automation_Project# vi automation.sh
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
aws s3 cp /tmp/${my_name}-httpd-logs-${timestamp}.tar  s3://${my_bucket}/${my_name}-httpd-logs-${timestamp}.tar
cd /tmp/
log_type="httpd-logs"
type="tar"


filesize=$(ls -lh "${my_name}-httpd-logs-${timestamp}.tar" | awk '{print  $5}')
log_type="httpd-logs"
type="tar"

echo "Adding meta data to the webpage"
cd /var/www/html/
if [ -e /var/www/html/inventory.html ]
then

 echo "${log_type}              ${timestamp}            ${type}         ${filesize}" >> inventory.html

else
        touch inventory.html

        echo  "Log Type         Date Created            Type            Size " >> inventory.html
        echo "${log_type}              ${timestamp}            ${type}         ${filesize}" >> inventory.html

fi
echo "SCHEDULING THE JOB"
cd /etc/cron.d/
if [ -e automation ]
then
echo " Job has been scheduled "
else
touch automation
echo " @daily root /root/Automation_Project/automation.sh " >> /etc/cron.d/automation
echo " Job has been scheduled "
fi
