# BIOE421_FinalProject
## Realtime display tool for venous pulsation data
A device for realtime visualization and processing of accelerometer and heart rate sensor data for Team Jugularnauts, 
a Rice University senior engineering design team.

##### Possible features:
- Live display of raw accelerometer data
- Live display of heartrate sensor data
- Studfinder function for locating strongest pulsation signal
- Signal substraction of competitor physiological signals (i.e., carotid vs. jugular pulsations)
- Signal processing to isolate jugular vein pulsation

### Abstract
This device will serve as a realtime information display for use in developing a device to measure jugular venous pressure,
as part of Team Jugularnauts' senior design project. Preliminary prototypes will feature raw data acquisition from a 2x1 accelerometer
array and an optical heart rate sensor. The accelerometers and heart rate sensor will be interfaced with Arduino through analog input pins.
Arduino will be used for its precise timing capabilities, which are important for accurate signal subtraction, and will be connected to 
Raspberry Pi to provide realtime visual display of raw data through a Processing GUI. Future implementations may incorporate other desired 
features, including signal localization and signal processing. Signal localization may be explored through a “stud finder” mechanism, through 
which the strength of the signal corresponds to visual feedback on the Processing GUI, allowing the user to place the device correctly over the 
location of strongest signal (i.e., over the carotid/jugular bundle). Signal processing may be explored for reducing noise and subtracting 
competing physiologic signals, in order to isolate pulsations of the jugular vein.

### Milestones, Goals, and Due Dates
11/3: Project abstract due
- Publish final abstract to Github
- Prototype Processing GUI visualization using data from single ADXL335 accelerometer

11/9: Initial prototype due
- Prototype vizualization with 2x1 accelerometer array
- Implement heart rate sensor acquisition and visualization (if parts arrive)
- 3D print casing for device to be used on human neck, rather than affixed to breadboard

11/16: Fit and finish due
- Finalize GUI for visualization of raw signals
- Assemble 3D printed casing and hardware components
- Explore signal localization and subtraction of carotid pulse (heart beat)

11/28: Final code due
- Finalize additional features (signal localization and subtraction) 

