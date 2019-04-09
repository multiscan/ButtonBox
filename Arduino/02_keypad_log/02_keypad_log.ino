#include <Keypad.h>
//#include <SoftwareSerial.h>
// http://sankios.imediabank.com/serial-nodemcu-and-arduino
// ================================================ Setup Keypad
const byte ROWS = 4; //four rows
const byte COLS = 4; //three columns
char keys[ROWS][COLS] = {
  {'1', '2', '3', '4'},
  {'5', '6', '7', '8'},
  {'9', 'A', 'B', 'C'},
  {'D', 'E', 'F', 'G'}
};
byte rowPins[ROWS] = {2,3,4,5};   //connect to the row pinouts of the keypad
byte colPins[COLS] = {6,7,8,9}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

// ================================================ Setup Serial
//SoftwareSerial mySerial(2, 3); // RX, TX

void setup(){
  Serial.begin(9600);
  Serial.println("Ciao");
}

void loop(){
  char key = keypad.getKey();
  if (key != NO_KEY){
    Serial.println(key);
  }
}
