#!/bin/bash
#
#
SOUND_CONFIG="$HOME/.asoundrc"

configure_sound() {
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

pcm.output {
	type hw
	card 0
}

ctl.!default {
	type hw
	card 0
}

pcm.input {
	type hw
	card 0
}
EOF
}

#create alsa config
configure_sound

PA_ALSA_PLUGHW=1 /home/pi/sdk-folder/ss-build/modules/Alexa/SampleApp/src/SampleApp -C /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json -C /home/pi/sdk-folder/alexa-smart-screen-sdk/modules/GUI/config/SmartScreenSDKConfig.json -K /home/pi/sdk-folder/third-party/alexa-rpi/models -L INFO
