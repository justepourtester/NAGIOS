#!/bin/bash
### Script to install nagios server in Linux Servers. ####
### Auther :- Ravi Kumar Jangid
### Email :-  ravi.jangir25@gmail.com

########################################################
#### Installation Starts ######
########################################################

txtrst=$(tput sgr0) # Text reset
txtred=$(tput setaf 1) # Red
txtgrn=$(tput setaf 2) # Green
txtylw=$(tput setaf 3) # Yellowlibldap-2.4-2
txtblu=$(tput setaf 4) # Blue
txtpur=$(tput setaf 5) # Purple
txtcyn=$(tput setaf 6) # Cyan
txtwht=$(tput setaf 7) # White
txtbld=$(tput bold) # bold

welcome_msg()
{
	echo -e "\n\t\033[44;37;5m###################################\033[0m"
	echo -e "\t\033[44;37;5m#            Welcome to           #\033[0m"
	echo -e "\t\033[44;37;5m#  Network Monitoring Tool Setup  #\033[0m"
}

chk_user()
{
	if [ $(whoami) != "root" ]
	then
		echo -e "\n\t\033[44;37;5m###### WARNING ######\033[0m"
		echo -e "\t${txtylw}${txtbld}Sorry ${txtgrn}$(whoami)${txtrst}${txtylw}${txtbld}, you must login as root user to run this script.${txtrst}" 
		echo -e "\t${txtylw}${txtbld}Please become root user using 'sudo -s' and try again.${txtrst}"
		echo -e
		echo -e "\t${txtred}${txtbld}Quitting Installer.....${txtrst}\n"
		sleep 3
	exit 1
	fi
}

### Ubuntu/Debian type servers. ####
chk_user
OSREQUIREMENT=`cat /etc/issue | awk '{print $1}' | sed 's/Kernel//g'`
if ([ "$OSREQUIREMENT" = "Ubuntu" ] || [ "$OSREQUIREMENT" = "Debian" ])
then
welcome_msg
				apt-get update
				apt-get upgrade -y
				apt-get -y --force-yes install apache2 build-essential wget perl openssl 
				apt-get -y --force-yes install nagios-plugins nagios3 nagios-plugins-basic nagios-plugins-extra nagios-snmp-plugins nagios-nrpe-plugin nagios3-core nagios-plugins-standard nagios3-cgi nagios-plugins-contrib
				apt-get -y --force-yes install libssl-dev openssh-server openssh-client ntpdate snmp smbclient libldap-2.4-2 libldap2-dev  unzip
				sleep 2

				sed -i 's/check_external_commands=0/check_external_commands=1/g' /etc/nagios3/nagios.cfg
				
				/usr/sbin/usermod -a -G www-data nagios
				chmod -R g+wx /var/lib/nagios3/
				
				/etc/init.d/nagios3 restart	
				
				/etc/init.d/apache2 restart
				sleep 2
				IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
				echo -e "\n\tNow Nagios is ready to be used via: http://$IP/nagios3"
				echo -e '\n\n\033[31m\tInstallation of Nagios Core and the Nagios-Plugins have been finished!\n\tThanks for using this Script!\n\n\t\033[32mLeave your feedback at ravi@r3infotech.com\033[m'
				exit 0
				
else
	chk_user
	welcome_msg
		yum update -y
		yum install wget vim -y
		rpm -ivh http://dl.fedoraproject.org/pub/epel/6Server/x86_64/epel-release-6-8.noarch.rpm
		yum check-update
		yum install httpd openssl* -y
		yum install bash-com* nagios nagios-plugins nagios-plugins-all nagios-plugins-nrpe -y
		echo -e "\n\n\t${txtylw}${txtbld}Please Enter the password for nagiosadmin user.${txtrst}"
		htpasswd -c /etc/nagios/passwd nagiosadmin
		sleep 1
		service nagios restart
		service httpd restart
		chkconfig nagios on
		chkconfig httpd on
		IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
		echo -e "\n\tNow Nagios is ready to be used via: http://$IP/nagios"
		echo -e '\n\n\033[31m\tInstallation of Nagios Core and the Nagios-Plugins have been finished!\n\tThanks for using this Script!\n\n\t\033[32mLeave your feedback at ravi@r3infotech.com\033[m'
		exit 0
fi


		
