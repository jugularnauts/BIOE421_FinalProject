// Angela Zhang and Nick Calafat
// BIOE 421, Rice University
// 11.2.2017 Modification to existing example graphing code (credited below) for visualizing accelerometer and pulse sensor data
// 11.6.2017 updates: split data from Arduino string to acceleration values for each accelerometer, plot each in its own graph
// 11.7.2017 updates: add text displaying acceleration values (g) for each accelerometer
// 11.8.2017 updates: add scales, confine each graph to its own window
// 11.14.2017 updates: overlay pulse waveform over bottom graph
//                     clean up code; create single function for plotting; plot all graphs on same window in unique colors
// 11.15.2017 updates: added realtime user-scaling function for accelerometers y-axis
// 11.20.2017 updates: user-scaling function now accepts min and max value for range; now plotting raw voltage rather than accel. (g)

// Processing code for this example
// Graphing sketch
  // This program takes ASCII-encoded strings from the serial port at 9600 baud
  // and graphs them. It expects values in the range 0 to 1023, followed by a
  // newline, or newline and carriage return
  // created 20 Apr 2005
  // updated 24 Nov 2015
  // by Tom Igoe
  // This example code is in the public domain.

  import processing.serial.*;
  import controlP5.*;
  
  // initialize ControlP5 controller
  ControlP5 cp5;
  String max = "5000";
  String min = "0";
  
  PFont f;              // initialize font f

  Serial myPort;        // create variable for the serial port
  int xPos = 200;         // initialize horizontal position of the graph for graphing
  
  // initialize variables to store / plot accelerometer and ECG data
  float Z1raw;
  float Z1old;
  float Z1new;
  float Z2raw;
  float Z2old;
  float Z2new;
  float ECGraw;
  float ECGold;
  float ECGnew;
  float ymax;
  float ymin;
  
  
  // store color codes
  int[] red = {255,0,0};
  int[] green = {0,255,0};
  int[] blue = {0,0,255};
  int black = 0;
  int white = 255;


  void setup () {
    // set the window size:
    size(1200,900);
    
    // establish font f
    f = createFont("Arial",25,true);
    
    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    printArray(Serial.list());

    // use Serial.list()[x] to choose correct COM port for Arduino
    myPort = new Serial(this, Serial.list()[0], 9600);

    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');

    // set initial background color:
    background(white);
    
    // create controller object
    cp5 = new ControlP5(this);
    cp5.setColorBackground(color(255,255,255));
    cp5.setColorForeground(color(0,0,0));
    cp5.setFont(f);
    cp5.setColorActive(color(0,0,0));
    
    // create textfield for user-scaling input (max)
    cp5.addTextfield("max")
     .setColor(color(0,0,0))
     .setColorCursor(color(0,0,0))
     .setPosition(105,10)
     .setSize(70,40)
     .setFont(f)
     .setFocus(true)
     .setAutoClear(false)
     .setValue("5000")
     ;
     
    // create textfield for user-scaling input (min)
    cp5.addTextfield("min")
     .setColor(color(0,0,0))
     .setColorCursor(color(0,0,0))
     .setPosition(105,850)
     .setSize(70,40)
     .setFont(f)
     .setFocus(false)
     .setAutoClear(false)
     .setValue("0")
     ;
  }
   
  
  void draw () {
    // prevent crash when textfield is empty
    try { Integer.parseInt(cp5.get(Textfield.class,"max").getText());
    }  catch (NumberFormatException e) {
      ymax = 5000;
    }
    try { Integer.parseInt(cp5.get(Textfield.class,"min").getText());
    }  catch (NumberFormatException e) {
      ymin = 0;
    }  
       
    // draw sidebar and y-scale
    stroke(black);
    fill(white);
    rect(0,0,200,height);
    drawScale();
    
    // draw box to erase past printed voltages
    stroke(white);
    fill(white);
    rect(1000,height-100,width,height);
    
    textFont(f,25);
    fill(black);
    text("Max Y:",15,40);
    text("Min Y:",15,880);
    
    // print current acceleration 1
    textFont(f,25);
    fill(blue[0],blue[1],blue[2]);
    text("A1:",1000,height-60);
    text(Z1raw,1035,height-60);
    text("mV",1155, height-60);
    
    // print current acceleration 2
    textFont(f,25);
    fill(green[0],green[1],green[2]);
    text("A2:",1000,height-25);
    text(Z2raw,1035,height-25);
    text("mV",1155,height-25);
    
    // call function to draw each new data point
    drawLine(Z1old,Z1new, blue);
    drawLine(Z2old,Z2new, green);
    drawLine(ECGold,ECGnew, red);
    
   
    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 200;
      background(white);

      // draw sidebar and scale again
      stroke(255);
      fill(255);
      rect(0,0,200,height);
      
    } else {
      // increment the horizontal position:
      xPos++;
    }
  }

void drawScale(){
//read user-defined range for y-axis; create scale w/ 5 entries
  textFont(f,25);
  fill(black);
  ymax = Float.parseFloat(max);
  ymin = Float.parseFloat(min);       
  for (int i=0; i<5; i++) {
      float r = ymax-(ymax-ymin)*((float) i+1)/6;
      text(String.format("%d",(int) r) + " mV",100,(i+1)*height/6);
    }  
}
  
 
  void serialEvent (Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
            
      // store past acceleration points
      Z1old = Z1new;
      Z2old = Z2new;
      ECGold = ECGnew;
      
      
      // split the string at the semicolons
      String[] arduino_strings = split(inString, ';');
      
      if(arduino_strings.length == 3) {       // wait for all values (accel1, accel2, ECG) so program doesn't crash
        Z1raw = float(arduino_strings[0]);
        Z2raw = float(arduino_strings[1]);
        ECGraw = float(arduino_strings[2]);
      }
      
      Z1new = map(Z1raw,ymin,ymax,0,height);       // map accelerometers and ECG to graph height
      Z2new = map(Z2raw,ymin,ymax,0,height);
      ECGnew = map(ECGraw,ymin,ymax,0,height);

    }
  }
  
  void drawLine(float oldval, float newval, int[] c)
  {
    
    // draw line in color specified (red green or blue)
    stroke(c[0],c[1],c[2]);
    strokeWeight(1);
    noFill();
    
    line(xPos-1, height - oldval, xPos, height - newval);
    
    
    //rolling graph code -- in development
     
    //for (int i = 0; i < rawECG.length-1; i++) {      // move the pulse waveform by
    //  rawECG[i] = rawECG[i+1];                         // shifting all raw datapoints one pixel left
    //}
    //stroke(250,0,0);                               // red is a good color for the pulse waveform
    //noFill();
    //beginShape();                                  // using beginShape() renders fast
    //for (int x = 1; x < scaledECG.length-1; x++) {
    //  vertex(x+10, scaledECG[x]);                    //draw a line connecting the data points
    //}
    //endShape();
  }