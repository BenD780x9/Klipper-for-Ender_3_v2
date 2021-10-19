# Ender_3_v2
Configuration files for Slicer and Klipper.

**This guide is replica of https://www.reddit.com/r/klippers/comments/kj2h5r/stepbystep_guide_for_ender_3_v2_klipper_w_bltouch/ 
  that I change it to work with Fluidd/MainsailOS and with my own configuration files.**

Step-by-Step Guide for Ender 3 v2 Klipper with BLTouch and BMD extruder. (Flidd/MainsailOS) # NOT for OctoPrint

**What is Klipper?**

Klipper https://www.klipper3d.org/
is fundamentally similar to Marlin except that it runs on the Raspberry
Pi vs. the motherboard itself. The firmware on the motherboard becomes "dumb" 
and everything runs on a much more powerful CPU.


**Why should I install Klipper?**

Installing Klipper on an 8-bit CPU like the original Ender meant 
detailed prints were a lot better since they simply didn't have enough 
processing power. The Ender 3 v2 has a 32-bit CPU so this advantage is a
bit smaller (though Klipper uses more advanced kinematics equations so 
the prints will still be slightly better). But, there are a lot of other
advantages to Klipper:

  * Ability to have pressure advance (similar to linear advance) on any Ender 3 v2
  * Ability to use input shaping to eliminate ghosting and ringing
  * Better bed leveling
  * Deep customizability without needing to recompile firmware
  * Custom G-codes and macros

**Warning:** Installing 
Klipper will mean your printer's LCD is always blank. If you want 
control when you're physically at the printer, you'll need to add a 
touchscreen LCD to your Raspberry Pi instead and control the printer via
OctoPrint.


**What do I need to run Klipper?**

Klipper requires a Raspberry Pi which you may already be using for OctoPrint. 
Once you install Klipper, the Raspberry Pi becomes the "brain" of your printer 
and the printer's motherboard is simply there to pass messages to the hardware.


**Basic Installation**






  Klipper:

   https://www.reddit.com/r/klippers/comments/kj2h5r/stepbystep_guide_for_ender_3_v2_klipper_w_bltouc
    
   https://www.reddit.com/r/klippers/comments/q6gl65/ender_3_v2_display_help/
    
   https://github.com/GalvanicGlaze/DWIN_T5UIC1_LCD/wiki
    
   https://github.com/bustedlogic/DWIN_T5UIC1_LCD
    
   https://albertogrespan.com/blog/3d-printing/klipper-on-an-ender-3/
    
   https://www.klipper3d.org/Command_Templates.html
    
   https://gist.github.com/besser/30140a30312d5c7adceabf8a493472c3
    
    
  Marlin:
  
   https://marlinfw.org/
   
   https://marlin.crc.id.au/firmware/Ender%203%20V2%20-%20Stock/
       
   https://github.com/Jyers/Marlin
       
   https://github.com/mriscoc/Marlin_Ender3v2/releases
  
  GCODE:
  
   https://github.com/prusa3d/PrusaSlicer/wiki/Slic3r-placeholders-(a-copy-of-the-mauk.cc-page)
  
