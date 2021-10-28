Default start/end GCODE.
** It's better to use Macros with START_PRINT / END_PRINT **

##### Start: #####

G90 ; use absolute coordinates
M83 ; extruder relative mode
M140 S[first_layer_bed_temperature] ; set final bed temp
;G4 S10 ; allow partial nozzle warmup
G28 ; home all axis
G1 Z25 F240
G1 X2 Y10 F3000
M104 S{first_layer_temperature[initial_extruder]+extruder_temperature_offset[initial_extruder]} ; set final nozzle temp
M190 S[first_layer_bed_temperature] ; wait for bed temp to stabilize
M109 S{first_layer_temperature[initial_extruder]+extruder_temperature_offset[initial_extruder]} ; wait for nozzle temp to stabilize
G1 Z0.28 F240
G92 E0
G1 Y140 E10 F1500 ; prime the nozzle
G1 X2.3 F5000
G92 E0
G1 Y10 E10 F1200 ; prime the nozzle
G92 E0




##### End: #####

# Print message on LCD
M117 Done printing :)
# Turn off bed, extruder, and fan
M140 S0
M104 S0
M106 S0
M107 ; turn off fan
# Relative positionning
G91
G1 E-10 Z+10 F3000 # unload little filament.
# Retract and raise Z
G1 Z0.2 E-2 F2400
# Wipe out
G1 X5 Y5 F3000
# Raise Z more
G1 Z10
# Absolute positionning
G90
# Present print
G1 X10 Y220 F2000 # absolute xy
G1 X0 Y{machine_depth}
#disable hotend and heated bed
M104 S0
M140 S0
# disable steppers
M84 X Y E ; disable motors
# Disable steppers
#M84
#BED_MESH_CLEAR
