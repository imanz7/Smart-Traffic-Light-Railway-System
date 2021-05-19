# Smart-Traffic-Light-Railway-System
Programmed a traffic light railway system with analog sensor to detect the presence of train. The value obtained from the range of 0 to 1023 is analyzed and directed which lane will be activated, and displayed on serial monitor of Atmel Studio.

Serial monitor indication:
H - 1st lane activated
L - 2nd lane activated
*Serial monitor can be displayed through other platforms, however output should be as expected.

Note that, for this system, since only focusing on programming (not mechanical part), only LEDs being used as indication the respective lane has been activated.

Components used:
- Arduino UNO (can be replace by other microcontrollers, however coding will varies)
- Any analog sensor (Tested: Light Dependent Resistor (LDR), potentiometer)
- 2 LEDs as indication of activation of lane
