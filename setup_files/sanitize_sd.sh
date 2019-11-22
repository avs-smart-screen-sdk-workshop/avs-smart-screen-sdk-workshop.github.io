#!/bin/sh
#
# To be executed as root
#
# Also clear chromimum browser cache
cd /var/log
rm -f *.log.* syslog.* messages.* debug.*
cat /dev/null > messages
cat /dev/null > syslog
cat /dev/null > debug
cat /dev/null > dpkg.log
cat /dev/null > kern.log
cat /dev/null > user.log
cat /dev/null > daemon.log
cat /dev/null > auth.log
cat /dev/null > lastlog

cat /dev/null > /home/pi/.bash_history
cat /dev/null > /root/.bash_history

rm -f /home/pi/.xsession-errors.old
rm -rf /home/pi/.ssh
rm -f /home/pi/.lesshst
rm -f /home/pi/.wget-hsts


#alexa-specific
rm -f /home/pi/sdk-folder/sdk-source/avs-device-sdk/tools/Install/config.json
rm -f /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json*
rm -f /home/pi/sdk-folder/application-necessities/*.db
rm -f /home/pi/Downloads/config.json
rm -rf /home/pi/sdk-folder/third-party/alexa-rpi
