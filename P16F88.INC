        LIST
; P16F88.INC  Standard Header File, Version 1.00    Microchip Technology, Inc.
        NOLIST

; This header file defines configurations, registers, and other useful bits of
; information for the PIC16F88 microcontroller.  These names are taken to match 
; the data sheets as closely as possible.  

; Note that the processor must be selected before this file is 
; included.  The processor may be selected the following ways:

;       1. Command line switch:
;               C:\ MPASM MYFILE.ASM /PIC16F88
;       2. LIST directive in the source file
;               LIST   P=PIC16F88
;       3. Processor Type entry in the MPASM full-screen interface

;==========================================================================
;
;       Revision History
;
;==========================================================================

;Rev:   Date:    Reason:

;1.00   07/29/02 Initial Release
;1.01   09/18/02 Changed name of bit-2 in the OSCCON register to IOFS
;1.02   01/10/03 Added bit names for TXSTA & RCSTA registers.
;1.03   01/24/03 Changed Config bit CCP1_RB2 to CCP1_RB0
;1.04   12/02/03 Modified the WRT1:WRT0 bit definition in Config Word 1.
;1.05   02/08/04 Changed bit in _CONFIG1 example from CCP1_RB2 to CCP1_RB0.

;==========================================================================
;
;       Verify Processor
;
;==========================================================================

        IFNDEF __16F88
           MESSG "Processor-header file mismatch.  Verify selected processor."
        ENDIF

;==========================================================================
;
;       Register Definitions
;
;==========================================================================

W                            EQU     H'0000'
F                            EQU     H'0001'

;----- Register Files------------------------------------------------------

INDF                         EQU     H'0000'
TMR0                         EQU     H'0001'
PCL                          EQU     H'0002'
STATUS                       EQU     H'0003'
FSR                          EQU     H'0004'
PORTA                        EQU     H'0005'
PORTB                        EQU     H'0006'
PCLATH                       EQU     H'000A'
INTCON                       EQU     H'000B'
PIR1                         EQU     H'000C'
PIR2                         EQU     H'000D'
TMR1L                        EQU     H'000E'
TMR1H                        EQU     H'000F'
T1CON                        EQU     H'0010'
TMR2                         EQU     H'0011'
T2CON                        EQU     H'0012'
SSPBUF                       EQU     H'0013'
SSPCON                       EQU     H'0014'
CCPR1L                       EQU     H'0015'
CCPR1H                       EQU     H'0016'
CCP1CON                      EQU     H'0017'
RCSTA                        EQU     H'0018'
TXREG                        EQU     H'0019'
RCREG                        EQU     H'001A'
ADRESH                       EQU     H'001E'
ADCON0                       EQU     H'001F'

OPTION_REG                   EQU     H'0081'
TRISA                        EQU     H'0085'
TRISB                        EQU     H'0086'
PIE1                         EQU     H'008C'
PIE2                         EQU     H'008D'
PCON                         EQU     H'008E'
OSCCON                       EQU     H'008F'
OSCTUNE                      EQU     H'0090'
PR2                          EQU     H'0092'
SSPADD                       EQU     H'0093'
SSPSTAT                      EQU     H'0094'
TXSTA                        EQU     H'0098'
SPBRG                        EQU     H'0099'
ANSEL                        EQU     H'009B'
CMCON                        EQU     H'009C'
CVRCON                       EQU     H'009D'
ADRESL                       EQU     H'009E'
ADCON1                       EQU     H'009F'

WDTCON                       EQU     H'0105'
EEDATA                       EQU     H'010C'
EEADR                        EQU     H'010D'
EEDATH                       EQU     H'010E'
EEADRH                       EQU     H'010F'

EECON1                       EQU     H'018C'
EECON2                       EQU     H'018D'

;----- STATUS Bits --------------------------------------------------------
IRP                          EQU     H'0007'
RP1                          EQU     H'0006'
RP0                          EQU     H'0005'
NOT_TO                       EQU     H'0004'
NOT_PD                       EQU     H'0003'
Z                            EQU     H'0002'
DC                           EQU     H'0001'
C                            EQU     H'0000'

;----- INTCON Bits --------------------------------------------------------
GIE                          EQU     H'0007'
PEIE                         EQU     H'0006'
TMR0IE                       EQU     H'0005'
INTE                         EQU     H'0004'
RBIE                         EQU     H'0003'
TMR0IF                       EQU     H'0002'
INTF                         EQU     H'0001'
RBIF                         EQU     H'0000'

;----- PIR1 Bits ----------------------------------------------------------
ADIF                         EQU     H'0006'
RCIF                         EQU     H'0005'
TXIF                         EQU     H'0004'
SSPIF                        EQU     H'0003'
CCP1IF                       EQU     H'0002'
TMR2IF                       EQU     H'0001'
TMR1IF                       EQU     H'0000'

;----- PIR2 Bits ----------------------------------------------------------
OSFIF                        EQU     H'0007'
CMIF                         EQU     H'0006'
EEIF                         EQU     H'0004'

;----- T1CON Bits ---------------------------------------------------------
T1RUN                        EQU     H'0006'
T1CKPS1                      EQU     H'0005'
T1CKPS0                      EQU     H'0004'
T1OSCEN                      EQU     H'0003'
NOT_T1SYNC                   EQU     H'0002'
T1INSYNC                     EQU     H'0002'    ; Backward compatibility only
TMR1CS                       EQU     H'0001'
TMR1ON                       EQU     H'0000'

;----- T2CON Bits ---------------------------------------------------------
TOUTPS3                      EQU     H'0006'
TOUTPS2                      EQU     H'0005'
TOUTPS1                      EQU     H'0004'
TOUTPS0                      EQU     H'0003'
TMR2ON                       EQU     H'0002'
T2CKPS1                      EQU     H'0001'
T2CKPS0                      EQU     H'0000'

;----- SSPCON Bits --------------------------------------------------------
WCOL                         EQU     H'0007'
SSPOV                        EQU     H'0006'
SSPEN                        EQU     H'0005'
CKP                          EQU     H'0004'
SSPM3                        EQU     H'0003'
SSPM2                        EQU     H'0002'
SSPM1                        EQU     H'0001'
SSPM0                        EQU     H'0000'

;----- CCP1CON Bits -------------------------------------------------------
CCP1X                        EQU     H'0005'
CCP1Y                        EQU     H'0004'
CCP1M3                       EQU     H'0003'
CCP1M2                       EQU     H'0002'
CCP1M1                       EQU     H'0001'
CCP1M0                       EQU     H'0000'

;----- RCSTA Bits ---------------------------------------------------------
SPEN                         EQU     H'0007'
RX9                          EQU     H'0006'
RC9                          EQU     H'0006'    ; Backward compatibility only
NOT_RC8                      EQU     H'0006'    ; Backward compatibility only
RC8_9                        EQU     H'0006'    ; Backward compatibility only
SREN                         EQU     H'0005'
CREN                         EQU     H'0004'
ADDEN                        EQU     H'0003'
FERR                         EQU     H'0002'
OERR                         EQU     H'0001'
RX9D                         EQU     H'0000'
RCD8                         EQU     H'0000'    ; Backward compatibility only

;----- ADCON0 Bits --------------------------------------------------------
ADCS1                        EQU     H'0007'
ADCS0                        EQU     H'0006'
CHS2                         EQU     H'0005'
CHS1                         EQU     H'0004'
CHS0                         EQU     H'0003'
GO                           EQU     H'0002'
NOT_DONE                     EQU     H'0002'
GO_DONE                      EQU     H'0002'
ADON                         EQU     H'0000'

;----- OPTION_REG Bits -----------------------------------------------------
NOT_RBPU                     EQU     H'0007'
INTEDG                       EQU     H'0006'
T0CS                         EQU     H'0005'
T0SE                         EQU     H'0004'
PSA                          EQU     H'0003'
PS2                          EQU     H'0002'
PS1                          EQU     H'0001'
PS0                          EQU     H'0000'

;----- PIE1 Bits ----------------------------------------------------------
ADIE                         EQU     H'0006'
RCIE                         EQU     H'0005'
TXIE                         EQU     H'0004'
SSPIE                        EQU     H'0003'
CCP1IE                       EQU     H'0002'
TMR2IE                       EQU     H'0001'
TMR1IE                       EQU     H'0000'

;----- PIE2 Bits ----------------------------------------------------------
OSFIE                        EQU     H'0007'
CMIE                         EQU     H'0006'
EEIE                         EQU     H'0004'

;----- PCON Bits ----------------------------------------------------------
NOT_POR                      EQU     H'0001'
NOT_BO                       EQU     H'0000'
NOT_BOR                      EQU     H'0000' 

;----- OSCCON Bits -------------------------------------------------------
IRCF2                        EQU     H'0006'
IRCF1                        EQU     H'0005'
IRCF0                        EQU     H'0004'
OSTS                         EQU     H'0003'
IOFS                         EQU     H'0002'
SCS1                         EQU     H'0001'
SCS0                         EQU     H'0000'

;----- OSCTUNE Bits -------------------------------------------------------
TUN5                         EQU     H'0005'
TUN4                         EQU     H'0004'
TUN3                         EQU     H'0003'
TUN2                         EQU     H'0002'
TUN1                         EQU     H'0001'
TUN0                         EQU     H'0000'

;----- SSPSTAT Bits -------------------------------------------------------
SMP                          EQU     H'0007'
CKE                          EQU     H'0006'
D                            EQU     H'0005'
I2C_DATA                     EQU     H'0005'
NOT_A                        EQU     H'0005'
NOT_ADDRESS                  EQU     H'0005'
D_A                          EQU     H'0005'
DATA_ADDRESS                 EQU     H'0005'
P                            EQU     H'0004'
I2C_STOP                     EQU     H'0004'
S                            EQU     H'0003'
I2C_START                    EQU     H'0003'
R                            EQU     H'0002'
I2C_READ                     EQU     H'0002'
NOT_W                        EQU     H'0002'
NOT_WRITE                    EQU     H'0002'
R_W                          EQU     H'0002'
READ_WRITE                   EQU     H'0002'
UA                           EQU     H'0001'
BF                           EQU     H'0000'

;----- TXSTA Bits ---------------------------------------------------------
CSRC                         EQU     H'0007'
TX9                          EQU     H'0006'
NOT_TX8                      EQU     H'0006'    ; Backward compatibility only
TX8_9                        EQU     H'0006'    ; Backward compatibility only
TXEN                         EQU     H'0005'
SYNC                         EQU     H'0004'
BRGH                         EQU     H'0002'
TRMT                         EQU     H'0001'
TX9D                         EQU     H'0000'
TXD8                         EQU     H'0000'    ; Backward compatibility only

;----- ADCON1 Bits --------------------------------------------------------
ADFM                         EQU     H'0007'
ADCS2                        EQU     H'0006'
VCFG1                        EQU     H'0005'
VCFG0                        EQU     H'0004'

;----- WDTCON Bits --------------------------------------------------------
WDTPS3                       EQU     H'0004'
WDTPS2                       EQU     H'0003'
WDTPS1                       EQU     H'0002'
WDTPS0                       EQU     H'0001'
SWDTEN                       EQU     H'0000'
SWDTE                        EQU     H'0000'

;----- CMCON Bits ---------------------------------------------------------
C2OUT                        EQU     H'0007'
C1OUT                        EQU     H'0006'
C2INV                        EQU     H'0005'
C1INV                        EQU     H'0004'
CIS                          EQU     H'0003'
CM2                          EQU     H'0002'
CM1                          EQU     H'0001'
CM0                          EQU     H'0000'

;----- CVRCON Bits --------------------------------------------------------
CVREN                        EQU     H'0007'
CVROE                        EQU     H'0006'
CVRR                         EQU     H'0005'
CVR3                         EQU     H'0003'
CVR2                         EQU     H'0002'
CVR1                         EQU     H'0001'
CVR0                         EQU     H'0000'

;----- EECON1 Bits --------------------------------------------------------
EEPGD                        EQU     H'0007'
FREE                         EQU     H'0004'
WRERR                        EQU     H'0003'
WREN                         EQU     H'0002'
WR                           EQU     H'0001'
RD                           EQU     H'0000'

;==========================================================================
;
;       RAM Definition
;
;==========================================================================

        __MAXRAM H'1FF'
        __BADRAM H'07'-H'09', H'1B'-H'1D'
        __BADRAM H'87'-H'89', H'91', H'95'-H'97', H'9A'
        __BADRAM H'107'-H'109'
        __BADRAM H'185', H'187'-H'189', H'18E'-H'18F'

;==========================================================================
;
;       Configuration Bits
;
;==========================================================================

_CONFIG1                    EQU     H'2007'
_CONFIG2                    EQU     H'2008'

;Configuration Byte 1 Options
_CP_ALL                      EQU     H'1FFF'
_CP_OFF                      EQU     H'3FFF'
_CCP1_RB0                    EQU     H'3FFF'
_CCP1_RB3                    EQU     H'2FFF'
_DEBUG_OFF                   EQU     H'3FFF'
_DEBUG_ON                    EQU     H'37FF'
_WRT_PROTECT_OFF             EQU     H'3FFF'    ;No program memory write protection
_WRT_PROTECT_256             EQU     H'3DFF'    ;First 256 program memory protected
_WRT_PROTECT_2048            EQU     H'3BFF'    ;First 2048 program memory protected
_WRT_PROTECT_ALL             EQU     H'39FF'    ;All of program memory protected
_CPD_ON                      EQU     H'3EFF'
_CPD_OFF                     EQU     H'3FFF'
_LVP_ON                      EQU     H'3FFF'
_LVP_OFF                     EQU     H'3F7F'
_BODEN_ON                    EQU     H'3FFF'
_BODEN_OFF                   EQU     H'3FBF'
_MCLR_ON                     EQU     H'3FFF'
_MCLR_OFF                    EQU     H'3FDF'
_PWRTE_OFF                   EQU     H'3FFF'
_PWRTE_ON                    EQU     H'3FF7'
_WDT_ON                      EQU     H'3FFF'
_WDT_OFF                     EQU     H'3FFB'
_EXTRC_CLKOUT                EQU     H'3FFF'
_EXTRC_IO                    EQU     H'3FFE'
_INTRC_CLKOUT                EQU     H'3FFD'
_INTRC_IO                    EQU     H'3FFC'
_EXTCLK                      EQU     H'3FEF'
_HS_OSC                      EQU     H'3FEE'
_XT_OSC                      EQU     H'3FED'
_LP_OSC                      EQU     H'3FEC'

;Configuration Byte 2 Options
_IESO_ON                     EQU     H'3FFF'
_IESO_OFF                    EQU     H'3FFD'
_FCMEN_ON                    EQU     H'3FFF'
_FCMEN_OFF                   EQU     H'3FFE'



; To use the Configuration Bits, place the following lines in your source code
;  in the following format, and change the configuration value to the desired 
;  setting (such as CP_OFF to CP_ALL).  These are currently commented out here
;  and each __CONFIG line should have the preceding semicolon removed when
;  pasted into your source code.

;Program Configuration Register 1
;        __CONFIG    _CONFIG1, _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_OFF & _PWRTE_OFF & _WDT_OFF & _HS_OSC

;Program Configuration Register 2
;        __CONFIG    _CONFIG2, _IESO_OFF & _FCMEN_OFF



        LIST
