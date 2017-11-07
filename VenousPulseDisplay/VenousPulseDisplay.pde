// Modification to existing example code (credited below) for visualizing accelerometer data
// Angela Zhang and Nick Calafat
// BIOE 421, Rice University
// 11.2.2017
// 11.6.2017 updates: split data from Arduino string to acceleration values for each accelerometer, plot each in its own graph

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

  Serial myPort;        // The serial port
  int xPos = 1;         // horizontal position of the graph
  float inByte = 0;
  float prevZ1 = 0;
  float prevZ2 = 0;
  float rawZ1 = 0;
  float rawZ2 = 0;
  int graphHeight = 900;
  int graphWidth = 1200;

  void setup () {
    // set the window size:
    size(1200,900);
    
    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    
    // I know that the first port in the serial list on my Mac is always my
    // Arduino, so I open Serial.list()[0].
    // Open whatever port is the one you're using.
    myPort = new Serial(this, Serial.list()[0], 9600);

    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');

    // set initial background:
    background(0);
    
    //draw bounding boxes for graphs:
    stroke(255);
    noFill();
    rect(0,0,1199,449);
    rect(0,height/2,1199,449);
  }

  void draw () {
    // draw line for accel 1:
    stroke(#ffffff);
    strokeWeight(1);
    noFill();
    line(xPos-1, height/2 - prevZ1, xPos, height/2 - rawZ1);
    
    // draw line for accel 2:
    stroke(#ffffff);
    strokeWeight(1);
    noFill();
    line(xPos-1, height - prevZ2, xPos, height - rawZ2);
    
    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      background(0);
      
      stroke(255);
      noFill();
      rect(0,0,1199,449);
      rect(0,height/2,1199,449);
      
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
      prevZ1 = rawZ1;
      prevZ2 = rawZ2;
      
      // split the string at the semicolons
      String[] arduino_strings = split(inString, ';');
      rawZ1 = float(arduino_strings[0]);
      rawZ2 = float(arduino_strings[1]);
      print("Z1:");
      println(rawZ1);
      print("Z2:");
      println(rawZ2);
      println();
      
      // map to graph height
      rawZ1 = map(rawZ1,-3,3,0,height/2);
      rawZ2 = map(rawZ2,-3,3,0,height/2);
      
      // convert to an int and map to the screen height:
      //prevZ = inByte;
      //inByte = float(inString);
      //println(inByte);
      //inByte = map(inByte, 0, 1023, height/2, height);
      //rawZ = inByte;
    }
  }