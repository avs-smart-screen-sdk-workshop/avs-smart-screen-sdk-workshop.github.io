#!/bin/bash
#
#

#install sensory
cd /home/pi/sdk-folder/third-party
git clone git://github.com/Sensory/alexa-rpi.git

#update sensory license
cd /home/pi/sdk-folder/third-party/alexa-rpi/bin/
./license.sh

#copy config.json into place
cp -f /home/pi/Downloads/config.json /home/pi/sdk-folder/sdk-source/avs-device-sdk/tools/Install

#generate config
cd /home/pi/sdk-folder/sdk-source/avs-device-sdk/tools/Install

bash genConfig.sh config.json 123456 \
/home/pi/sdk-folder/application-necessities \
/home/pi/sdk-folder/sdk-source/avs-device-sdk \
/home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json.generated

#Create configuration file with audioSink configuration at the beginning of the file
#Needed to fix playback for Audible
cat << EOF > /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json
 {
    "gstreamerMediaPlayer":{
        "outputConversion":{
            "rate":48000,
            "format":"S16LE",
            "channels":2
        },
         "audioSink": "alsasink"
    },
EOF

#Delete first line from temp file to remove opening bracket
cp  /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json.generated /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json.tmp
sed -i -e "1d" /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json.tmp

#Append temp file to configuration file
cat /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json.tmp >> /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json

#Delete temp file
rm /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json.tmp

