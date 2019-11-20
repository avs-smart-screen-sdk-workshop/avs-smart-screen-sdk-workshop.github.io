#!/bin/bash
#
#
#compile smart screen sdk
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
-DAPLCORE_INCLUDE_DIR=$HOME/sdk-folder/apl-core-library/aplcore/include \
-DAPLCORE_LIB_DIR=$HOME/sdk-folder/apl-core-library/build/aplcore \
-DYOGA_INCLUDE_DIR=$HOME/sdk-folder/apl-core-library/build/yoga-prefix/src/yoga \
-DYOGA_LIB_DIR=$HOME/sdk-folder/apl-core-library/build/lib \
 ../alexa-smart-screen-sdk
make -j2

