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
as part of Team Jugularnauts' senior design project. Preliminary prototypes will feature raw data acquisition from a 3x1 accelerometer
array and an optical heart rate sensor. The accelerometers will be interfaced with Arduino through the I2C communications protocol, 
and the heart rate sensor will be connected through a single analog input. Arduino will be used for its precise timing capabilities,
which are important for accurate signal subtraction, and will be connected to Raspberry Pi to provide realtime visual display of raw data 
through a Processing GUI. Future implementations may incorporate other desired features, including signal localization and signal processing.
Signal localization may be explored through a “stud finder” mechanism, through which the strength of the signal corresponds to visual
feedback on the Processing GUI, allowing the user to place the device correctly over the location of strongest signal 
(i.e., over the carotid/jugular bundle). Signal processing may be explored for reducing noise and subtracting competing physiologic signals,
in order to isolate pulsations of the jugular vein.
