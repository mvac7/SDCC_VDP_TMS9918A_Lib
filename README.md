# VDP TMS9918A MSX SDCC Library (fR3eL Project)

```
Author: mvac7 [mvac7303b@gmail.com]
Architecture: MSX
Format: C Object (SDCC .rel)
Programming language: C and Z80 assembler
```



### Sorry! This text is pending correction of the English translation



## Description

Open Source library with basic functions to work with the TMS9918A/28A/29A video processor.

It does not use the MSX BIOS, so it can be used to develop ROM applications such as MSX-DOS.

Use them for developing MSX applications using [Small Device C Compiler (SDCC)](http://sdcc.sourceforge.net/) cross compiler.

In the source code (\examples), you can find applications for testing and learning purposes.

This library is part of the [MSX fR3eL Project](https://github.com/mvac7/SDCC_MSX_fR3eL).

Enjoy it!



## History of versions

* v1.3 (23 July  2019) COLOR function improvements
* v1.2 ( 4 May   2019) 
* v1.1 (25 April 2019) 
* v1.0 (14 February 2014) Initial version



## Requirements

* Small Device C Compiler (SDCC) v3.9 http://sdcc.sourceforge.net/
* Hex2bin v2.5 http://hex2bin.sourceforge.net/ 



## Acknowledgments
  
I want to give a special thanks to all those who freely share their knowledge with the MSX developer community.

* Avelino Herrera > [WEB](http://msx.atlantes.org/index_es.html)
* Nerlaska > [Blog](http://albertodehoyonebot.blogspot.com.es)
* Marq/Lieves!Tuore > [Marq](http://www.kameli.net/marq/) [Lieves!Tuore](http://www.kameli.net/lt/)
* [Fubukimaru](https://github.com/Fubukimaru) > [Blog](http://www.gamerachan.org/fubu/)
* Andrear > [Blog](http://andrear.altervista.org/home/msxsoftware.php)
* Ramones > [MSXblog](https://www.msxblog.es/tutoriales-de-programacion-en-ensamblador-ramones/) - [MSXbanzai](http://msxbanzai.tni.nl/dev/faq.html)
* Sapphire/Z80ST > [WEB](http://z80st.auic.es/)
* Fernando García > [youTube](https://www.youtube.com/user/bitvision)
* Eric Boez > [gitHub](https://github.com/ericb59)
* MSX Assembly Page > [WEB](http://map.grauw.nl/resources/msxbios.php)
* Portar MSX Tech Doc > [WEB](http://nocash.emubase.de/portar.htm)
* MSX Resource Center > [WEB](http://www.msx.org/)
* Karoshi MSX Community (RIP 2007-2020)
* BlueMSX emulator >> [WEB](http://www.bluemsx.com/)
* OpenMSX emulator >> [WEB](http://openmsx.sourceforge.net/)
* Meisei emulator >> ?



## Functions

* void **SCREEN**(char mode) - Sets the display mode of the screen.
* void **SetSpritesSize**(char size) - Set size type for the sprites. (0=8x8; 1=16x16)
* void **SetSpritesZoom**(char zoom) - Set zoom type for the sprites. (0=x1; 1=x2)
* void **CLS**() - Clear Screen. Fill in 0, all Name Table.
* void **ClearSprites**() - Initialises the sprite attribute table.
* void **COLOR**(char ink, char BG, char border) - Put the ink, background and foreground colors.
* void **VPOKE**(unsigned int VRAMaddr, char value) - Writes a byte to the video RAM.
* char **VPEEK**(unsigned int VRAMaddr) - Reads data from the video RAM.
* void **FillVRAM**(unsigned int VRAMaddr, unsigned int size, char value) - Fill a large area of the VRAM of the same byte.
* void **CopyToVRAM**(unsigned int RAMaddr, unsigned int VRAMaddr, unsigned int size) - Block transfer from memory to VRAM.
* void **CopyFromVRAM**(unsigned int VRAMaddr, unsigned int RAMaddr, unsigned int size) - Block transfer from VRAM to memory.
* void **SetVDP**(char register, char value) - Writes a value in VDP registers.



## Notes about operation

It is important to know that the SCREEN function does not behave exactly like 
the functions of the BIOS with the same purpose (CHGMOD, INITXT, INIGRP, etc.).
SCREEN does not clean the entire VRAM and does not set the patterns from the MSX font in text modes. 
This function changes to the indicated screen mode, writes to the registers of the VDP the same configuration of the different tables used 
in the MSX and fill the Name Table and the Sprite attribute table with the value 0 and the Y position for hiding (209).

It is also necessary to know that in the case of graphic mode 2 (screen 2), the table of names will not be initialized, 
with consecutive values (normally used to display a graphic without the use of repeated tiles).

Due to the fact that the VDP registers can not be consulted, the writing of the values of these has been included in the system variables used by the MSX. 
In the case of wanting to adapt this library to another computer, they would have to be deleted or placed in the memory area that is available.

The colors of ink and background of the COLOR function are only useful in text mode, 
since the BIOS uses these values to initialize the color table in the screen startup routines and this library does not. 
In all other modes it is useful to adjust the border color of the screen.



## Documentation

* Texas Instruments TMS9918A application manual [(PDF)](http://map.grauw.nl/resources/video/texasinstruments_tms9918.pdf)
* Texas Instruments VDP Programmer’s Guide [(PDF)](http://map.grauw.nl/resources/video/ti-vdp-programmers-guide.pdf)
* Texas Instruments TMS9918A VDP by Sean Young [(TXT)](http://bifi.msxnet.org/msxnet/tech/tms9918a.txt)
* 9938 Technical Data Book [(PDF)](http://map.grauw.nl/resources/video/yamaha_v9938.pdf) [(TXT)](http://map.grauw.nl/resources/video/v9938/v9938.xhtml)
* 9958 Technical Data Book [(PDF)](http://map.grauw.nl/resources/video/yamaha_v9958_ocr.pdf)
* Portar Doc Video Display Processor [(WEB)](https://problemkaputt.de/portar.htm#videodisplayprocessor)
