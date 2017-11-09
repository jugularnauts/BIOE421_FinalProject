// Angela Zhang and Nick Calafat
// BIOE 421, Rice University
// 11.2.2017: Modifications to exmaple code provided by AdaFruit for acquiring data from ADXL335 accelerometers
// 11.6 updates: data acquisition with 2 accelerometers, 1-axis (Z)
//                string w/ data sent to Processing for plotting

const int zInput1 = A0;
const int zInput2 = A1;

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

// sensor 2 (ugly soldering)
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

// Take multiple samples to reduce noise
const int sampleSize = 50;

void setup() {
// put your setup code here, to run once:
analogReference(EXTERNAL);
Serial.begin(9600);
}

void loop() {
// put your main code here, to run repeatedly:

int zRaw1 = ReadAxis(zInput1);
int zRaw2 = ReadAxis(zInput2);

//Serial.println("Raw values");
//Serial.print("Z-1: ");
//Serial.println(zRaw1);
//Serial.print(", Z-2: ");
//Serial.println(zRaw2);
//Serial.println();

  
// Convert raw values to 'milli-Gs"
long zScaled1 = map(zRaw1, zRawMin1, zRawMax1, -1000, 1000);
long zScaled2 = map(zRaw2, zRawMin2, zRawMax2, -1000, 1000);

// re-scale to fractional Gs
float zAccel1 = zScaled1 / 1000.0;
float zAccel2 = zScaled2 / 1000.0;

//Serial.println("Acceleration");
//Serial.print("Z-1: ");
//Serial.print(zAccel1);
//Serial.print("G");
//Serial.print(", Z-2: ");
//Serial.print(zAccel2);
//Serial.println("G");
//Serial.println();

//delay(500);

Accel_string = String(zAccel1) + ";" + String(zAccel2);
Serial.print(Accel_string);
Serial.print('\n');
}

//
// Read "sampleSize" samples and report the average
//
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
