# Korg nanoKontrol2 Remote Support

Propellerhead Software
Carlos Eduardo, SP/Brazil, <carlosedp@gmail.com>

This remote script for Korg nanoKontrol2 includes soft pickup for the knobs and sliders. This way the analog controls only act when the value on the knob matches the value of the control it is assigned so it is prevented that the control "jumps" when you modify a knob.

## Usage

It's recommended to lock the nanoKontrol2 to the Reason Master Section allowing control of channel faders, pan, solo, mute and record at all times.

To lock, go to "Options -> Surface Locking -> Select the nanoKontrol2 surface and Master Section in the Device".

The 8th (last) fader group in the nanoKontrol2 is always bound to the Master Fader. Pan knob controls Control Room Out, "S" button is "Solo all off", "M" button is "Mute all off" and "R" button is Bypass Master Inserts.

Track <- and -> buttons, move the surface control to the left and right channels, one at a time. The <- and -> Marker buttons, move left and right 8 channels at a time. To check which channel is controlled by the leftmost fader group, look at the yellow marker in the Mixer.

## Installation

## Part 1 - Copy the Remote Files

The files in the Remote directory should be copied into your user's Remote directory:

    OSX: `/Library/Application Support/Propellerhead Software/Remote`
        or
         `/Users/[username]/Library/Application Support/Propellerhead Software/Remote`
        if you want to keep them separate from your main Reason installation.
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
