// Modifications to exmaple code provided by AdaFruit for acquiring data from ADXL335 accelerometers
// Angela Zhang and Nick Calafat
// BIOE 421, Rice University
// 11.2.2017

const int xInput = A0;
const int yInput = A1;
const int zInput = A2;

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


// Take multiple samples to reduce noise
const int sampleSize = 50;

void setup() {
// put your setup code here, to run once:
analogReference(EXTERNAL);
Serial.begin(9600);
}

void loop() {
// put your main code here, to run repeatedly:

int xRaw1 = ReadAxis(xInput);
int yRaw1 = ReadAxis(yInput);
int zRaw1 = ReadAxis(zInput);

//Serial.println("Raw values");
//Serial.print("X: ");
//Serial.print(xRaw1);
//Serial.print(", Y: ");
//Serial.print(yRaw1);
//Serial.print(", Z: ");
Serial.println(zRaw1); 
//Serial.println();

  
  // Convert raw values to 'milli-Gs"
  long xScaled = map(xRaw1, xRawMin1, xRawMax1, -1000, 1000);
  long yScaled = map(yRaw1, yRawMin1, yRawMax1, -1000, 1000);
  long zScaled = map(zRaw1, zRawMin1, zRawMax1, -1000, 1000);

  // re-scale to fractional Gs
  float xAccel = xScaled / 1000.0;
  float yAccel = yScaled / 1000.0;
  float zAccel = zScaled / 1000.0;

  //Serial.println("Acceleration");
  //Serial.print("X: ");
  //Serial.print(xAccel);
  //Serial.print("G, ");
  //Serial.print(", Y: ");
  //Serial.print(yAccel);
  //Serial.print("G, ");
  //Serial.print(", Z: ");
  //Serial.print(zAccel);
  //Serial.println("G");
  //Serial.println();

//delay(500);

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
