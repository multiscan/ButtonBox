#include <SoftwareSerial.h>
// http://sankios.imediabank.com/serial-nodemcu-and-arduino

// ================================================ Setup Serial
SoftwareSerial node(10, 11); // RX, TX

void setup() {
  Serial.begin(9600);
  Serial.println("Ciao");

  // set the data rate for the SoftwareSerial port
  node.begin(4800);
}

void loop() {
  //Serial.println("pinging");
  node.println("ping");
  if (node.available()) {
    Serial.write("<- ");
    Serial.write(node.read());
  }
  delay(1000);
}
