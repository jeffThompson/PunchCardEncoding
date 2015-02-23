
import processing.pdf.*;

/*
PUNCH CARD ENCODING
 Jeff Thompson | 2015 | www.jeffreythompson.org
 
 Encoding is based on IBM Model 026 keypunch, a "workhorse
 of much early work in business data processing" [1]. Used extensively
 from July 1949 through the early 1970s. This program uses
 the FORTRAN character set.
 
 VIABLE SYMBOLS
 0-9, A-Z, +-/='.)$*,(
 
 I have also added ";", which is not part of the FORTRAN set, but
 let's us write some Processing sketches :)
 
 REFERENCES && USEFUL BITS:
 1. http://homepage.cs.uiowa.edu/~jones/cards/codes.html
 2. http://www.computercollector.com/cgi-bin/exec/compcol/menu-st.cgi?directory=/archive/ibm/pcdpp/card
 3. http://en.wikipedia.org/wiki/Punched_card#IBM_80_column_punched_card_format
 4. http://www.columbia.edu/cu/computinghistory/fisk.pdf
 
 */


boolean debugMessage =         false;
boolean drawNumbersAndGuides = true;

//String message =               "println('Hello, world.');";
String message = "2.7GHZ INTEL CORE I7, 16GB 1600MHZ DDR3, NVIDIA GEFORCE GT 650M 1024 MB, 15IN";
String outputFilename =        "HelloWorld.pdf";

int   ppi =         72;

float rightMargin = 0.2125 * ppi;
float topMargin =   0.18 * ppi;

int   numCols =     80;
int   numRows =     12;

float colWidth =    (6.9375 * ppi) / numCols;
float rowHeight =   0.25 * ppi;

int   cardWidth =   int(7.375 * ppi);
int   cardHeight =  int(3.25 * ppi);

float punchWidth =  0.06 * ppi;
float punchHeight = 0.1238 * ppi;

PFont rowLabel;
PShape card;

char[] acceptableChars = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '/', '=', '\'', '.', ')', '$', '*', '(', ';', ','
};


void setup() {

  // let us know what's happening
  println("PUNCH CARD ENCODING");
  if (debugMessage) {
    println("Encoding all possible characters:");
    for (int i=0; i<acceptableChars.length; i++) {
      print(acceptableChars[i] + " ");
    }
  }
  else {
    if (message.length() > 80) {
      println("Message too long, trimming to 80 chars...");
      message = message.substring(0, 80);
    }
    if (message.contains(";")) {
      println("Message contains non-standard characters - using anyway...");
    }
    println("Encoding: \"" + message + "\"");
  }

  // setup
  size(int(11 * ppi), int(8.5 * ppi));
  beginRecord(PDF, outputFilename);
  background(255);
  strokeWeight(0.5);
  translate((width-cardWidth)/2, (height-cardHeight)/2);

  // font setup
  rowLabel = createFont("Helvetica", 4);
  textFont(rowLabel, 4);

  // overall rect and "ok notch"
  card = loadShape("Card.svg");
  shape(card, 0, 0);

  // numbers and guides (for debugging)
  if (drawNumbersAndGuides) {
    fill(0, 50);
    noStroke();
    for (int col=0; col<numCols; col++) {
      float x = rightMargin + (col * colWidth) + 1;
      float y = topMargin + 6;
      text(col + 1, x, y);
    }
    for (int row=2; row<numRows; row++) {
      for (int col=0; col<numCols; col++) {
        float x = rightMargin + (col * colWidth) + 1;
        float y = topMargin + (row * rowHeight) + 6;
        text(row - 2, x, y);
      }
    }
  }

  // punch some holes!
  noFill();
  stroke(0);
  if (debugMessage) {
    for (int i=0; i<acceptableChars.length; i++) {
      encodePunch(acceptableChars[i], i);
    }
  } else {
    for (int i=0; i<message.length (); i++) {
      encodePunch(message.charAt(i), i);
    }
  }

  // save and done
  println("Saving PDF...");
  endRecord();
  println("\nDONE!");
}

