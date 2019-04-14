#include <Keypad.h>
#include <Keyboard.h>
#include <SoftwareSerial.h>

// ================================================ Setup Keypad
const byte ROWS = 4; //four rows
const byte COLS = 4; //four columns
// char keys[ROWS][COLS] = {
//   {'0', '1', '2', '3'},
//   {'4', '5', '6', '7'},
//   {'8', '9', 'A', 'B'},
//   {'C', 'D', 'E', 'F'}
// };
char keys[ROWS][COLS] = {
  { 1,  2,  3,  4},
  { 5,  6,  7,  8},
  { 9, 10, 11, 12},
  {13, 14, 15, 16}
};
byte rowPins[ROWS] = {2,3,4,5}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {6,7,8,9}; //connect to the column pinouts of the keypad

// const byte ROWS = 4;
// const byte COLS = 8;
// char keys[ROWS][COLS] = {
//   { 1,  2,  3,  4,  5,  6,  7,  8},
//   { 9, 10, 11, 12, 13, 14, 15, 16},
//   {17, 18, 19, 20, 21, 22, 23, 24},
//   {25, 26, 27, 28, 29, 30, 31, 32}
// };
// byte rowPins[ROWS] = {2,3,4,5};             //connect to the row pinouts of the keypad
// byte colPins[COLS] = {6,7,8,9,10,11,12,13}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

// ================================================ Setup Serial
// TODO: move serial to analog pins (can be used as digital)
//       see http://forum.arduino.cc/index.php?topic=296083.0
//       SoftwareSerial mySerial(A4,A3); // Rx,Tx
SoftwareSerial node(11, 12); // RX, TX
String nodeMessage;
//nodeMessage.reserve(32); 

// =================================================
// Send message about pressed key on softwar serial link
void setup(){
  // setup console
  Serial.begin(9600);
  Serial.println("Ciao");

  Keyboard.begin();

  // set data rate for the SoftwareSerial port
  node.begin(9600);
}

void loop(){
  node.listen();
  char key = keypad.getKey();
  if (key != NO_KEY){
    Serial.print("Key pressed: [");
    Serial.print(int(key));
    Serial.println(']');
    // send key to nodeMCU and reset message
    node.write(key);
    nodeMessage = "";
  }
  while (node.available()) {
    byte b = node.read();
    char c = char(b);
//    Serial.print(c);
//    Serial.print("["); Serial.print(b); Serial.print("]  ("); Serial.print(c); Serial.println(")"); 
    if (b == 0) {
      node.read();
      Serial.println();
      Serial.print("Message: ");
      Serial.println(nodeMessage);
      Keyboard.println(nodeMessage);
      nodeMessage = "";
    } else {
      nodeMessage += c;
    }
  }
}
