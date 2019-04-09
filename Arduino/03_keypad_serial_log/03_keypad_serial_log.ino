#include <Keypad.h>
#include <SoftwareSerial.h>

// ================================================ Setup Keypad
const byte ROWS = 4; //four rows
const byte COLS = 4; //three columns
char keys[ROWS][COLS] = {
  {'0', '1', '2', '3'},
  {'4', '5', '6', '7'},
  {'8', '9', 'A', 'B'},
  {'C', 'D', 'E', 'F'}
};
byte rowPins[ROWS] = {2,3,4,5};   //connect to the row pinouts of the keypad
byte colPins[COLS] = {6,7,8,9}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

// ================================================ Setup Serial
SoftwareSerial node(10, 11); // RX, TX

// =================================================
// Send message about pressed key on softwar serial link
void setup(){
  // setup console
  Serial.begin(9600);
  Serial.println("Ciao");

  // set data rate for the SoftwareSerial port
  node.begin(4800);
}

void loop(){
  char key = keypad.getKey();
  if (key != NO_KEY){
    Serial.println(key);
    node.println(key);
  }
}
