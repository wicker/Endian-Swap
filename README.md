# Endian Swap

An assembly program that uses a stack to receive a Big Endian packet and provide it in Little Endian order. Images are Cygwin Insight.  

ARM/XScale Assembly language program to perform operations on a 52-byte  packet. The first four header bytes are added and the sum compared to  the fifth header byte; if equal, the remaining 48 bytes (written in Big- Endian MSB order) are shuffled so that they are ready to be transferred  on in Little Endian LSB order. The actual receipt and transfer of the packet is ignored. 

Warning: this is coursework released under the "New" BSD license. The course in question requires a signed statement of solo work. If you use my code without attribution, you're not only cheating but in violation of my copright.

Written by Jenner Hanni, Winter 2011. 
See the LICENSE file for copyright details.

<img src="memorydump1-initialization.png">

<img src="memorydump2-reorderbytes.png">

<img src="memorydump3-littleendianresult.png">


