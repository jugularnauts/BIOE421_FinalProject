// Angela Zhang and Nick Calafat
// BIOE 421, Rice University
// 11.2.2017 Modification to existing example graphing code (credited below) for visualizing accelerometer data
// 11.6.2017 updates: split data from Arduino string to acceleration values for each accelerometer, plot each in its own graph
// 11.7.2017 updates: add text displaying acceleration values (g) for each accelerometer
// 11.8.2017 updates: add scales, confine each graph to its own window

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
  
  PFont f;              // initialize font f

  Serial myPort;        // create variable for the serial port
  int xPos = 200;         // initialize horizontal position of the graph for graphing
  float prevZ1 = 0;     // create variables for storing current and previous Z values
  float prevZ2 = 0;
  float Z1 = 0;
  float Z2 = 0;
  float Z1_scaled = 0;
  float Z2_scaled = 0;
  int g_min = -3;
  int g_max = 3;

  void setup () {
    // set the window size:
    size(1200,900);
    
    // establish font f
    f = createFont("Arial",16,true);
    
    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // use Serial.list()[x] to choose correct COM port for Arduino
    myPort = new Serial(this, Serial.list()[0], 9600);

    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');

    // set initial background color:
    background(0);
    
    // draw bounding boxes for graphs:
    stroke(255);
    strokeWeight(3);
    noFill();
    rect(0,0,1199,449);
    rect(0,height/2,1199,449);
   
  }

  void draw () {
    // draw sidebar and scales
    stroke(255);
    fill(255);
    rect(0,0,200,height);
    
    textFont(f,25);
    fill(0);
    text("2 g",125,1*height/12);
    text("1 g",125,2*height/12);
    text("0 g",125,3*height/12);
    text("-1 g",125,4*height/12);
    text("-2 g",125,5*height/12);
    
    text("2 g",125,7*height/12);
    text("1 g",125,8*height/12);
    text("0 g",125,9*height/12);
    text("-1 g",125,10*height/12);
    text("-2 g",125,11*height/12);
    
    // for the first accelerometer
    // draw line connecting data points
    stroke(#ffffff);
    strokeWeight(1);
    noFill();
    line(xPos-1, height/2 - prevZ1, xPos, height/2 - Z1_scaled);
    
    // print current acceleration
    textFont(f,25);
    fill(0);
    text("Accel 1:",10,height/2-10);
    text(Z1,100,height/2-10);
    text('g',175, height/2-10);
    
    // for the second accelerometer
    // draw line connecting data points
    stroke(#ffffff);
    strokeWeight(1);
    noFill();
    line(xPos-1, height - prevZ2, xPos, height - Z2_scaled);
    
     // print current acceleration
    textFont(f,25);
    fill(0);
    text("Accel 2:",10,height/2+20);
    text(Z2,100,height/2+20);
    text('g',175, height/2+20);
    
    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 200;
      background(0);
      
      stroke(255);
      noFill();
      rect(0,0,1199,449);
      rect(0,height/2,1199,449);
      
      // draw sidebar and scale
      stroke(255);
      fill(255);
      rect(0,0,200,height);
      
    } else {
      // increment the horizontal position:
      xPos++;
    }
  }

  void serialEvent (Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      
      // store past acceleration points
      prevZ1 = Z1_scaled;
      prevZ2 = Z2_scaled;
      
      // split the string at the semicolons
      String[] arduino_strings = split(inString, ';');
      Z1 = float(arduino_strings[0]);
      Z2 = float(arduino_strings[1]);
      
      //cap bottom graph at +3g so it stays in its window
      
      if (Z2 >= 3) {
        Z2 = 3;
      }
      
      // print to processing window
      print("Z1:");
      println(Z1);
      print("Z2:");
      println(Z2);
      println();
      
      // map acceleration value to graph height
      Z1_scaled = map(Z1,-3,3,0,height/2);
      Z2_scaled = map(Z2,-3,3,0,height/2);
      
    }
  }