# Multifuctional-Calculator
Video Demonstration : https://youtu.be/6S4WbsP6rEY.

I have created a multi functional calculator using Terasic DE-10 lite board Max-10, it is a FPGA board
Field programmable gate array (FPGA) is an array of reconfigurable gates. Using software programming tools, a I can implement designs
on the FPGA using either an HDL or a Verilog. FPGAs are more powerful and more flexible than PLAs for several reasons. They can implement
both combinational and sequential logic. They can also implement multilevel logic functions, whereas PLAs can only implement two-level logic.

The scientific calculator top module input interactions are through two active low push buttons, SW[7:0], and outputs via HEX5 to HEX0. The states of the calculator are encapsulated in 4 bits, for a total of 11 states; 6 selection states(including the "END" state) and 5 committed operation states. KEY0 acts as an operation selection input, each event will cycle to the next state or operation. A more descriptive output of the current state is shown on HEX5 to 3 “A-d-d” for the addition, “Sub” for Substraction , "D1u" for Division , "nnuL" for Multiplication ,“FAC” for factorial, etc.
Upon reaching the wanted operation, a KEY1 event will commit the user to that operation. The 7-Segment display will change to its respective operation configuration and the switches will act as the operand inputs. The respective display will be detailed in each operation’s module section. If a change of operation is needed, the user would push the KEY1 again to go back to the selection states and cycle to the wanted operation.

![image](https://github.com/sidd2423/Multifuctional-Calculator/assets/112332747/449d9802-8307-466e-8a4f-1f5dad8ca039)
