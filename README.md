## Klipper for Ender 3 V2 

<img align="right" width=200 src="https://i.imgur.com/1tOqspu.png" />


**This guide is part of [this Reddit post](https://www.reddit.com/r/klippers/comments/kj2h5r/stepbystep_guide_for_ender_3_v2_klipper_w_bltouch/)
  that I change it to work with BLTOUCH and BMG on Fluidd/MainsailOS with my own configuration files.**

Step-by-Step Guide for Ender 3 v2 Klipper with BLTouch and BMD extruder. (Fluidd/MainsailOS) 
  
  **# NOT for OctoPrint**

## **What is Klipper?**

[Klipper](https://www.klipper3d.org/)
is fundamentally similar to Marlin except that it runs on the Raspberry
Pi vs. the motherboard itself. The firmware on the motherboard becomes "dumb" 
and everything runs on a much more powerful CPU.

**For more information about Klipper wach [this](https://www.youtube.com/watch?v=iNHta6zljoM)**

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
Fluidd/MainsailOS.


## **What do I need to run Klipper?**

Klipper requires a Raspberry Pi which you may already be using for OctoPrint. 
Once you install Klipper, the Raspberry Pi becomes the "brain" of your printer 
and the printer's motherboard is simply there to pass messages to the hardware.


## **Basic Installation**

1. You'll need to install [Fluidd](https://docs.fluidd.xyz/) / [MainsailOS](https://docs.mainsail.xyz/setup/mainsail-os) on a Raspberry Pi (don't use a v1 or a Zero).
2. You'll be doing work on the Raspberry Pi itself, so you'll [want to SSH into it](https://www.raspberrypi.org/documentation/remote-access/ssh/) from another computer. 
  You'll run a command like ssh pi@Mainsail where Mainsail is the IP address or hostname of the pi.\
  `The default password is raspberry`.
3. We'll generally be following [this guide](https://www.klipper3d.org/Installation.html).

    * A. Clone the git repository: `git clone https://github.com/KevinOConnor/klipper`.
  
    * B. Run the install script: `./klipper/scripts/install-octopi.sh`.
     
    * C. Change to the Klipper directory (`cd ~/klipper/`) and run the config tool (`make menuconfig`). Select the following in the menu:
            
      - i. Uncheck **Enable extra low-level configuration options**.
           
       - ii. Set processor architecture to **STMicroelectronics STM32**.
            
      - iii. Set processor model to **STM32F103**.
            
      - iv. Set bootloader offset to **28KiB bootloader**.
            
       - v. Uncheck the other two options (`Use USB` **and** `Use CAN`).
             
      - vi. Save and exit.
     
    * D. Type `make` and let it run.


4. The firmware file will be in `~/klipper/out/klipper.bin`. There's many ways to get it out of the Raspberry Pi, but I used `scp`.\
       From the main computer (where you ran ssh), type `scp pi@Mainsail:~/klipper/out/klipper.bin klipper.bin`.

5. Put the file on an SD card and put the SD card into the Ender 3 while the printer is off. \
   Turn on the printer and it should flash the firmware. If it flashed successfully, your LCD will go blank. \
   Don't worry, if anything goes wrong simply put Marlin firmware on it and flash it again.

6. You need to configure OctoPrint to communicate with the printer.

    * A. In Settings, go to Serial Connection and add `/tmp/printer` to Additional serial ports. Once you save, \
       in the same menu choose `/tmp/printer` under Serial Port.
       
    * B. Under Behavior, select `Cancel any ongoing prints but stay connected to the printer`.
    
    * C. If everything is good, you should see `/tmp/printer` in the main connection page and you should be able to connect. \
       If you go to Terminal and type `status` you should get back an error about config files. \
       This means you're communicating with the printer's new firmware!
   
7. Now we want to configure the firmware for the Ender 3 v2.\
   This is the equivalent of Marlin's `configuration.h` but you don't have to recompile firmware to change anything! It's pretty slick.   
   
    * A. In the home directory folder (`~/`) make a file called `printer.cfg`.\
        **Do not do this in the Klipper sub-folder**, it should be in your regular home directory.
        
    * B. Copy the contents of [this Ender 3 v2 configuration file](https://github.com/KevinOConnor/klipper/blob/master/config/printer-creality-ender3-v2-2020.cfg)          into printer.cfg and save it. 
    **Or you can download and add my printer.cfg file from this git and change the parameters that work for you**
   
    * C. In the Terminal of Fluidd / Mainsail, type `restart`. You should see the printer restart and become ready without errors.\
       You can also issue a `status` command. What's beautiful about Klipper is that whenever you make config changes, \
       you just save and run `restart` and that's it. No recompiling!
   
   
## Configuring BLTouch
For BLTouch, you have to do a bit more work to get Klipper configured. You should read the [detailed guide](https://www.klipper3d.org/BLTouch.html),      but this is a quick summary.

Add the following code to your `printer.cfg`:

  If you use the original mount for the BLTOUCH from Creality than change: 
    `x_offset: -43`
    `y_offset: -7.5`
  
  If you use the mount from [Thingiverse](https://www.thingiverse.com/thing:4462870) change to:
    `x_offset: -42`
    `y_offset: -10`

Also check this [video](https://www.youtube.com/watch?v=ABsdnkP4iwQ)

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
    mesh_min: 15, 15 # min 15 mm for the probe
    mesh_max: 193, 193 # max 193 mm for the probe
    probe_count: 3,3 # Mesh points
    algorithm: bicubic
    fade_start: 1
    fade_end: 10
    fade_target: 0

## Configuring BMG
**This part is very important so don't skip it**\
To use BMG you need to calculate `rotation_distance` in your printer.\
I calculated it with [this klipper guide](https://www.klipper3d.org/Rotation_Distance.html?h=bmg#calibrating-rotation_distance-on-extruders)
And dont forgat to add `gear_ratio` to the [extruder].\
For me the settings are:
      
    [extruder]  
    rotation_distance: 22.288
    gear_ratio: 3:1 # BMG gear ratio

and you can also use this video [this video](https://www.youtube.com/watch?v=4PgOdES7n8Y)


   ## Screw Measurement

What's amazing about Klipper is that it has a screw measurement feature.
It runs BLTouch above each of the 4 screws and tells you how much to 
turn each one to dial your bed in perfectly (e.g., "CW 00:15" or turn 
clockwise 1/4 turn). To enable this, add:
   
    [screws_tilt_adjust]
    screw1: 70.5,37.5
    screw1_name: front left screw
    screw2: 240,37.5
    screw2_name: front right screw
    screw3: 240,207.5
    screw3_name: rear right screw
    screw4: 70.5,207.5
    screw4_name: rear left screw
    horizontal_move_z: 10
    speed: 50
    screw_thread: CW-M4
 
 1. With all of this done, you can now level the bed. First, home with `G28` and type `SCREWS_TILT_CALCULATE` to adjust the bed.\
    You can type `SCREWS_TILT_CALCULATE` multiple times until it's close.
     
 2. To level the bed, you can run `BED_MESH_CALIBRATE`. After calibration, make sure to hit `SAVE_CONFIG`.
    
    **You can start it via G29 macro code** 
     

## Advanced Stuff
Klipper lets you do a lot of advanced stuff. It's a lot to cover, but here's a brief overview of what you can do:

**Tuning PIDs**
It's really simple to tune your extruder and bed PIDs.\
Just run `PID_CALIBRATE HEATER=extruder TARGET=200` and `PID_CALIBRATE HEATER=heater_bed TARGET=60`.\
**Don't forget to `SAVE_CONFIG` after each run!**


**Resonance/Ringing Compensation**
Do this before setting pressure advance, because it will change your values. When you start printing at higher speeds, you may see ringing. 
This is also fairly simple to fix by [following this guide](https://www.klipper3d.org/Resonance_Compensation.html). Basically you print a model at very high accelerations, then measure 
the frequency of the ripples in the print. Then, you tell Klipper those frequencies and select the algorithm you want to make it go away:

    [input_shaper]
    shaper_freq_x: 45.5
    shaper_freq_y: 46.8
    shaper_type: ei

My `input_shaper` is:
    
    [input_shaper]
    shaper_freq_x: 40.42
    shaper_freq_y: 33.90
    shaper_type: mzv
    **Take a look at the changes between ei vs mzv**

For more advance use [this video](https://www.youtube.com/watch?v=OoWQUcFimX8) or this [video](https://youtu.be/EJapxNsntsQ?t=459)

**Pressure Advance**
Setting pressure advance is really straightforward with [these instructions](https://www.klipper3d.org/Pressure_Advance.html). You just slice an stl file, then get the printer into a special mode, 
and print. Look for the height where your corners start becoming too rounded and calculate the value from there. Once you find the value, 
under `[extruder]` add `pressure_advance` **with the number** (e.g., between 0.5 and 0.9 for an Ender 3 v2) and you're done!\
Now try printing at higher speeds and see how it goes.\

Also check this [video](https://youtu.be/EJapxNsntsQ?t=235)


**Babystepping**
Babystepping is easy with Klipper, enabling you to dial in your z-offset just right.\
While printing, simply issue `SET_GCODE_OFFSET Z_ADJUST=0.01 MOVE=1` to move the head up 0.01.\
Reset to default with `SET_GCODE_OFFSET Z=0.0 MOVE=1`.


## What is Macro?
A serias of commands to be run when a specific command is input

**Custom Macros and G-Codes**
At first glance, it looks like Klipper doesn't support some g-codes that Marlin does. However,\
what Klipper supports is custom macros so you can create any g-code. For example, my G29 is:\

    [gcode_macro G29]
    gcode:
      G28
      BED_MESH_CALIBRATE
      G0 X0 Y0 Z10 F6000
      BED_MESH_PROFILE save=default
      SAVE_CONFIG
    
    
Check this [Klipper example](https://www.klipper3d.org/Command_Templates.html) for more Macros.
    
**Also you can check [printer.cfg](https://github.com/BenD780x9/Klipper-for-Ender_3_v2/blob/main/printer.cfg) for more Macros**    

You can also create your very own ones!\
In Cura, my g-codes are now `START_PRINT T_BED={material_bed_temperature_layer_0} T_EXTRUDER={material_print_temperature_layer_0}` and `END_PRINT` with the actual commands defined in `printer.cfg`.\
This enables much easier porting between machines and slicers.

**Copy `cura_klipper_start_end.gcode` file and add to cura GECODE setting**\
And check if START_PRINT AND END_PRINT section in the `printer.cfg` works for you.


## What to do with the LCD?
Check this [github page](https://github.com/bustedlogic/DWIN_T5UIC1_LCD) and in this [Reddit post](https://www.reddit.com/r/klippers/comments/q6gl65/ender_3_v2_display_help/) you can find some important data.

**I don't tested it yet because I have an old tablet that I use for my printer**
  
  
# Youtube
I highly recommend to watch Klipper configuration and tests in this channels:
1. [Teaching Tech](https://www.youtube.com/channel/UCbgBDBrwsikmtoLqtpc59Bw)
2. [NERO 3D](https://www.youtube.com/user/Neroga)
3. [eddietheengineer](https://www.youtube.com/user/userjet2005)


  # To Do: 
  
   * Add placeholder for output file.
   * Add license.
   * Add Slicer profiles Cura \ SuperSlicer.
   * Add section about why I'm not using OctoPrint.
    
  
  ## Thanks:
  
   * Miron Vranješ for his guide on [Reddit](https://www.reddit.com/r/klippers/comments/kj2h5r/stepbystep_guide_for_ender_3_v2_klipper_w_bltouch/) and in his [site](https://www.mironv.com/2020/12/23/ender3v2-bltouch-klipper/) which I based my guide on it.
  * [Teaching Tech](https://www.youtube.com/channel/UCbgBDBrwsikmtoLqtpc59Bw), [NERO 3D](https://www.youtube.com/user/Neroga), [eddietheengineer](https://www.youtube.com/user/userjet2005) for their great videos that helped me a lot to configure and understand how Klipper works.
  
  
  
  ## Klipper:

   https://www.reddit.com/r/klippers/comments/kj2h5r/stepbystep_guide_for_ender_3_v2_klipper_w_bltouc
    
   https://www.reddit.com/r/klippers/comments/q6gl65/ender_3_v2_display_help/
    
   https://github.com/GalvanicGlaze/DWIN_T5UIC1_LCD/wiki
    
   https://github.com/bustedlogic/DWIN_T5UIC1_LCD
    
   https://albertogrespan.com/blog/3d-printing/klipper-on-an-ender-3/
    
   https://www.klipper3d.org/Command_Templates.html
    
   https://gist.github.com/besser/30140a30312d5c7adceabf8a493472c3
   
   https://www.youtube.com/watch?v=EJapxNsntsQ
   
   https://www.youtube.com/c/Nero3D/videos
    
   
  ## GCODE:
  
   https://github.com/prusa3d/PrusaSlicer/wiki/Slic3r-placeholders-(a-copy-of-the-mauk.cc-page)
   
   ## Macros
   
   https://github.com/Desuuuu/klipper-macros
  
