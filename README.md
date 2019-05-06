# SDCC MSX VDP TMS9918A Functions Library (object type)

Version: 1.2 (4 May 2019)

Author: mvac7/303bcn

Architecture: MSX

Format: C Object (SDCC .rel)

Programming language: C

WEB:
 
mail: mvac7303b@gmail.com


## Sorry! This text is pending correction of the English translation


### History of versions:
- v1.2 ( 4 May 2019) << Current version >>
- v1.1 (25 April 2019) 
- v1.0 (14 February 2014) Initial version


## Introduction

Open Source library with basic functions to work with the TMS9918A/28A/29A video 
processor.

It does not use the MSX BIOS, so it is suitable for creating applications for 
MSXDOS. 

Use them for developing MSX applications using Small Device C Compiler (SDCC).

This package includes an application for test and learning purposes.



## Notes about operation

It is important to know that the SCREEN function does not behave exactly like 
the functions of the BIOS with the same purpose (CHGMOD, INITXT, INIGRP, etc.).
SCREEN does not clean the entire VRAM and does not set the patterns from the MSX 
font in text modes. This function changes to the indicated screen mode, writes 
to the registers of the VDP the same configuration of the different tables used 
in the MSX and fill the Name Table and the Sprite Attribute Table with de 0 
value.

It is also necessary to know that in the case of graphic mode 2 (screen 2), the 
table of names will not be initialized, with consecutive values (normally used 
to display a graphic without the use of repeated tiles).

Due to the fact that the VDP registers can not be consulted, the writing of the 
values of these has been included in the system variables used by the MSX. In 
the case of wanting to adapt this library to another computer, they would have 
to be deleted or placed in the memory area that is available.

The COLOR function incorporates the value for the ink but does not produce any 
effect, since this value is used by the BIOS to initialize the color table in 
the screen start routines. This function writes the value for background and 
border of the screen in register 7 of the VDP. In screen 0, the background color 
changes the color of the ink and the color of the border changes the background.




## Acknowledgments
  
Thanks for Info & help, to:

* Avelino Herrera > http://msx.atlantes.org/index_es.html
* Nerlaska > http://albertodehoyonebot.blogspot.com.es
* Fubu > http://www.gamerachan.org/fubu/
* Marq/Lieves!Tuore > http://www.kameli.net/lt/
* Sapphire/Z80ST > http://z80st.auic.es/
* Pentacour > http://pentacour.com/
* JamQue/TPM > http://www.thepetsmode.com/
* Andrear > http://andrear.altervista.org/home/msxsoftware.php
* Konamiman > https://www.konamiman.com
* MSX Assembly Page > http://map.grauw.nl/resources/msxbios.php
* Portar MSX Tech Doc > http://nocash.emubase.de/portar.htm
* MSX Resource Center > http://www.msx.org/
* Karoshi MSX Community > http://karoshi.auic.es/
* BlueMSX >> http://www.bluemsx.com/
* OpenMSX >> http://openmsx.sourceforge.net/
* Meisei  >> ?



## Requirements

* Small Device C Compiler (SDCC) v3.6 http://sdcc.sourceforge.net/
* Hex2bin v2.2 http://hex2bin.sourceforge.net/ 



## Functions

* void SCREEN(char mode) - Sets the display mode of the screen.
* void SetSpritesSize(char size) - Set size type for the sprites. (0=8x8; 1=16x16)
* void SetSpritesZoom(char zoom) - Set zoom type for the sprites. (0=x1; 1=x2)
* void CLS() - Clear Screen. Fill in 0, all Name Table.
* void ClearSprites() - Initialises the sprite attribute table.
* void COLOR(char ink, char BG, char border) - Put the background and foreground colors.
* void VPOKE(unsigned int VRAMaddr, char value) - Writes a byte to the video RAM.
* char VPEEK(unsigned int VRAMaddr) - Reads data from the video RAM.
* void FillVRAM(unsigned int VRAMaddr, unsigned int size, char value) - Fill a large area of the VRAM of the same byte.
* void CopyToVRAM(unsigned int RAMaddr, unsigned int VRAMaddr, unsigned int size) - Block transfer from memory to VRAM.
* void CopyFromVRAM(unsigned int VRAMaddr, unsigned int RAMaddr, unsigned int size) - Block transfer from VRAM to memory.
* void SetVDP(char register, char value) - Writes a value in VDP registers.
