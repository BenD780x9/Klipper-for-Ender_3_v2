## Klipper on Ender 3 V2 

<img align="right" width=200 src="https://raw.githubusercontent.com/BenD780x9/Marlin_Ender3v2/Ender3v2-Released/buildroot/share/pixmaps/Ender-3V2.jpg" />

**This guide is replica of [this Reddit post](https://www.reddit.com/r/klippers/comments/kj2h5r/stepbystep_guide_for_ender_3_v2_klipper_w_bltouch/)
  that I change it to work with BLTOUCH and BMG on Fluidd/MainsailOS and with my own configuration files.**

Step-by-Step Guide for Ender 3 v2 Klipper with BLTouch and BMD extruder. (Flidd/MainsailOS) 
  
  **# NOT for OctoPrint**

## **What is Klipper?**

[Klipper](https://www.klipper3d.org/)
is fundamentally similar to Marlin except that it runs on the Raspberry
Pi vs. the motherboard itself. The firmware on the motherboard becomes "dumb" 
and everything runs on a much more powerful CPU.


## **Why should I install Klipper?**

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


## **What do I need to run Klipper?**

Klipper requires a Raspberry Pi which you may already be using for OctoPrint. 
Once you install Klipper, the Raspberry Pi becomes the "brain" of your printer 
and the printer's motherboard is simply there to pass messages to the hardware.


## **Basic Installation**

1. You'll need to install [Fluidd](https://docs.fluidd.xyz/) / [MainsailOS](https://docs.mainsail.xyz/setup/mainsail-os) on a Raspberry Pi (don't use a v1 or a Zero).
2. You'll be doing work on the Raspberry Pi itself, so you'll [want to SSH into it](https://www.raspberrypi.org/documentation/remote-access/ssh/) from another computer. 
  You'll run a command like ssh pi@Mainsail where Mainsail is the IP address or hostname of the pi. 
  `The default password is raspberry`.
3. We'll generally be following [this guide](https://www.klipper3d.org/Installation.html).

      A. Clone the git repository: `git clone https://github.com/KevinOConnor/klipper`.
  
      B. Run the install script: `./klipper/scripts/install-octopi.sh`.
      
      C. Change to the Klipper directory (`cd ~/klipper/`) and run the config tool (`make menuconfig`). Select the following in the menu:
            
      i. Uncheck **Enable extra low-level configuration options**.
           
     ii. Set processor architecture to **STMicroelectronics STM32**.
            
    iii. Set processor model to **STM32F103**.
            
     iv. Set bootloader offset to **28KiB bootloader**.
            
      v. Uncheck the other two options (`Use USB` **and** `Use CAN`).
             
     vi. Save and exit.
     
     D. Type `make` and let it run.


4. The firmware file will be in `~/klipper/out/klipper.bin`. There's many ways to get it out of the Raspberry Pi, but I used `scp`. \
    From the main computer (where you ran ssh), type `scp pi@Mainsail:~/klipper/out/klipper.bin klipper.bin`.

**5**. Put the file on an SD card and put the SD card into the Ender 3 while the printer is off. \
       Turn on the printer and it should flash the firmware. If it flashed successfully, your LCD will go blank. \
       Don't worry, if anything goes wrong simply put Marlin firmware on it and flash it again.

**6**. You need to configure OctoPrint to communicate with the printer.

   A. In Settings, go to Serial Connection and add `/tmp/printer` to Additional serial ports. Once you save, \
       in the same menu choose `/tmp/printer` under Serial Port.
       
   B. Under Behavior, select `Cancel any ongoing prints but stay connected to the printer`.
    
   C. If everything is good, you should see `/tmp/printer` in the main connection page and you should be able to connect. \
       If you go to Terminal and type `status` you should get back an error about config files. \
       This means you're communicating with the printer's new firmware!
   
7. Now we want to configure the firmware for the Ender 3 v2. \
   This is the equivalent of Marlin's `configuration.h` but you don't have to recompile firmware to change anything! It's pretty slick.   
   
   A. In the home directory folder (`~/`) make a file called `printer.cfg`.\
        **Do not do this in the Klipper sub-folder**, it should be in your regular home directory.
        
   B. Copy the contents of [this Ender 3 v2 configuration file](https://github.com/KevinOConnor/klipper/blob/master/config/printer-creality-ender3-v2-2020.cfg) into printer.cfg and save it.
   
   C. In the Terminal of Fluidd / Mainsail, type `restart`. You should see the printer restart and become ready without errors.\
   You can also issue a `status` command. What's beautiful about Klipper is that whenever you make config changes, \
   you just save and run `restart` and that's it. No recompiling!
   
   
## Configuring BLTouch
For BLTouch, you have to do a bit more work to get Klipper configured. You should read the [detailed guide](https://www.klipper3d.org/BLTouch.html),      but this is a quick summary.

1. Add the following code to your `printer.cfg`:

  If you use the original mount for the BLTOUCH from Creality than change: 
    `x_offset: -43`
    `y_offset: -7.5`
  
  If you use the mount from [Thingiverse](https://www.thingiverse.com/thing:4462870) change to:
    `x_offset: -42`
    `y_offset: -10`


## Probe calibration
With Klipper you can [calibrate the x and y offsets more precisely](https://www.klipper3d.org/Probe_Calibrate.html) and then you'll also need to add your z offset.\
The sign is flipped between Marlin and Klipper, so for me the z-offset of `-2.60` became `2.60` here.\
Note that during calibration you will need to let the z axis go negative, so you can add `position_min: -3` until you're done calibrating.

**Important:** Do all the tests with ["Paper test"](https://www.klipper3d.org/Probe_Calibrate.html) and **only** after you finish them with good results move on with the guide.                

## Configuring Mesh Leveling
There's a lot of [bed mesh configuration options](https://github.com/KevinOConnor/klipper/blob/master/docs/Bed_Mesh.md), but here's one that works for me:

                [bed_mesh]

                speed: 120

                horizontal_move_z: 5

                mesh_min: 15, 15

                mesh_max: 193, 193

                probe_count: 3,3

                algorithm: bicubic

                fade_start: 1

                fade_end: 10

                fade_target: 0
  

   
   
  ## Klipper:

   https://www.reddit.com/r/klippers/comments/kj2h5r/stepbystep_guide_for_ender_3_v2_klipper_w_bltouc
    
   https://www.reddit.com/r/klippers/comments/q6gl65/ender_3_v2_display_help/
    
   https://github.com/GalvanicGlaze/DWIN_T5UIC1_LCD/wiki
    
   https://github.com/bustedlogic/DWIN_T5UIC1_LCD
    
   https://albertogrespan.com/blog/3d-printing/klipper-on-an-ender-3/
    
   https://www.klipper3d.org/Command_Templates.html
    
   https://gist.github.com/besser/30140a30312d5c7adceabf8a493472c3
    
    
  ## Marlin:
  
   https://marlinfw.org/
   
   https://marlin.crc.id.au/firmware/Ender%203%20V2%20-%20Stock/
       
   https://github.com/Jyers/Marlin
       
   https://github.com/mriscoc/Marlin_Ender3v2/releases
  
  ## GCODE:
  
   https://github.com/prusa3d/PrusaSlicer/wiki/Slic3r-placeholders-(a-copy-of-the-mauk.cc-page)
  
