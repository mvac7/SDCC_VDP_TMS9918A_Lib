; ==============================================================================                                                                            
;   VDP_TMS9918A.s                                                          
;   v1.1 (25 April 2019)                                                                     
;   Description:                                                              
;     * Opensource library for acces to VDP TMS9918A/28A/29A
;     * Not use the BIOS 
;     * using the ports 0x98 and 0x99 from MSX computers.
;     * save VDP values in MSX System variables
; History of versions:
;   v1.0 (14 February 2014)                                                                           
; ============================================================================== 
	.area _DATA


  .area _CODE
  
; Ports  
VDPVRAM   = 0x98 ;VRAM Data (Read/Write)
VDPSTATUS = 0x99 ;VDP Status Registers 



;system var
MSXVER = 0x002D
LINL40 = 0xF3AE ;Screen width per line in SCREEN 0
RG0SAV = 0xF3DF ;#F3DF - #F3E6: vdp registers 0-7
FORCLR = 0xF3E9 ;Foreground colour
BAKCLR = 0xF3EA ;Background colour
BDRCLR = 0xF3EB ;Border colour
EXPTBL = 0xFCC1 



; VRAM address tables screen 0 TXT40
BASE0 = 0x0000 ; base 0 name table
BASE2 = 0x0800 ; base 2 character pattern table

; VRAM address tables screen 1 TXT32
BASE5 = 0x1800 ; base 5 name table
BASE6 = 0x2000 ; base 6 color table
BASE7 = 0x0000 ; base 7 character pattern table
BASE8 = 0x1B00 ; base 8 sprite attribute table
BASE9 = 0x3800 ; base 9 sprite pattern table

; VRAM address tables screen 2 GRAPH1
BASE10 = 0x1800 ; base 10 name table
BASE11 = 0x2000 ; base 11 color table
BASE12 = 0x0000 ; base 12 character pattern table
BASE13 = 0x1B00 ; base 13 sprite attribute table
BASE14 = 0x3800 ; base 14 sprite pattern table

; VRAM address tables screen 3 GRAPH2
BASE15 = 0x0800 ; base 15 name table
BASE17 = 0x0000 ; base 17 character pattern table
BASE18 = 0x1B00 ; base 18 sprite attribute table
BASE19 = 0x3800 ; base 19 sprite pattern table


;===============================================================================
; screen
; Sets the screen mode.
;
; void SCREEN(char mode)
; ==============================================================================
_SCREEN::
  push IX
  ld   IX,#0
  add  IX,SP

  ld   A,4(IX)
  cp   #1
  jr   Z,screen1
  cp   #2
  jr   Z,screen2
  cp   #3
  jr   Z,screen3
  
;screen 0  
  xor  A
  ld   DE,#960   ;40*24
  ld   HL,#BASE0
  call fillVR
  
  ld   IX,#mode_TXT1
  ;screen 0 > 40 columns mode
  ld   A,#39  ;default value
  ld   (#LINL40),A 
  
  jr  setREGs 

screen1:
  call ClearSC
  call ClearOAM    
  ld   IX,#mode_GFX1
  jr  setREGs
  
screen3:
  call ClearOAM  
  ld   IX,#mode_MC
  jr  setREGs  

screen2:
  call ClearSC
  call ClearOAM      
  ld   IX,#mode_GFX2

setREGs:
  ld   C,#0
  ld   B,(IX)
  call writeVDP
  
  inc  C
  ld   B,1(IX)
  call writeVDP
  
  inc  C
  ld   B,2(IX)
  call writeVDP
  
  inc  C
  ld   B,3(IX)
  call writeVDP
  
  inc  C
  ld   B,4(IX)
  call writeVDP
  
  inc  C
  ld   B,5(IX)
  call writeVDP
  
  inc  C
  ld   B,6(IX)
  call writeVDP
  
  pop ix
  ret
  

ClearSC:
  xor  A
  ld   DE,#0x300    ;32*24
  ld   HL,#BASE5
  call fillVR
  ret
  
ClearOAM:
  xor  A
  ld   DE,#0x80    ;32*4
  ld   HL,#BASE8
  call fillVR
  ret  
  
  
;Reg/Bit  7     6     5     4     3     2     1     0
;0        -     -     -     -     -     -     M3    EXTVID
;1        4/16K	BLK   GINT	M1    M2    -     SIZE  MAG

; M1=1; M2=0; M3=0  
mode_TXT1:
 .db 0B00000000 ;reg0
 .db 0B11110000 ;reg1 F0 
 .db 0x00 ;reg2 Name Table              (0000h)
 .db 0x00 ;reg3 --
 .db 0x01 ;reg4 Pattern Table           (0800h)
 .db 0x00 ;reg5 --
 .db 0x00 ;reg6 --

; M1=0; M2=0; M3=0  
mode_GFX1:
 .db 0B00000000 ;reg0
 .db 0B11100000 ;reg1 E0 Default sprites 8x8 No Zoom
 .db 0x06  ;reg2 Name Table             (1800h)
 .db 0x80  ;reg3 Color Table            (2000h)
 .db 0x00  ;reg4 Pattern Table          (0000h)
 .db 0x36  ;reg5 Sprite Attribute Table (1B00h)
 .db 0x07  ;reg6 Sprite Pattern Table   (3800h)

; M1=0; M2=0; M3=1  
mode_GFX2:
 .db 0B00000010 ;reg0
 .db 0B11100000 ;reg1 E0 Default sprites 8x8 No Zoom
 .db 0x06  ;reg2 Name Table             (1800h)
 .db 0xFF  ;reg3 Color Table            (2000h)
 .db 0x03  ;reg4 Pattern Table          (0000h)
 .db 0x36  ;reg5 Sprite Attribute Table (1B00h)
 .db 0x07  ;reg6 Sprite Pattern Table   (3800h)

; M1=0; M2=1; M3=0 
mode_MC:
 .db 0x00  ;reg0
 .db 0B11101000 ;reg1 E8 Default sprites 8x8 No Zoom
 .db 0x02  ;reg2 Name Table             (0800h)
 .db 0x00  ;reg3 Color Table            (0000h)
 .db 0x00  ;reg4 --
 .db 0x36  ;reg5 Sprite Attribute Table (1B00h)
 .db 0x07  ;reg6 Sprite Pattern Table   (3800h)  
  

  


; ==============================================================================
; SetSpritesSize
; Description: Set size type for the sprites.
; Input:       [char] size: 0=8x8; 1=16x16
; Output:      -
;void SetSpritesSize(char size)
; ============================================================================== 
_SetSpritesSize::
  push IX
  ld   IX,#0
  add  IX,SP
  
  ld   HL,#RG0SAV+1 ; --- read vdp(1) from mem
  ld   B,(HL)

  ld   A,4(ix)    
  cp   #1
  jr   NZ,size8
  set  1,B ; 16x16
  jr   setSize
  
size8:
  res  1,B  ; 8x8    

setSize:  
  ld   C,#0x01
  call writeVDP
  
  pop  IX
  ret




; ==============================================================================
; SetSpritesZoom
; Description: Set zoom type for the sprites.
; Input:       [char] zoom: 0 = x1; 1 = x2
; Output:      -
;void SetSpritesZoom(char zoom)
; ==============================================================================
_SetSpritesZoom::
  push IX
  ld   IX,#0
  add  IX,SP
  
  ld   HL,#RG0SAV+1 ; --- read vdp(1) from mem
  ld   B,(HL)

  ld   A,4(ix)
  or   A
  jr   Z,nozoom
  set  0,B ; zoom
  jr   setZoom
  
nozoom:
  res  0,B  ;nozoom    

setZoom:  
  ld   C,#0x01
  call writeVDP
  
  pop  IX
  ret
  
  
  
  


;===============================================================================
; COLOR
; Function : Specifies the foreground color, background and area of the edges. 
; Input    : (char) - ink color   <<<< Not used. BIOS version only.
;            (char) - background color.        
;            (char) - border color
;
; void COLOR(char ink, char background, char border)
;===============================================================================
;(info by Portar Doc)
;Register 7: colour register.
;  Bit  Name  Expl.
;  0-3  TC0-3 Background colour in SCREEN 0 (also border colour in SCREEN 1-3)
;  4-7  BD0-3 Foreground colour in SCREEN 0      
;===============================================================================
_COLOR::
  push IX
  ld   IX,#0
  add  IX,SP

  ld   A,4(IX)
  ld   (FORCLR),A ;save in system vars
  
  ld   B,6(IX)
  ld   (BDRCLR),A
    
  ld   A,5(IX)
  ld   (BAKCLR),A ;save in system vars

  sla  A
  sla  A
  sla  A
  sla  A
  add  A,B
  
  ld   C,#0x07 ;VDP reg 7
  ld   B,A  
  call writeVDP
   
  pop  IX
  ret



;===============================================================================
; VPOKE
; Function : Writes a byte to the video RAM. 
; Input    : (unsigned int)  - VRAM address
;            (char)  - value 
;
;void VPOKE(unsigned int address, char value)
;===============================================================================
_VPOKE::
  push IX
  ld   IX,#0
  add  IX,SP
  
  ld   L,4(IX)
  ld   H,5(IX)
   
  ld   A,6(IX)
  
  call WriteByte2VRAM
  
  pop  IX
  ret



;===============================================================================
; VPEEK
; Function : Reads data from the video RAM. 
; Input    : (unsigned int) - memory address
; Output   : (char) value
;
; unsigned char VPEEK(unsigned int address)
;=============================================================================== 
_VPEEK::
  push IX
  ld   IX,#0
  add  IX,SP
  
  ld   L,4(IX)
  ld   H,5(IX) 
   
  call ReadByteFromVRAM
  
  ld   L,A
  
  pop  IX
  ret



;===============================================================================
; FillVRAM                                
; Function : Fill a large area of the VRAM of the same byte.
; Input    : (unsigned int) - VRAM address
;            (unsigned int) - length
;            (char) - value
;
; void fillVRAM (unsigned int vaddress, unsigned int size, char value)
;===============================================================================
_FillVRAM::
  push IX
  ld   IX,#0
  add  IX,SP
      
  ld   L,4(IX) ; vaddress
  ld   H,5(IX)
    
  ld   E,6(IX) ;length
  ld   D,7(IX)
    
  ld   A,8(IX) ;value
  
  call fillVR
    
  pop  IX
  ret



;===============================================================================
; CopyToVRAM
; Function : Block transfer from memory to VRAM
; Input    : (unsigned int) - source RAM address 
;            (unsigned int) - target VRAM address
;            (unsigned int) - length
;
; void CopyToVRAM(unsigned int address, unsigned int vaddress, unsigned int length)
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
  
  call LDIR2VRAM
  
  pop  IX
  ret



;===============================================================================
; CopyFromVRAM
; Function : Block transfer from VRAM to memory.
; Input    : (unsigned int) - source VRAM address
;            (unsigned int) - target RAM address
;            (unsigned int) - length
;
;void CopyFromVRAM(unsigned int vaddress, unsigned int address, unsigned int length)
;===============================================================================
_CopyFromVRAM::

  push IX
  ld   IX,#0
  add  IX,SP
    
  ld   L,4(IX) ;vaddress
  ld   H,5(IX)
  
  ld   E,6(IX) ;ram address 
  ld   D,7(IX)     
  
  ld   C,8(IX) ;length
  ld   B,9(IX)
    
  call GETBLOCKfromVRAM
    
  pop  IX

  ret
  


;===============================================================================
; _setVDP
; Function : writes a value in VDP reg.
; Input    : (char) - VDP reg
;            (char) - value
;
;void SetVDP(char, char)
;===============================================================================
_SetVDP::
  push IX
  ld   IX,#0
  add  IX,SP
      
  ld   C,4(IX) ;reg
  ld   B,5(IX) ;value
  
  call writeVDP  
    
  pop  IX
  ret





  
  
  
  
;===============================================================================
; writeVDP
; Function : write data in the VDP-register  
; Input    : B  - data to write
;            C  - number of the register
;===============================================================================
writeVDP::

  ld   IY,#RG0SAV
  ld   E,C
  ld   D,#0
  add  IY,DE
  ld   (IY),B ;save copy of vdp value in system var
  
  ld   A,B
  di
	out	 (#VDPSTATUS),A
	ld   A,C
  or   #0x80            ;add 128 to VDP reg value
  out	 (#VDPSTATUS),A
  ei
  ret


  
;===============================================================================
; WriteByte2VRAM                                
; Function : Writes data in VRAM
; Input    : A  - value
;            HL - VRAM address
;===============================================================================
WriteByte2VRAM::
  
  push   AF
  
  call SetVRAMaddr2WRITE  

  ;ex (SP),HL
  ;ex (SP),HL
  
  pop   AF
  out  (VDPVRAM),A
  
  ret


SetVRAMaddr2WRITE:
  di
  ld   A,(#MSXVER) ;if MSX2?
  or   A
  jr   Z,WRITETMS      ;if MSX1(TMS9918A) goto WRITETMS
;V9938 or higher
  xor  A
  out  (VDPSTATUS),A   ;clear three upper bits for 16bit VRAM ADDR (128K)
  ld   A,#14+128       ;V9938 reg 14 - Control Register
  out  (VDPSTATUS),A
WRITETMS:
  ld   A,L             ;first 8bits from VRAM ADDR
  out  (VDPSTATUS),A
  ld   A,H             ;6 bits from VRAM ADDR 
  and  #0x3F
  or   #0x40           ;bit6 = 1 --> write access
  out  (VDPSTATUS),A
  ei
  
  ret



;===============================================================================
; ReadByteFromVRAM                                
; Function : Reads data from VRAM
; Input    : HL - VRAM address
; Output   : A  - value
;===============================================================================
ReadByteFromVRAM::
  call SetVRAMaddr2READ

  ;ex (SP),HL
  ;ex (SP),HL
      
  in   A,(VDPVRAM)

  ret
  
  
SetVRAMaddr2READ:
  di
  ld A,(#MSXVER) ;if MSX2?
  or A
  jr Z,READTMS
  xor A
  out  (VDPSTATUS),A
  ld   A,#0x8E
  out  (VDPSTATUS),A
READTMS:
  ld   A,L
  out  (VDPSTATUS),A
  ld   A,H
  and  #0x3F          ;bit6 = 0 --> read access
  out  (VDPSTATUS),A 
  ei

  ret



;===============================================================================
; fillVR                                
; Function : Fill a large area of the VRAM of the same byte.
; Input    : A  - value
;            DE - Size
;            HL - VRAM address
;===============================================================================
fillVR::
  
  ld   B,A
  ld   C,#VDPVRAM
   
  call SetVRAMaddr2WRITE  
      
VFILL_loop:
  out  (C),B    ;(14ts)  14+7+5+5+13=44ts  (time for write 29 T-states)
  
  dec  DE             ;(7ts)
  ld   A,D            ;(5ts)
  or   E              ;(5ts)
  jr   nz,VFILL_loop  ;(13ts)
  
  ret



;===============================================================================
; LDIR2VRAM
; Function : Block transfer from memory to VRAM 
; Input    : BC - blocklength
;            HL - source RAM address
;            DE - target VRAM address
;===============================================================================
LDIR2VRAM::

  ex   DE,HL
  
  call SetVRAMaddr2WRITE
    
  ex   DE,HL
  
  ld   D,B
  ld   E,C
        
  ld   C,#VDPVRAM
    
VWRITE_loop:
  outi         ;write [HL] to C port and INC HL
  
  dec  DE
  ld   A,D
  or   E
  jr   nz,VWRITE_loop    
  
  ret   
    

        
;===============================================================================
; GETBLOCKfromVRAM
; Function : Block transfer from VRAM to memory.  
; Input    : BC - blocklength
;            HL - source VRAM address                     
;            DE - target RAM address            
;===============================================================================    
GETBLOCKfromVRAM::
  call SetVRAMaddr2READ
  
  ex   DE,HL
  
  ld   D,B
  ld   E,C
  
  ld   C,#VDPVRAM
    
VREAD_loop:
  ini           ;read value from C port, write in [HL] and INC HL
  
  dec  DE
  ld   A,D
  or   E
  jr   NZ,VREAD_loop    
   
  ret
  


