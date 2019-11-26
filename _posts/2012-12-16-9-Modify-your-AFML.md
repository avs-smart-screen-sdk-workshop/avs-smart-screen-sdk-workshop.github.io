---
title: '7. Customize your Renderer'


layout: nil
---

Depending on the size of your screen or how your device is used, you might want to make changes in your screen's display behavior.  Navigate to the following folder in your File Manager: `/home/pi/.../modules/GUI/config/guiConfigSamples/`

You'll notice several different files in here starting wtih `GuiConfigSample_` and different profiles for TVs or Smart Screens. Our default is that we are using the TvOverlayLandscape, but what if we wanted to emulate a Smart Screen device with no overlay? We would use the GuiConfigSample_SmartScreenLargeLandscape.json. We need to relaunch our SmartScreen SDK but add in an additional parameter when launching the sample app to use a different GUI client configuration.

With a text editor (Geany works fine), open up the file **/home/pi/avs_run.sh**

On the last line you'll see that we have a few parameters we launch with. Let's go over these.
*PA_ALSA_PLUGHW=1* - this is specific to the Raspberry Pi, it has to do with Alsa and the Raspberry Pi audio.
*/home/pi/sdk-folder/ss-build/modules/Alexa/SampleApp/src/SampleApp* - launches our Sample App executable
*-C /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json* - specifies a configuration of our Alexa Client, such as our device security *rofile, device ID, etc 
*-C /home/pi/sdk-folder/alexa-smart-screen-sdk/modules/GUI/config/SmartScreenSDKConfig.json* - specifies the configuration specific to our Smart Screen SDK 
*-K /home/pi/sdk-folder/third-party/alexa-rpi/models* - This is the model used by the Sensory wake word engine 
*-L INFO* - Debug threshold level. DEBUG9 is the most verbose

In order to use another configuration, we need to add an additional -C parameter after the SmartScreenSDKConfig.json referecing the file location of the desired file. So if we wanted to try out the Smart Screen Large Landscape using Push To Talk, add the following parameter:

`-C /home/pi/sdk-folder/alexa-smart-screen-sdk/modules/GUI/config/guiConfigSamples/GuiConfigSample_SmartScreenLargeLandscape.json` 

So the entire path would be:

`PA_ALSA_PLUGHW=1 /home/pi/sdk-folder/ss-build/modules/Alexa/SampleApp/src/SampleApp -C /home/pi/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json -C /home/pi/sdk-folder/alexa-smart-screen-sdk/modules/GUI/config/SmartScreenSDKConfig.json -C /home/pi/sdk-folder/alexa-smart-screen-sdk/modules/GUI/config/guiConfigSamples/GuiConfigSample_SmartScreenLargeLandscape.json -K /home/pi/sdk-folder/third-party/alexa-rpi/models -L INFO`

Now just simply re-run your `avs-run.sh` command and your new configuration should be in place! If you want to update this configuration to use the wake word, you can update the `GuiConfigSample_SmartScreenLargeLandscape.json` file, look for:

`"audioInputInitiator": "TAP",`

You can then update to:

`"audioInputInitiator": "WAKE_WORD",`

and re-run `avs-run.sh`. 

The point of this exercise is to show how you can modify any of these configuration options to launch your Smart Screen SDK Sample App with different screen sizes and characteristics. At any time you can always remove the third parameter and go back to the original. 

