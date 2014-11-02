import processing.serial.*;
Serial myPort;
PFont font;


int numValues = 4;    // number of input values or sensors
// * change this to match how many values your Arduino is sending *

float[] values   = new float[numValues];
int[]   min      = new int[numValues];
int[]   max      = new int[numValues];
color[] valColor = new color[numValues];

float partH;          // partial screen height
float zeroDegrees = radians(-90);

int xPos = 1;         // horizontal position of the graph

float temp = 0;
float light = 0;
float humidity = 0;
float sound = 0;
int  m = 0;
int soundMinutes =0;

void setup() {
  size(800, 600);
  partH = height / numValues;

  // List all the available serial ports:
  printArray(Serial.list());
  // First port [0] in serial list is usually Arduino, but *check every time*:
  myPort = new Serial(this, Serial.list()[3], 38400);
  // don't generate a serialEvent() until you get a newline character:
  myPort.bufferUntil('\n');
  smooth();
  textSize(10);
  noStroke();


  // initialize:
  // *edit these* to match how many values you are reading, and what colors you like 
  values[0] = 0;
  min[0] = 0;
  max[0] = 1023;  // 8-bit (0-255) example
  valColor[0] = color(255, 0, 0); // red

  values[1] = 0;    
  min[1] = 0;
  max[1] = 1023; // 10-bit (0-1023) example
  valColor[1] = color(0, 255, 0); // green

  values[2] = 0;
  min[2] = 0;
  max[2] = 100;    // 1-bit (0-1) example, e.g. a digital switch 
  valColor[2] = color(0, 0, 255); // blue

  // example for adding a 4th value:
  values[3] = 0;
  min[3] = 0;
  max[3] = 100;  // custom range example 
  valColor[3] = color(255, 0, 255); // purple

  font = loadFont("Metrophobic-24.vlw");
  textFont(font, 12);
}


void draw() {
  background(250);
  //showValues(50, 50); //this is the box with the raw data

  if (sound > 30) {
    m+=1.5;
    if (m >= 6000 ) {
      m=0;
      soundMinutes++;
    }
  }

  if (hour() == 0 && minute() ==0) { //reset at midnight
    m=0;
    soundMinutes = 0;
  }

  float thickness = map(sound, 30, 900, 33, 50);
  drawClock(thickness);
  drawArc(240, map(temp, 0, 50, 0, 360), red, thickness, temp+"°C");
  drawArc(300, map(humidity, 0, 100, 0, 360), eggplant, thickness, humidity+"%");
  drawArc(360, map(light, 0, 1023, 0, 360), purple, thickness, int(map(light, 0, 1023, 0, 100))+" Lumons");
  drawArc(420, map(m, 0, 6000, 0, 360), blue, thickness, m/100+" sound seconds");

  //draw the tally of sound minutes for the day
  textAlign(CENTER);
  fill(0);
  if (soundMinutes == 1) {
    text(soundMinutes+" Sound Minute Today", width/2, height -30);
  } else {
    text(soundMinutes+" Sound Minutes Today", width/2, height -30);
  }
  drawLabel(10, height-60);
}


void serialEvent(Serial myPort) { 
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  //print("raw: \t" + inString);        // < - uncomment this to debug serial input from Arduino

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);

    // split the string on the delimiters and convert the resulting substrings into an float array:
    //int[] valuesTemp = int(splitTokens(inString, ", \t"));
    values = float(splitTokens(inString, ", \t"));    // delimiter can be comma space or tab

    // if the array has at least the # of elements as your # of sensors, you know
    // you got the whole data packet.  Map the numbers and put into the variables:
    if (values.length >= numValues) {
      sound = values[0];
      light = values[1];
      humidity = values[2];
      temp = values[3];
    }
  }
}

//function to draw the value key - useful for debuging
void showValues(int xpos, int ypos) {
  pushMatrix();
  translate(xpos, ypos);
  fill(240);
  noStroke();
  rect(0, 0, 150, 90);
  fill(0);
  textAlign(LEFT);
  text("Sound: "+sound, 10, 20);
  text("Light: "+light, 10, 40);
  text("Temp: "+temp+"°C", 10, 60);
  text("Humidity: "+humidity+"%", 10, 80);
  fill(255, 0, 0);
  rect(120, 90, 12, map(sound, 0, 1023, 0, 90)*-1);
  fill(0, 255, 0);
  rect(135, 90, 12, map(light, 0, 1023, 0, 90)*-1);
  popMatrix();
}

//helper function for drawing arcs
void drawArc(int size, float end, int strokeColour[], float thickness, String value) {
  noFill();
  strokeCap(SQUARE);
  strokeWeight(thickness);
  stroke(strokeColour[0], strokeColour[1], strokeColour[2]);
  arc(width/2, height/2, size, size, zeroDegrees, radians(end - 90), OPEN);
  fill(255);
  if (end < 6) {
    fill(strokeColour[0], strokeColour[1], strokeColour[2]);
  }
  textAlign(LEFT);
  text(value, width/2+5, (height/2-size/2)+(thickness/5));
}

//draw the clock with hour logic
void drawClock(float thickness) {
  if (hour() < 12) {
    drawArc(60, map(hour(), 0, 12, 0, 360), green, thickness, hour()+"h");
  } else {
    drawArc(60, map(hour()-12, 0, 12, 0, 360), green, thickness, hour()-12+"h");
  }
  drawArc(120, map(minute(), 0, 60, 0, 360), yellow, thickness, minute()+"m");
  drawArc(180, map(second(), 0, 60, 0, 360), orange, thickness, second()+"s");
}

void drawLabel(int xpos, int ypos) {
  pushMatrix();
  translate(xpos, ypos);
  fill(250, 100);
  noStroke();
  rect(0, 0, 300, 200);
  fill(0);
  textAlign(LEFT);
  text("UTS - Visualising Information", 20, 20);
  text("RADAR", 20, 35);
  popMatrix();
}

