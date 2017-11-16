// Angela Zhang and Nick Calafat
// BIOE 421, Rice University
// 11.2.2017: Modifications to exmaple code provided by AdaFruit for acquiring data from ADXL335 accelerometers
// 11.6 updates: data acquisition with 2 accelerometers, 1-axis (Z)
//                string w/ data sent to Processing for plotting
// 11.14 updates: added data acquisition from pulse sensor
// 11.16 updates: changed 50-sample average to moving average

#include <math.h>  // include math library

// define analog input pins
const int zInput1 = A0;
const int zInput2 = A1;
const int ECG_Input = A2; 

// values from calibration
// sensor 1 (yellow side highlight)
// Raw Ranges: X: 411-615, Y: 402-608, Z: 444-650
// 510, 502, 648 :: -0.03G, -0.03G, 0.98G

// set range for sensor 1 voltages
int xRawMin1 = 411;
int xRawMax1 = 615;

int yRawMin1 = 402;
int yRawMax1 = 608;

int zRawMin1 = 444;
int zRawMax1 = 650;

// Calibration values sensor 2 (ugly soldering)
// Raw Ranges: X: 406-609, Y: 401-604, Z: 424-631
// 501, 493, 628 :: -0.07G, -0.09G, 0.97G

// set range for sensor 2 voltages
int xRawMin2 = 406;
int xRawMax2 = 609;

int yRawMin2 = 401;
int yRawMax2 = 604;

int zRawMin2 = 424;
int zRawMax2 = 631;

// store data in string to send to Processing
String Accel_string;

// Set sample size and initialize variables to store each sensor's data
const int sampleSize = 5;
int Z1s[sampleSize];
int Z2s[sampleSize];
int ECGs[sampleSize];
int z1tot = 0;
int z2tot = 0;
int ecgtot = 0;
int readIndex = 0;
int z1avg = 0;
int z2avg = 0;
int ecgavg = 0;


void setup() {
// put your setup code here, to run once:
analogReference(EXTERNAL);
Serial.begin(9600);

for (int thisSample = 0; thisSample<sampleSize; thisSample++) {
  Z1s[thisSample] = 0;
  Z2s[thisSample] = 0;
  ECGs[thisSample] = 0;  
}

}

void loop() {
// put your main code here, to run repeatedly:

// collect data sample, compute moving average
z1tot = ReadAxisAvg(zInput1, Z1s, z1tot, readIndex);
z1avg = z1tot/sampleSize;
z2tot = ReadAxisAvg(zInput2, Z2s, z2tot, readIndex);
z2avg = z2tot/sampleSize;
ecgtot = ReadAxisAvg(ECG_Input, ECGs, ecgtot, readIndex);
ecgavg = ecgtot/sampleSize;

// advance to the next position in the array:
readIndex = readIndex + 1;

// if we're at the end of the array...
if (readIndex >= sampleSize) {
  // ...wrap around to the beginning:
  readIndex = 0;
}

// Convert raw accel values to Gs
long zScaled1 = map(z1avg, zRawMin1, zRawMax1, -1000, 1000);
long zScaled2 = map(z2avg, zRawMin2, zRawMax2, -1000, 1000);

// re-scale to fractional Gs
float zAccel1 = zScaled1 / 1000.0;
float zAccel2 = zScaled2 / 1000.0;

//delay(50);

// send data over to Processing
Accel_string = String(zAccel1) + ";" + String(zAccel2) + ";" + String(ecgavg);
Serial.print(Accel_string);
Serial.print('\n');

}

// Read running average of "sampleSize" samples, report the average
int ReadAxisAvg(int pin, int readings[], int tot, int index)
  {
    // subtract the oldest reading:
    tot = tot - readings[index];
    // read from the sensor:
    readings[index] = analogRead(pin);
    // add the reading to the total:
    tot = tot + readings[index];

    delay(1);        // delay in between reads for stability
    return(tot);
  }
  

