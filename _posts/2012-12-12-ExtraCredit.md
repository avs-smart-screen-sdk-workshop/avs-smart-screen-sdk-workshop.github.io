---
title: '9. Extra Credit'


layout: nil
---
Finished early? Or want to learn more? Here are some additional projects you can take on to further enhance your Alexa visual prototype:

### Add attention State sounds to your device

Attention states are ways to indicate to customers when Alexa is listening, thinking, etc. They can be auditory or visual. First, let's start with adding noises for when the wake word is triggered. You will follow the set of instructions on an existing online guide, with a few key differences: 

1) You can use your editor of choice on the Pi. The GEANY Editor is a fine choice, just make sure you close that window when you are no longer using it, as it can take up valuable resources from your Pi
2) The file you want to change is called GUIManager.cpp at the location of modules/Alexa/SampleApp/src/GUI/GUIManager.cpp
3) The tutorial covers the wake word (LISTENING) state. What about when Alexa stops listening and starts thinking? You could use the (size)_ui_endpointing.wav sound to indicate that Alexa is now processing the customer's utterance.
4) Don't forget "break" statements!


### Add attention state visuals with LED lights

to be added

### Build an APL (Alexa Presentation Language skill)

to be added