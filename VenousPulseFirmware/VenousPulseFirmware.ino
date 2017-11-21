// Angela Zhang and Nick Calafat
// BIOE 421, Rice University
// 11.2.2017: Modifications to exmaple code provided by AdaFruit for acquiring data from ADXL335 accelerometers
// 11.6 updates: data acquisition with 2 accelerometers, 1-axis (Z)
//                string w/ data sent to Processing for plotting
// 11.14 updates: added data acquisition from pulse sensor
// 11.20 updates: added noninverting preamp with G = 1.65; Rg = 1130 Ohm; Rf = 735 Ohm;
//                now convert raw analog read to voltage rather than acceleration (g)

#include <math.h>  // include math library

// define analog input pins
const int zInput1 = A0;
const int zInput2 = A1;
const int ECG_Input = A2;

// store data in string to send to Processing
String Accel_string;

// Take multiple samples to reduce noise
const int sampleSize = 50;

void setup() {
// put your setup code here, to run once:
analogReference(EXTERNAL);
Serial.begin(9600);
}

void loop() {
// put your main code here, to run repeatedly:

// collect data samples
float zRaw1 = ReadAxis(zInput1);
float zRaw2 = ReadAxis(zInput2);
float rawECG = ReadAxis(ECG_Input);

// convert to voltage (5V max = 1023 levels from DAQ)
float zAccel1 = zRaw1/1023*5000;
float zAccel2 = zRaw2/1023*5000;
float ECG = rawECG/1023*5000;

//delay(50);

// send data over to Processing
Accel_string = String(zAccel1) + ";" + String(zAccel2) + ";" + String(ECG);
Serial.print(Accel_string);
Serial.print('\n');
}

// Read "sampleSize" samples and report the average
int ReadAxis(int axisPin)
{
long reading = 0;
analogRead(axisPin);
delay(1);
for (int i = 0; i < sampleSize; i++)
{
  reading += analogRead(axisPin);
}
return reading/sampleSize;
}

