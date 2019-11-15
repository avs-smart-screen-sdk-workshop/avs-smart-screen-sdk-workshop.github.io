#!/bin/sh
#
# This script is run once, to set up all that is necessary on top of a base Raspbian image, and to precompile the AVS sdk
#
# For some microphones, gain should be maxed out with "alsamixer"
#
# IMPORTANT for Raspbian Stretch
# ------------------------------
# Add "audio_pwm_mode=1" in "/boot/config.txt" (after "dtparam=audio=on" line)
# Add "gpu_mem=128" in "/boot/config.txt" (after above line). Sets gpu mem to 128Mb for smoother video playback.
# In Chromium, set gpu rasterization to enabled: (#enable-gpu-rasterization = Enabled)
# 

# create directories
cd /home/pi
mkdir sdk-folder
mkdir iot

cd sdk-folder
mkdir sdk-build sdk-source sdk-install ss-build third-party application-necessities

cd application-necessities
mkdir sound-files

#update repos
sudo apt-get update

#install dependencies for avs
sudo apt-get -y install \
git gcc cmake build-essential libsqlite3-dev libcurl4-openssl-dev libfaad-dev \
libsoup2.4-dev libgcrypt20-dev libgstreamer-plugins-bad1.0-dev \
gstreamer1.0-plugins-good libasound2-dev doxygen libssl-dev libasio-dev

#update cmake to v 3.15.4
wget -c https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz -O ~/Downloads/cmake-3.15.4.tar.gz
cd /home/pi/sdk-folder/third-party
tar xzf ~/Downloads/cmake-3.15.4.tar.gz
cd cmake-3.15.4
sudo ./bootstrap
sudo make
sudo make install

#add websocket
wget https://github.com/zaphoyd/websocketpp/archive/0.8.1.tar.gz -O ~/Downloads/websocketpp-0.8.1.tar.gz
cd /home/pi/sdk-folder/third-party
tar xzf /home/pi/Downloads/websocketpp-0.8.1.tar.gz

#install dependencies for AWS IoT and Smart Screen SDK
sudo apt-get -y install nodejs npm
sudo npm install -g npm@latest
cd /home/pi/iot
wget https://avs-smart-screen-sdk-workshop.github.io/setup_files/root-ca.pem.crt
npm install aws-iot-device-sdk
npm install onoff

#portaudio
cd /home/pi/sdk-folder/third-party

wget -c http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz
tar zxf pa_stable_v190600_20161030.tgz

cd portaudio
./configure --without-jack --without-oss

make

#json comment extractor
pip install commentjson

#grab sdk
wget https://avs-smart-screen-sdk-workshop.github.io/setup_files/avs_device_sdk_115_patch_raspbian_buster.txt -O ~/Downloads/avs_device_sdk_115_patch_raspbian_buster.txt
cd /home/pi/sdk-folder/sdk-source
git clone --single-branch --branch v1.15 git://github.com/alexa/avs-device-sdk.git
cd avs-device-sdk
patch -p1 < ~/Documents/avs_device_sdk_115_patch_raspbian_buster.txt

#get Smart Screen SDK
cd /home/pi/sdk-folder
tar xzf ~/Documents/ss-sdk-source_11019_with_CR-15234467_patch_and_buster_patch.tar.gz

#get APL core
cd /home/pi/sdk-folder
git clone https://github.com/alexa/apl-core-library.git

#grab install and run scripts
cd /home/pi
wget https://avs-smart-screen-sdk-workshop.github.io/setup_files/avs_install.sh
wget https://avs-smart-screen-sdk-workshop.github.io/setup_files/avs_run.sh
chmod u+x avs_install.sh avs_run.sh
