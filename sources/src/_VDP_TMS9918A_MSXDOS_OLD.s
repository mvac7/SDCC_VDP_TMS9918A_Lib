; ============================================================================== 
;   VDP_TMS9918_MSXBIOS_IS.s                                                            
;   v1.0 (20 january 2014)                                                                      
;   Description                                                              
;     Opensource library for acces to VDP TMS9918
;     using BIOS functions                             
; ============================================================================== 
	.area _DATA


  .area _CODE




;system var
EXPTBL = 0xFCC1
RG0SAV = 0xF3DF   ;#F3DF - #F3E6: vdp registers 0-7


;0xF87F fkeys 160 bytes
SPRITESIZE  = 0xF885 ;(1B) 
SPRITEYBUFF = SPRITESIZE + 1 ;(32B) buffer for visibility controller



;system vars
FORCLR = 0xF3E9 ;Foreground colour
BAKCLR = 0xF3EA ;Background colour
BDRCLR = 0xF3EB ;Border colour 


;BIOS (info by MSX Assembly Page)
;http://map.grauw.nl/resources/msxbios.php
CALSLT = 0x001C ;
DISSCR = 0x0041 ;inhibits the screen display
ENASCR = 0x0044 ;displays the screen
WRTVDP = 0x0047 ;write data in the VDP-register
RDVRM  = 0x004A ;Reads the content of VRAM
WRTVRM = 0x004D ;Writes data in VRAM
SETRD  = 0x0050 ;Enable VDP to read
SETWRT = 0x0053 ;Enable VDP to write
FILVRM = 0x0056 ;fill VRAM with value
LDIRMV = 0x0059 ;Block transfer to memory from VRAM
LDIRVM = 0x005C ;Block transfer to VRAM from memory
CHGMOD = 0x005F ;Switches to given screenmode
CHGCLR = 0x0062 ;Changes the screencolors
CLRSPR = 0x0069 ;Initialises all sprites
INITXT = 0x006C ;Switches to SCREEN 0 (text screen with 40 * 24 characters)
INIT32 = 0x006F ;Switches to SCREEN 1 (text screen with 32*24 characters)
INIGRP = 0x0072 ;Switches to SCREEN 2 (high resolution screen with 256*192 pixels)
INIMLT = 0x0075 ;Switches to SCREEN 3 (multi-color screen 64*48 pixels)
SETTXT = 0x0078 ;Switches to VDP in SCREEN 0 mode
SETT32 = 0x007B ;Switches VDP in SCREEN mode 1
SETGRP = 0x007E ;Switches VDP to SCREEN 2 mode
SETMLT = 0x0081 ;Switches VDP to SCREEN 3 mode
CALPAT = 0x0084 ;Returns the address of the sprite pattern table
CALATR = 0x0087 ;Returns the address of the sprite attribute table
GSPSIZ = 0x008A ;Returns current sprite size
GRPPRT = 0x008D ;Displays a character on the graphic screen
;

CHKNEW = 0x0165 ;Tests screen mode > C-flag set if screenmode = 5, 6, 7 or 8
BIGFIL = 0x016B ;fill VRAM with value (total VRAM can be reached) HL address, BC length, A data
NSETRD = 0x016E ;Enable VDP to read.(with full 16 bits VRAM-address)
NSTWRT = 0x0171 ;Enable VDP to write.(with full 16 bits VRAM-address) 
NRDVRM = 0x0174 ;Reads VRAM like in RDVRM.(with full 16 bits VRAM-address)
NWRVRM = 0x0177 ;Writes to VRAM like in WRTVRM.(with full 16 bits VRAM-address)




;===============================================================================
; screen
; Sets the screen mode.
;
; void screen(char mode)
; ==============================================================================
_SCREEN::
  push IX
  ld   IX,#0
  add  IX,SP

  ld   A,4(IX)
  ld   IX,#CHGMOD
  ld   IY,(EXPTBL-1)
  call CALSLT ;acces to MSX BIOS
  ei
  
  pop  IX
  ret
    
  

;===============================================================================
; color
; Function : Specifies the foreground color, background and area of the edges. 
; Input    : (char) - ink color
;            (char) - background color
;            (char) - border color     
;
; void color(char ink, char background, char border)
;===============================================================================
_COLOR::
  push IX
  ld   IX,#0
  add  IX,SP

  ld   A,4(IX)
  ld   (FORCLR),A
  
  ld   A,5(IX)
  ld   (BAKCLR),A
  
  ld   A,6(IX)
  ld   (BDRCLR),A 
   
  ld   IX,#CHGCLR
  ld   IY,(EXPTBL-1)
  call CALSLT ;acces to MSX BIOS
  ei

  pop  IX
  ret



;===============================================================================
; vpoke
; Function : Writes a byte to the video RAM. 
; Input    : (uint)  - VRAM address
;            (byte) - value 
;
; void vpoke(uint address, byte value)
;===============================================================================
_VPOKE::
  push IX
  ld   IX,#0
  add  IX,SP
  
  ld   L,4(IX)
  ld   H,5(IX)
   
  ld   A,6(IX)
  
  call _WRTVRM
  
  pop  IX
  ret



;===============================================================================
; vpeek
; Function : Reads data from the video RAM. 
; Input    : (uint) - VRAM address
; Output   : (byte) - value
;
; byte vpeek(uint address)
;===============================================================================
_VPEEK::
  push IX
  ld   IX,#0
  add  IX,SP
  
  ld   L,4(IX)
  ld   H,5(IX) 
  
  call _RDVRM
  
  ld   L,A
  
  pop  IX
  ret



;===============================================================================
; fillVRAM                                
; Function : Fill a large area of the VRAM of the same byte.
; Input    : (uint) - VRAM address
;            (uint) - length
;            (byte) - value
;
; void fillVRAM (uint vaddress, uint size, byte value)
;===============================================================================
_FillVRAM::
  push IX
  ld   IX,#0
  add  IX,SP
      
  ld   L,4(IX) ; vaddress
  ld   H,5(IX)
    
  ld   C,6(IX) ;length
  ld   B,7(IX)
    
  ld   A,8(IX) ;value
  
  call _FILVRM
    
  pop  IX
  ret



;===============================================================================
; copyToVRAM
; Function : Block transfer from memory to VRAM
; Input    : (uint) - source RAM address 
;            (uint) - target VRAM address
;            (uint) - length
;
; void copyToVRAM(uint address, uint vaddress, uint length)
;===============================================================================
_CopyToVRAM::
  push IX
  ld   IX,#0
  add  IX,SP 

  ld   L,4(IX) ;ram address 
  ld   H,5(IX)
      
  ld   E,6(IX) ;vaddress
  ld   D,7(IX)
  
  ld   C,8(IX) ;length
  ld   B,9(IX)
   
  call _LDIRVM
  
  pop  IX
  ret



;===============================================================================
; copyFromVRAM
; Function : Block transfer from VRAM to memory.
; Input    : (uint) - source VRAM address
;            (uint) - target RAM address
;            (uint) - length
;
;void copyFromVRAM(uint vaddress, uint address, uint length)
;===============================================================================
_CopyFromVRAM::
  push IX
  ld   IX,#0
  add  IX,SP
      
  ld   L,4(IX) ;vaddress
  ld   H,5(IX)
  
  ld   E,6(IX) ;address 
  ld   D,7(IX)     
  
  ld   C,8(IX) ;length
  ld   B,9(IX)
  
  call _LDIRMV
    
  pop  IX
  ret
  


;===============================================================================
; setVDP
; Function : writes a value in VDP reg.
; Input    : (byte) - VDP reg
;            (byte) - value
;
;void setVDP(byte, byte)
;===============================================================================
_SetVDP::
  push IX
  ld   IX,#0
  add  IX,SP

  ld   C,4(IX) ;VDP reg    
  ld   B,5(IX)
  
  ;call WRTVDP
  ld   IX,#WRTVDP
  ld   IY,(EXPTBL-1)
  call CALSLT ;acces to MSX BIOS
  ei
  
  pop  IX
  ret



;===============================================================================
; _WRTVRM                                
; Function : 
; Input    : A  - value
;            HL - VRAM address
;===============================================================================
_WRTVRM::
  ld   IX,#WRTVRM
  ld   IY,(EXPTBL-1)
  call CALSLT ;acces to MSX BIOS
  ei
  
  ret



;===============================================================================
; _RDVRM                                
; Function : 
; Input    : HL - VRAM address
; Output   : A  - value
;===============================================================================
_RDVRM::
  ld   IX,#RDVRM
  ld   IY,(EXPTBL-1)
  call CALSLT ;acces to MSX BIOS
  ei

  ret



;===============================================================================
; _FILVRM                                
; Function : Fill a large area of the VRAM of the same byte.
; Input    : A  - value
;            DE - Size
;            HL - VRAM address
;===============================================================================
_FILVRM::
  ld   IX,#FILVRM
  ld   IY,(EXPTBL-1)
  call CALSLT ;acces to MSX BIOS
  ei
  
  ret


;===============================================================================
; _LDIRVM
; Function : 
;    Block transfer from memory to VRAM 
; Input    : BC - blocklength
;            HL - source RAM address
;            DE - target VRAM address
;===============================================================================
_LDIRVM::

;la llamada a la BIOS no funciona cuando el bloque de datos en RAM esta en el
;primera pagina de la RAM ya que se sustituye por la BIOS  
;  ld   IX,#LDIRVM
;  ld   IY,(EXPTBL-1)
;  call CALSLT ;acces to MSX BIOS
;  ei

;BIOS LDIRVM 
   ex   DE,HL
   ld   A,(#0xFCAF) ;SCRMOD screen mode
   cp   #4
   jr   NC,MSX2MODES ;>4
   ld   A,(#0xFAFC)  ;MODE  mode switch for VRAM size
   and  #8
   jr   NZ,MSX2MODES
   
   ;call SETWRT  ;0x0053 BIOS Enable VDP to write
   ld   IX,#SETWRT
   ld   IY,(EXPTBL-1)
   call CALSLT ;acces to MSX BIOS
   ei
   
VWRBYTE:
   ld   A,(DE)
   out  (#0x98),A
   inc  DE
   dec  BC
   ld   A,C
   or   B
   jr   NZ,VWRBYTE
   ret
   
MSX2MODES:
   ;call NSTWRT ;0x0171 Enable VDP to write 16bits
   ld   IX,#NSTWRT
   ld   IY,(EXPTBL-1)
   call CALSLT ;acces to MSX BIOS
   ei  
   call $0687
   ld   C,#0x98
WRBLOQVR:
   otir
   dec  A
   jr   NZ,WRBLOQVR
   ex   DE,HL
   ret

$0687:
   ex   DE,HL
   ld   A,C
   or   A
   ld   A,B
   ld   B,C
   ret  Z
   inc  A
   ret


    

        
;===============================================================================
; _LDIRMV
; Function : 
;    Block transfer from VRAM to memory.  
; Input    : BC - blocklength
;            HL - source VRAM address                     
;            DE - target RAM address            
;===============================================================================    
_LDIRMV::
  
  ld   IX,#LDIRMV
  ld   IY,(EXPTBL-1)
  call CALSLT ;acces to MSX BIOS
  ei
    
  ret