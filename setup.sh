#!/bin/bash

if [ $# -eq 0 ]
then
  echo  'bash setup.sh <config-file>'
  echo  'the config file must contain the following:'
  echo  '   CLIENT_ID=<OAuth client ID>'
  echo  '   CLIENT_SECRET=<OAuth client secret>'  
  echo  '   PRODUCT_NAME=<your product name for device>'
  echo  '   DEVICE_SERIAL_NUMBER=<your device serial number>'
fi

source $1

set -e

if [[ ! "$CLIENT_ID" =~ amzn1\.application-oa2-client\.[0-9a-z]{32} ]]
then
   echo 'client ID is invalid!'
   exit 1
fi

if [[ ! "$CLIENT_SECRET" =~ [0-9a-f]{64} ]]
then 
   echo 'client secret is invalid!'
   exit 1
fi

if [[ ! "$PRODUCT_ID" =~ [0-9a-zA-Z_]+ ]]
then 
   echo 'product ID is invalid!'
   exit 1
fi

if [[ ! "$DEVICE_SERIAL_NUMBER" =~ [0-9a-zA-Z_]+ ]]
then 
   echo 'product ID is invalid!'
   exit 1
fi

LOCALE=${LOCALE:-'en-US'}

PORT_AUDIO_DOWNLOAD_URL='http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz'
PORT_AUDIO_VERSION="pa_stable_v190600_20161030.tgz"

TIMER_SOUND_URL="https://images-na.ssl-images-amazon.com/images/G/01/mobile-apps/dex/alexa/alexa-voice-service/docs/audio/states/med_system_alerts_melodic_02._TTH_.mp3"
TIMER_SHORT_SOUND_URL="https://images-na.ssl-images-amazon.com/images/G/01/mobile-apps/dex/alexa/alexa-voice-service/docs/audio/states/med_system_alerts_melodic_02_short._TTH_.wav"
ALARM_SOUND_URL="https://images-na.ssl-images-amazon.com/images/G/01/mobile-apps/dex/alexa/alexa-voice-service/docs/audio/states/med_system_alerts_melodic_01._TTH_.mp3"
ALARM_SOUND__SHORT_URL="https://images-na.ssl-images-amazon.com/images/G/01/mobile-apps/dex/alexa/alexa-voice-service/docs/audio/states/med_system_alerts_melodic_01_short._TTH_.wav"
TEST_MODEL_DOWNLOAD="https://github.com/Sensory/alexa-rpi/blob/master/models/spot-alexa-rpi-31000.snsr"

BUILD_TESTS=${BUILD_TESTS:-'true'}

CURRENT_DIR="$(pwd)"
INSTALL_BASE=${INSTALL_BASE:-"$CURRENT_DIR"}
SOURCE_FOLDER=${SDK_LOC:-''}
THIRD_PARTY_FOLDER=${THIRD_PARTY_LOC:-'third-party'}
BUILD_FOLDER=${BUILD_FOLDER:-'build'}
SOUNDS_FOLDER=${SOUNDS_FOLDER:-'sounds'}
DB_FOLDER=${DB_FOLDER:-'db'}

SOURCE_PATH="$INSTALL_BASE/$SOURCE_FOLDER"
THIRD_PARTY_PATH="$INSTALL_BASE/$THIRD_PARTY_FOLDER"
BUILD_PATH="$INSTALL_BASE/$BUILD_FOLDER"
SOUNDS_PATH="$INSTALL_BASE/$SOUNDS_FOLDER"
DB_PATH="$INSTALL_BASE/$DB_FOLDER"
UNIT_TEST_MODEL_PATH="$INSTALL_BASE/avs-device-sdk/KWD/inputs/SensoryModels"

TIMER_SHORT_FILE="$SOUNDS_PATH/timer_short.wav"
TIMER_FILE="$SOUNDS_PATH/timer.wav"
ALARM_SHORT_FILE="$SOUNDS_PATH/alarm_short.wav"
ALARM_FILE="$SOUNDS_PATH/alarm.wav"

CONFIG_FILE="$BUILD_PATH/Integration/AlexaClientSDKConfig.json"
SOUND_CONFIG="$HOME/.asoundrc"
START_SCRIPT="$INSTALL_BASE/startsample.sh"
START_AUTH_SCRIPT="$INSTALL_BASE/startauth.sh"
TEST_SCRIPT="$INSTALL_BASE/test.sh"

if [ ! -d "$BUILD_PATH" ]
then

    # Make sure required packages are installed
    echo "==============> INSTALLING REQUIRED TOOLS AND PACKAGE ============"
    echo

    sudo apt-get update
    sudo apt-get -y install git gcc cmake build-essential libsqlite3-dev libcurl4-openssl-dev libfaad-dev libsoup2.4-dev libgcrypt20-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-good libasound2-dev sox gedit vim

    # create / paths
    echo
    echo "==============> CREATING PATHS AND GETTING SOUND FILES ============"
    echo

    mkdir -p $SOURCE_PATH
    mkdir -p $THIRD_PARTY_PATH
    mkdir -p $BUILD_PATH
    mkdir -p $SOUNDS_PATH
    mkdir -p $DB_PATH

    #get sounds file
    wget -c $TIMER_SOUND_URL -O $TIMER_FILE
    wget -c $TIMER_SHORT_SOUND_URL -O $TIMER_SHORT_FILE
    wget -c $ALARM_SOUND__SHORT_URL -O $ALARM_SHORT_FILE
    wget -c $ALARM_SOUND_URL -O $ALARM_FILE

    # build port audio
    echo
    echo "==============> BUILDING PORT AUDIO =============="
    echo

    cd $THIRD_PARTY_PATH
    wget -c $PORT_AUDIO_DOWNLOAD_URL
    tar zxf $PORT_AUDIO_VERSION

    cd portaudio
    ./configure --without-jack
    make

    #get sdk 
    echo
    echo "==============> CLONING SDK =============="
    echo

    cd $SOURCE_PATH
    git clone git://github.com/alexa/avs-device-sdk.git

    #get sensory and build
    echo
    echo "==============> CLONING AND BUILDING SENSORY =============="
    echo

    cd $THIRD_PARTY_PATH
    git clone git://github.com/Sensory/alexa-rpi.git
    bash ./alexa-rpi/bin/license.sh

    # make the SDK
    echo
    echo "==============> BUILDING SDK =============="
    echo

    cd $BUILD_PATH
    cmake "$SOURCE_PATH/avs-device-sdk" \
    -DSENSORY_KEY_WORD_DETECTOR=ON \
    -DSENSORY_KEY_WORD_DETECTOR_LIB_PATH="$THIRD_PARTY_PATH/alexa-rpi/lib/libsnsr.a" \
    -DSENSORY_KEY_WORD_DETECTOR_INCLUDE_DIR="$THIRD_PARTY_PATH/alexa-rpi/include" \
    -DGSTREAMER_MEDIA_PLAYER=ON -DPORTAUDIO=ON \
    -DPORTAUDIO_LIB_PATH="$THIRD_PARTY_PATH/portaudio/lib/.libs/libportaudio.a" \
    -DPORTAUDIO_INCLUDE_DIR="$THIRD_PARTY_PATH/portaudio/include" \
    -DACSDK_EMIT_SENSITIVE_LOGS=ON \
    -DCMAKE_BUILD_TYPE=DEBUG

    cd $BUILD_PATH
    make SampleApp -j2

else
    cd $BUILD_PATH
    make SampleApp -j2
fi

echo
echo "==============> SAVING CONFIGURATION FILE =============="
echo

cat << EOF > "$CONFIG_FILE"
{
    "alertsCapabilityAgent":{
        "alarmSoundFilePath":"$ALARM_FILE",
        "alarmShortSoundFilePath":"$ALARM_SHORT_FILE",
        "databaseFilePath":"$DB_PATH/alerts.db",
        "timerSoundFilePath":"$TIMER_FILE",
        "timerShortSoundFilePath":"$TIMER_SHORT_FILE"
    },
    "certifiedSender":{
        "databaseFilePath":"$DB_PATH/certifiedSender.db"
    },
    "settings":{
        "databaseFilePath":"$DB_PATH/settings.db",
        "defaultAVSClientSettings":{
            "locale":"$LOCALE"
        }
    },
    "authDelegate":{
      "clientId":"$CLIENT_ID",
        "clientSecret":"$CLIENT_SECRET",
        "deviceSerialNumber":"$DEVICE_SERIAL_NUMBER",
        "refreshToken":"",
        "productId":"$PRODUCT_ID"
    }
}
EOF

echo
echo "==============> FINAL CONFIGURATION  =============="
echo
cat $CONFIG_FILE

echo
echo "==============> SAVING AUDIO CONFIGURATION FILE =============="
echo

cat << EOF > "$SOUND_CONFIG"
pcm.!default {
  type asym
   playback.pcm {
     type plug
     slave.pcm "hw:0,0"
   }
   capture.pcm {
     type plug
     slave.pcm "hw:1,0"
   }
}
EOF

cat << EOF > "$START_SCRIPT"
cd "$BUILD_PATH/SampleApp/src"

TZ=UTC ./SampleApp "$CONFIG_FILE" "$THIRD_PARTY_PATH/alexa-rpi/models" DEBUG9
EOF

cat << EOF > "$START_AUTH_SCRIPT"
cd "$BUILD_PATH"
python AuthServer/AuthServer.py
EOF

cat << EOF > "$TEST_SCRIPT" 
echo
echo "==============> BUILDING Tests =============="
echo
mkdir -p "$UNIT_TEST_MODEL_PATH"
wget -O "$UNIT_TEST_MODEL_PATH/spot-alexa-rpi-31000.snsr" "$TEST_MODEL_DOWNLOAD"
cd $BUILD_PATH
make all test -j2
chmod +x "$START_SCRIPT"
chmod +x "$START_AUTH_SCRIPT"
EOF

echo " **** Completed Configuration/Build ***"

