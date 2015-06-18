# Korg nanoKontrol2 Remote Support

Propellerhead Software  
Carlos Eduardo, SP/Brazil, <carlosedp@gmail.com>  

This version includes soft pickup for the knobs and sliders. This way the analog controls only act when the value on the knob matches the value of the control it is assigned so it is prevented that the control "jumps" when you modify a knob.

# Installation

## Part 1 - Copy the Remote Files

The files in the Remote directory should be copied into your user's Remote directory:

    OSX: Macintosh HD/Library/Application Support/Propellerhead Software/Remote
       it is also possible to install into /Users/[username]/Library/Application Support/Propellerhead Software/Remote if you want to keep them separate from your main Reason installation.
    Windows XP: C:/Documents and Settings/Application Data/Propellerhead Software/Remote/
    Windows Vista: C:/Documents and Settings/Program Data/Propellerhead Software/Remote/
    Windows 7: C:/ProgramData/Propellerhead Software/Remote

Carefully copy all of these files, strictly maintaining this directory structure:

    Remote/Codecs/Lua Codecs/Korg/nanoKontrol2.luacodec
    Remote/Codecs/Lua Codecs/Korg/nanoKontrol2.lua
    Remote/Codecs/Lua Codecs/Korg/nanoKontrol2.png
    Remote/Maps/Korg/nanoKONTROL2.remotemap

Now restart Reason so that it sees the new files. Go into Preferences and select your new MIDI controller - you can tell Reason to try and auto-detect the controller, or you can add it manually.

Note: I am not affiliated or associated in any way with Korg
or Propellerhead. I have created these files myself with the
files and programs legally available to me.

WARNING: You download and use these files entirely at your own risk!

I release this under a Creative Commons Attribution 3.0.
  http://creativecommons.org/licenses/by/3.0/
