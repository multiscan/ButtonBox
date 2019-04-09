# ButtonBox
A programmable button box project using Arduino and NodeMCU combined

## Description
The idea is to combine the capacities of an Arduino Micro with those of a NodeMCU 8266 for
building a programmable button box. Here is what we take from the two worlds:
 - large number of input ports (Arduino)
 - USB keyboard emulation (Arduino)
 - Easy to program (Node)
 - WiFi (Node)
 - Screen (Node)

#### The loop:
 - Arduino listen for a button to be pressed;
 - Sends a message via (software) serial port to the NodeMCU;
 - NodeMCU translate the button code into a string;
 - NodeMCU sends the string back to Arduino via serial port;
 - Arduino forwards the string to the computer as if it were typed into a keyboard;

#### Extra:
A simple web interface let the user interact with NodeMCU and change the correspondence between key press and output string. 
Several programs can be stored and possibly selected with a dial with visual feedback on the oled screen.


## Progress
This repo is intended as a progress log. Therefore it will contain a lot of code that will not be used in the final version.

### Firt step
First step was to enable testing of the two modules independently. This can be done with the help of the serial to usb module that has the following pin diagram. 

#### Serial-USB module connection

```
   1 2 3 4
   5 6 7 8


     USB
     USB
```
| Connector | Arduino | NodeMCU |
| --------- | ------- | ------- |
|    4      |    12   |   d8    |
|    5      |    11   |   d7    |
|    8      |   GND   |  GND    |

Therefore, later I expect to connect Arduino 12 with NodeMCU d7 and Arduino 11 with NodeMCU d8 (TO BE CONFIRMED).

Once connected, we can see the other side of the serial connection from the computer using a command
like the following:

```
screen /dev/cu.wchusbserial1410 4800
```

where the device needs to be adapted to the situation (on my laptop the USB port on the left and the one on the right tend to take `/dev/cu.wchusbserial1420` and `/dev/cu.wchusbserial1410` respectively).

### Directories
 - `{Arduino,NodeMCU}/01_minimal_serial` is a siple ping/pong script taking input from the serial port and sending a reply;
 - `Arduino/02_keypad_log` is a program that detects a button press and logs it on the standard serial port;
 - `Arduino/03_keypad_serial_log` is similar to 02 but sends the info about the pressed button also to the other serial port (the one that is supposed to be connected to the NodeMCU);
 - `Arduino/03_keypad_encode` a more complex version of 03 where arduino waits for a full reply from Node and prints the answer to the standard console;
