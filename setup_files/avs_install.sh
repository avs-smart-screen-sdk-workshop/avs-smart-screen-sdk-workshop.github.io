#!/bin/bash
#
#

#install sensory
cd /home/pi/sdk-folder/third-party
git clone git://github.com/Sensory/alexa-rpi.git

#update sensory license
cd /home/pi/sdk-folder/third-party/alexa-rpi/bin/
./license.sh

#compile APLCoreEngine
cd /home/pi/sdk-folder/APLCoreEngine
mkdir build
cd build
cmake ..
make

#compile sdk
cd /home/pi/sdk-folder/sdk-build
cmake /home/pi/sdk-folder/sdk-source/avs-device-sdk \
-DCMAKE_BUILD_TYPE=DEBUG \
-DSENSORY_KEY_WORD_DETECTOR=ON \
-DSENSORY_KEY_WORD_DETECTOR_LIB_PATH=/home/pi/sdk-folder/third-party/alexa-rpi/lib/libsnsr.a \
-DSENSORY_KEY_WORD_DETECTOR_INCLUDE_DIR=/home/pi/sdk-folder/third-party/alexa-rpi/include \
-DGSTREAMER_MEDIA_PLAYER=ON \
-DPORTAUDIO=ON \
-DPORTAUDIO_LIB_PATH=/home/pi/sdk-folder/third-party/portaudio/lib/.libs/libportaudio.a \
-DPORTAUDIO_INCLUDE_DIR=/home/pi/sdk-folder/third-party/portaudio/include \
-DCMAKE_INSTALL_PREFIX=/home/pi/sdk-folder/sdk-install
make install -j2

#build medici
cd /home/pi/sdk-folder/ss-build
cmake -DCMAKE_PREFIX_PATH=$HOME/sdk-folder/sdk-install \
-DWEBSOCKETPP_INCLUDE_DIR=$HOME/sdk-folder/third-party/websocketpp-0.8.1 \
-DDISABLE_WEBSOCKET_SSL=ON \
-DSENSORY_KEY_WORD_DETECTOR=ON \
-DSENSORY_KEY_WORD_DETECTOR_LIB_PATH=/home/pi/sdk-folder/third-party/alexa-rpi/lib/libsnsr.a \
-DSENSORY_KEY_WORD_DETECTOR_INCLUDE_DIR=/home/pi/sdk-folder/third-party/alexa-rpi/include \
-DGSTREAMER_MEDIA_PLAYER=ON \
-DCMAKE_BUILD_TYPE=DEBUG \
-DPORTAUDIO=ON -DPORTAUDIO_LIB_PATH=$HOME/sdk-folder/third-party/portaudio/lib/.libs/libportaudio.a \
-DPORTAUDIO_INCLUDE_DIR=$HOME/sdk-folder/third-party/portaudio/include/ \
-DAPL_CORE=ON \
-DAPLCORE_INCLUDE_DIR=$HOME/sdk-folder/APLCoreEngine/aplcore/include \
-DAPLCORE_LIB_DIR=$HOME/sdk-folder/APLCoreEngine/build/aplcore \
-DYOGA_INCLUDE_DIR=$HOME/sdk-folder/APLCoreEngine/build/yoga-prefix/src/yoga \
-DYOGA_LIB_DIR=$HOME/sdk-folder/APLCoreEngine/build/lib \
 ../Alexa-smart-screen-sdk-for-linux
make -j2

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

