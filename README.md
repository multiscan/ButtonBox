# ButtonBox
A programmable button box project using Arduino and NodeMCU combined

## Description
The idea is to combine the capacities of an Arduino Micro with those
of a NodeMCU 8266 for building a programmable button box. Here is
what we take from the two worlds:
 - large number of input ports (Arduino)
 - USB keyboard emulation (Arduino)
 - Easy to program (Node)
 - WiFi (Node)
 - Screen (Node)

 **Note** that most of the code for the NodeMCU is taken
 from [Zuzu59 repository](zuzu59)

#### The loop:
 - Arduino listen for a button to be pressed;
 - Sends a message via (software) serial port to the NodeMCU;
 - NodeMCU translate the button code into a string;
 - NodeMCU sends the string back to Arduino via serial port;
 - Arduino forwards the string to the computer as if it were
   typed into a keyboard;

#### Extra:
A simple web interface let the user interact with NodeMCU and change
the correspondence between key press and output string.
Several programs can be stored and possibly selected with a dial with
visual feedback on the oled screen.

## Progress
This repo is intended as a progress log. Therefore it will contain a
lot of code that will not be used in the final version.

### Firt step
First step was to enable testing of the two modules independently.
This can be done with the help of the serial to usb module that has
the following pin diagram.

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

Therefore, later I expect to connect (TO BE CONFIRMED).
 - Arduino 12 with NodeMCU d7
 - Arduino 11 with NodeMCU d8

Once connected, we can see the other side of the serial connection
from the computer using a command like the following:

```
screen /dev/cu.wchusbserial1410 4800
```

where the device needs to be adapted to the situation (on my laptop
the USB port on the left and the one on the right tend to
take `/dev/cu.wchusbserial1420`
and `/dev/cu.wchusbserial1410`
respectively).

Note that [analog pins are also digital pins][apalsodp]. Therefore they can also be used for
the serial link or for buttons.

### Directories
 - `{Arduino,NodeMCU}/01_minimal_serial` is a simple ping/pong
   script taking input from the serial port and sending a reply;
 - `Arduino/02_keypad_log` is a program that detects a button
   press and logs it on the standard serial port;
 - `Arduino/03_keypad_serial_log` is similar to 02 but sends the
   info about the pressed button also to the other serial port
   (the one that is supposed to be connected to the NodeMCU);
 - `Arduino/03_keypad_encode` a more complex version of 03 where
   arduino waits for a full reply from Node and prints the answer
   to the standard console;
 - `{Arduino,NodeMCU}/04_keypad_encode` a variation of the previous one trying
   to understand why we get extra chars. Turns out, it was the standard
   print of Node that goes to the serial port too. There two options:
   1. remove all prints (cumbersome and sad);
   2. [redirect][stdoutredirection] output somewhere else (or just dev-null it
      when serial port is active)
 - `{Arduino,NodeMCU}/05_encode_keyboard` very first working prototype: Arduino
   sends a message with the keypad number (one byte), NodeMCU reply with the
   number in english text format, Arduino send it to the computer using the
   [keyboard library][kblib]

### Code
Buttons can be mapped to various types of input for the keyboard:
 - **Single Key** key stroke for a _printable_ character;
 - **Special Key** a key stroke for a _non printable_ character (_e.g._ `ESC` key);
 - **Modifier Key**;
 - **String** (sequence of characters possibly followed by a _return_);
 - **Pause**

We need a codec to encode all this that can be easily generated on the gui and
also parsed on the arduino.

##### Use sort of brackets ?
```
  <SpecialChar or Modifier Name> (more than one char)
  <[ModifierCharName]>
  <K> type char K
  <_._>  <_.._>  <_..._>  short, medium, long pause
  <> release all
  "string"
```

##### Or first byte as a switch ?

May be easier if for each key we have a given number of code _lines_. Each line
contains a  first byte for selcting the type of message and the message itself.
There will be two type of messages: _text_ for sending full strings with
Arduino's `keyboard.println()`, and _key_ for sending simple key
combinations like `CTRL-A`.  We need multiple _lines_ because tasks might
require a sequence of key combinations possibly mixed with text. For example,
the task _write something into the chat_ requires first to send a combination
for activating the chat and then to type the text into the chat itself.

The messages will always be in the form of a null (`"\0"`) terminated string where the first byte is either "T" or "K" (for _text_ and _key_ message respectively). The rest of the string will be treated as follow:
* _text_ string is sent unchanged with `keyboard.print()`
* _key_ string is split into substrings (separator to be defined). If substring is one char long, then it is interpreted as standard printable char, while if it is two bytes it is interpreted as hex code for [Keyboard Special keys][kbsk].

### GUI
In order to preserve memory, logic should be moved to JS with very simple
HTTP rest api. Programs will be stored to file (e.g. prog_01.json).
 - list programs: just send a list of json files
 - post(data)      => Create new program, return index of new program
 - get(program id) => Read program with given id
 - put(id, data)   => Update program with given id (overwrite file);
 - (?) delete(id)  => Delete program with given id


## Links
##### NodeMCU and Arduino
 - Zuzu's [notes][nodeMCUmsss] about NodeMCU (in french);
 - Zuzu's repository and [repository][zuzu59] about NodeMCU;
 - Arduino keyboard [library][kblib] and [special keys table][kbsk];
 - There is also a software serial lib for [NodeMCU][ss_nodemcu], not only for [Arduino](ss_arduino)

 [nodeMCUmsss]: https://docs.google.com/document/d/1q64uK3IMOgEDdKaIAttbYuFt4GuLQ06k3FLeyfCsWLg/
 [zuzu59]: https://github.com/zuzu59/NodeMCU_Lua
 [kblib]: https://www.arduino.cc/reference/en/language/functions/usb/keyboard/
 [kbsk]: https://www.arduino.cc/reference/en/language/functions/usb/keyboard/keyboardmodifiers/
 [ss_arduino]: https://www.arduino.cc/en/Reference/softwareSerial
 [ss_nodemcu]: https://github.com/SlashDevin/NeoSWSerial

 [stdoutredirection]: https://nodemcu.readthedocs.io/en/master/modules/node/#nodeoutput
 [apalsodp]: http://forum.arduino.cc/index.php?topic=296083.0

##### Assetto Corsa and applications
 - How to [assign][joy2keytut] Keyboard functions to Button box with JoyToKey;
 - Assetto Corsa [chat app][chatapp] for multiplayer;

 [joy2keytut]: https://www.youtube.com/watch?v=kbuyXz9sNw0
 [chatapp]: https://www.drivingitalia.net/index.php?/forums/topic/66921-xychat-029-chat-app-for-multiplayer/
