---
title: '8. Extra Credit'


layout: nil
---
Finished early? Or want to learn more? Here are some additional projects you can take on to further enhance your Alexa visual prototype:

### Add Attention State sounds to your device

Attention states are ways to indicate to customers when your device has detected the wakeword, Alexa is busy thinking, etc. They can be auditory or visual. Let's start by enabling the wakeword confirmation sound when your device has detected the wakeword and when Alexa goes into the Thinking state: 

1) Shut down the AVS smart screen SDK process running in the terminal window.

2) Go to your terminal window. Type the following commands to patch the AVS SDK to enable the wakeword confirmation sound by default:

```
patch -p1 <~/home/pi/Documents/avs_device_sdk_115_patch_enable_wakeword_confirmation_by_default.txt
```

The contents of the patch will modify two files used to control the default settings of the AVS SDK:

```
diff --git a/Settings/include/Settings/SpeechConfirmationSettingType.h b/Settings/include/Settings/SpeechConfirmationSettingType.h
index a087c7f..fb6d0f8 100644
--- a/Settings/include/Settings/SpeechConfirmationSettingType.h
+++ b/Settings/include/Settings/SpeechConfirmationSettingType.h
@@ -40,7 +40,7 @@ enum class SpeechConfirmationSettingType {
  * @return The default value speech confirmations setting.
  */
 inline SpeechConfirmationSettingType getSpeechConfirmationDefault() {
-    return SpeechConfirmationSettingType::NONE;
+    return SpeechConfirmationSettingType::TONE;
 }
 
 /**
diff --git a/Settings/include/Settings/WakeWordConfirmationSettingType.h b/Settings/include/Settings/WakeWordConfirmationSettingType.h
index ce1f800..68cc3c7 100644
--- a/Settings/include/Settings/WakeWordConfirmationSettingType.h
+++ b/Settings/include/Settings/WakeWordConfirmationSettingType.h
@@ -40,7 +40,7 @@ enum class WakeWordConfirmationSettingType {
  * @return The default value wake word confirmations setting.
  */
 inline WakeWordConfirmationSettingType getWakeWordConfirmationDefault() {
-    return WakeWordConfirmationSettingType::NONE;
+    return WakeWordConfirmationSettingType::TONE;
 }
 
 /**
```

3) Now, recompile the necessary AVS SDK libraries. Type this command in your terminal:

```
bash /home/pi/Documents/avs_compile_sdk.sh
```

Once this is done and no errors are seen, delete the old device settings storage file so the change will take effect:

```
rm -f /home/pi/sdk-folder/application-necessities/deviceSettings.db
```

4) Start the Smart screen SDK process and then the browser.

5) These are of course hard-coded settings. Wouldn't it be nice to use a skill or a visual UI interface to change the attention state sound settings? We look forward to what you can come up with. Send us your patch via a pull request:

[https://github.com/avs-smart-screen-sdk-workshop/avs-smart-screen-sdk-workshop.github.io](https://github.com/avs-smart-screen-sdk-workshop/avs-smart-screen-sdk-workshop.github.io)

### Create a Skill and control the state of LED lights and sample the state of a switch with AWS IoT

Did you notice we gave you a breadboard and electronic components along with your Pi? This is a workshop segement from re:MARS that you can follow that will enable you to use these components and control them using a Skill.

[https://avs-dvk-workshop.github.io/#/8-custom-skill](https://avs-dvk-workshop.github.io/#/8-custom-skill)

### Add attention state visuals with LED lights

Here is another way to use the electronic components in your kit. This guide will allow you to reflect the Attention State of the device using LEDs:

[https://developer.amazon.com/docs/alexa-voice-service/indicate-device-state-with-leds.html](https://developer.amazon.com/docs/alexa-voice-service/indicate-device-state-with-leds.html)


### Build an APL (Alexa Presentation Language skill)

to be added
