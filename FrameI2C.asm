
;******************************************************************************
;                                                                             *
;    Filename:      FrameI2C.asm                                              *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required:                                                          *
;                                                                             *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;                                                                             *
;                                                                             *
;                                                                             *
;******************************************************************************

;***********************DIAGRAMME DU CONTROLEUR********************************
;                                                                     
;                     IN  IN  S3  IN      S2  S1  TX  D2            S: Switch 
;                     A1  A0  A7  A6 VDD  B7  B6  B5  B4              
;                    ____________________________________             
;           PIN     | 18  17  16  15  14  13  12  11  10 |            
;                   |               16C88                |            
;           PIN     | 1   2   3  _4_  5   6   7   8   9  |            
;                    ------------------------------------             
;                     A2  A3  A4  A5 VSS  B0  B1  B2  B3              
;                     IN  IN  IN  MCL     SCL SDA RX  D1            D: Del  
;
;******************************************************************************



;******************** Les fonctions utilisees *********************************
; InitPic                      ; Initialise le PIC.
; SDA0                         ; Met SDA a 0
; SDA1                         ; Met SDA a 1
; SCL0                         ; Met SCL a 0 
; SCL1                         ; Met SCL a 1  
; EcrireMemI2C                 ; Ecrire un octet en memoire I2C
; LireMemI2C                   ; Lecture d'un octet en memoire I2C
; Ecrire8BitsI2C               ; Ecrire 8 bits sur la ligne I2C
; Lire8BitsI2C                 ; Lire 8 bits sur la ligne I2C
; Ecrit1BitI2C                 ; Emet 1 bit sur la ligne I2C
; Lire1BitI2C                  ; Recoit 1 bit sur la ligne I2C
; StartBitI2C                  ; Start une communication I2C
; StopBitI2C                   ; Termine une communication I2C
; Delai5us                     ; Delai pour maintenir signaux 5us.
;******************************************************************************



     LIST      p=16f88         ; Liste des directives du processeur.
     #include <P16F88.INC>     ; Définition des registres spécifiques au CPU.

     errorlevel  -302          ; Retrait du message d'erreur 302.

     __CONFIG    _CONFIG1, _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_ON & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO

     __CONFIG    _CONFIG2, _IESO_OFF & _FCMEN_OFF



;*********************************** DEFINES **********************************
#define      BANK0   bcf       STATUS,RP0;
#define      BANK1   bsf       STATUS,RP0;

;*********************************** KIT-PIC **********************************
#define      SW1               PORTB,6
#define      SW2               PORTB,7
#define      SW3               PORTA,7
#define      DEL1              PORTB,3
#define      DEL2              PORTB,4

;************************************ I2C *************************************
#define      SCL               PORTB,0
#define      SDA               PORTB,1

#define	     I2CIN	       0
#define	     I2CINACK	       2
#define	     I2COUT	       3
#define	     I2COUTACK	       4

     

;***** VARIABLE DEFINITIONS  **************************************************
;w_temp        EQU     0x71     ; variable used for context saving 
;status_temp   EQU     0x72     ; variable used for context saving
;pclath_temp   EQU     0x73     ; variable used for context saving


;VosVariables  EQU     0x20     ; Mettre ici vos Variables
  CBLOCK  0x20  
  
; General
  vTempo
  
; Variable I2C
  vI2COctet
  vI2CBits
  vI2CCompt
  
; Variable 24LC32
  vI2CAdrrH
  vI2CAdrrB
  
  
  endc



;***************************VECTEUR DE RESET***********************************
     ORG     0x000             ; Processor reset vector
     clrf    PCLATH            ; Page 0 (a cause du BootLoader)
     goto    Main              ; 
        

;***********************VECTEUR D'INTERRUPTION*********************************    
     ORG     0x004             ; Interrupt vector location
     goto    Interruption


;**************************PROGRAMME PRINCIPAL*********************************

Main    
     call   InitPic

Boucle
     
     goto   Boucle


;****************************** ROUTINES **************************************


;******************************* ROUTINES *************************************

;******************************* InitPic **************************************
;       Nom de la fonction : InitPic                    
;       Auteur : Alain Champagne
;       Date de creation : 23-09-2018                                
;       Description :      Routine d'initiation des registres du PIC.
;                          - RP1 à 0 pour être toujours dans Bank 0 et 1,
;                          - Désactiver les interruptions,
;                          - Désactiver les entrées analogiques,
;                          - PortA en entrée,
;                          - PortB en entrée sauf: Bits I2C et LEDs en sortie.
;                                                       
;       Fonctions appelees : NA 
;       Paramètres d'entree : NA  
;       Paramètres de sortie : NA 
;       Variables utilisees : NA  
;       Include : Fichier P16F88.inc
;       Equates : NA
;       #Defines : BANK0, BANK1 
;                                               
;******************************************************************************
InitPic
     bcf     STATUS, RP1       ; Pour s'assurer d'être dans les bank 0 et 1 
     BANK1                     ; Select Bank1        
     bcf     INTCON,GIE        ; Désactive les interruptions        
     clrf    ANSEL             ; Désactive les convertisseurs reg ANSEL 0x9B        
     movlw   b'01111000'       ; osc internal 8 Mhz
     movwf   OSCCON
     movlw   b'11111111'       ; Remplacer les x par des 1 ou 0.
     movwf   TRISA             ; PortA en entree         
     movlw   b'11100100'       ; Bits en entrées sauf,
     movwf   TRISB             ; RB3 (Led1), RB4 (Led2) en sortie. 
     BANK0                     ; Select Bank0
     return

; fin routine InitPic ---------------------------------------------------------



;********************************** SDA SCL ***********************************
;
; Gestion de SDA et SCL pour ne jamais mettre de vrai 1 sur le bus. C'est les 
; pull-up sur SDA et SCL qui s'en charge.
;
; Pour mettre SDA ou SCL à 1 on met le bit en entree.
;
;******************************************************************************
SDA0     
     bcf     SDA               ; On s'assure que bit du latch est a 0.
     BANK1
     bcf     TRISB,1           ; SDA en output met bit a 0.
     BANK0
     return
; fin routine SDA0 ------------------------------------------------------------

;******************************************************************************      
SDA1 
     BANK1
     bsf     TRISB,1           ; SDA input (pull-up met a 1 ).
     BANK0
     return  
; fin routine SDA1 ------------------------------------------------------------

;******************************************************************************
SCL0 
     bcf     SCL               ; On s'assure que le bit du latch est a 0.
     BANK1
     bcf     TRISB,0           ; SCL en output met bit a 0.
     BANK0
     return
; fin routine SCL0 ------------------------------------------------------------

;******************************************************************************         
SCL1 
     BANK1
     bsf     TRISB,0           ; SCL input (pull-up met a 1 ).
     BANK0
     return 
; fin routine SCL1 ------------------------------------------------------------  



;****************************** StartBitI2C ***********************************
;       Nom de la fonction : StartBitI2C                       
;       Auteur : Anthony Groleau
;       Date de creation : 11/10/2022
;       Modification : 
;       Description :   Routine d'initiation d'une communication serie I2C. 
;                       Doit être appelee à chaque debut d'operation.
;                       Le passage de 1 à 0 sur la ligne SDA durant
;                       un niveau 1 sur la ligne SCL initie un START BIT.
;                                                       
;       Fonctions appelees   : SCL1, SDA0, SDA1
;       Paramètres d'entree  :            
;       Paramètres de sortie :            
;       Variables utilisees  : 
;       Include		     : P16F88.INC
;       Equate		     :                   
;       #Define		     :                    
;                                               
;******************************************************************************
StartBitI2C
     call   SCL1
     call   SDA1
     call   SDA0
     return
; fin routine StartBitI2C------------------------------------------------------

     

;******************************* StopBitI2C ***********************************
;       Nom de la fonction : StopBitI2C                 
;       Auteur : Anthony Groleau
;       Date de creation : 11/10/2022
;       Description :   Routine de clôture d'une communication serie I2C.
;                       Doit être appelee à la fin de toutes operations.
;                       Passage de 0 à 1 sur la ligne SDA durant
;                       un niveau 1 sur la ligne SCL initie un STOP BIT.
;                                                       
;       Fonctions appelees   : SCL1, SDA0, SDA1
;       Paramètres d'entree  :              
;       Paramètres de sortie :           
;       Variables utilisees  :  
;       Include		     : P16F88.INC
;       Equate		     :                   
;       #Define		     :               
;                                               
;******************************************************************************
StopBitI2C
     call   SCL1
     call   SDA0
     call   SDA1
     return
; fin routine StopBitI2C-------------------------------------------------------         
         
   
      
;******************************* Lire1BitI2C **********************************
;       Nom de la fonction : Lire1BitI2C                        
;       Auteur : Anthony Groleau
;       Date de creation : 11/10/2022
;       Modification :  
;       Description :   Routine de reception d'un bit de communication I2C.
;                       La routine prend le bit de la ligne SDA après avoir 
;                       active la ligne SCL. Le bit de donnee est place 
;                       temporairement dans la variable 'vI2CBits' et sera  
;                       reutilise dans la routine de traitement d'octets.
;                                                       
;       Fonctions appelees   : SCL0, SCL1, SDA0, SDA1
;       Paramètres d'entree  :             
;       Paramètres de sortie : vI2CBits
;       Variables utilisees  :  
;       Include		     : P16F88.INC
;       Equate		     :                 
;       #Define		     : SDA, I2CIN
;                                               
;******************************************************************************
Lire1BitI2C
     call   SCL0			; Permet au "slave" d'ecrire
   ; DELAI				; Attend qu'il est termine l'ecriture
     call   SCL1			; Fin de l'ecriture
     
     call   SDA1			; Debut de la lecture
     
     bcf    vI2CBits,I2CIN		; Assume le bit a zero
     btfsc  SDA				; Lit l'etat du SDA
     bsf    vI2CBits,I2CIN		; Ecrit 1 si le SDA est haut
     
     call   SCL0			; Fin de la lecture
     return
; fin routine Lire1BitI2C------------------------------------------------------



;****************************** Ecrire1BitI2C *********************************
;       Nom de la fonction : Ecrire1BitI2C                      
;       Auteur : Anthony Groleau
;       Date de creation : 11/10/2022
;       Description : Routine d'emission d'un bit de communication I2C.
;                     La routine utilise le bit 0 de la variable 'vI2CBits' 
;                     pour ajuster le niveau de la ligne SDA.  
;                     Les lignes SDA et SCL sont activee à tour de rôle pour 
;                     communiquer l'information du maître à l'esclave.
;                                                       
;       Fonctions appelees   : SCL0, SCL1, SDA0, SDA1
;       Paramètres d'entree  : vI2CBits
;       Paramètres de sortie : 
;       Variables utilisees  : 
;       Include              : P16F88.INC
;       Equate		     :               
;       #Define		     : I2COUT
;                                               
;******************************************************************************
Ecrire1BitI2C
     call   SCL0			; Debut de l'ecriture
     
     btfsc  vI2CBits,I2COUT	    	; Lit le bit a envoyer
     goto   Ecrire1BitI2C_Haut		; quand le bit est '1'
     goto   Ecrire1BitI2C_Bas		; quand le bit est '0'
     
Ecrire1BitI2C_Haut
     call   SDA1
     goto   Ecrire1BitI2C_Fin
     
Ecrire1BitI2C_Bas
     call   SDA0
     goto   Ecrire1BitI2C_Fin
     
Ecrire1BitI2C_Fin
     call   SCL1			; Fin de l'ecriture
   ; DELAI				; Temp de lecture pour le destinataire 
     call   SCL0			; 
     return
; fin routine Ecrire1BitI2C----------------------------------------------------



;***************************** Lire8BitsI2C ***********************************
;       Nom de la fonction : Lire8BitsI2C                      
;       Auteur : Anthony Groleau
;       Date de creation : 11/10/2022
;       Modification :  
;       Description :   Routine de reception de 8 bits de donnee 
;                       provenant du dispositif I2C.
;                       La donnee lue est memorisee dans la variable 'vI2COctet'
;                       Parlez de la gestion du Ack
;
;       Fonctions appelees   : StartBitI2C, StopBitI2C, 
;			       Lire1BitI2C, Ecrire1BitI2C
;       Paramètres d'entree  :           
;       Paramètres de sortie : vI2COctet
;       Variables utilisees  : vI2CBits
;       Include		     : P16F88.INC
;       Equate		     :                 
;       #Define		     : I2CIN, I2COUTACK
;                                               
;******************************************************************************
Lire8BitsI2C
     movlw  .8
     movwf  vI2CCompt
     
Lire8BitsI2C_Boucle
     call   Lire1BitI2C			; Lit un bit en provenance du I2C
     
     bcf    STATUS,C			; 
     rlf    vI2COctet			; Les 8 bits sont ecrit du plus
     btfsc  vI2CBits,I2CIN		; significant au moin significant
     bsf    vI2COctet,0			; 
     
     decfsz vI2CCompt			; Boucle sur les 8 bits
     goto   Lire8BitsI2C_Boucle		; a lire
     
; Fin de Boucle 
     
     rrf    vI2CBits			; Deplace le ACK dans OUT
     call   Ecrire1BitI2C		; Envoi le ACK au destinataire
     rlf    vI2CBits			; Reset les bits de vI2CBits
     
     return
; fin routine Lire8BitsI2C-----------------------------------------------------



;**************************  Ecrire8BitsI2C ***********************************
;       Nom de la fonction : Ecrire8BitsI2C
;       Auteur : Anthony Groleau
;       Date de creation : 11/10/2022
;       Modification :  
;       Description :   Routine d'ecriture d'un octet de donnee vers
;                       le dispositif I2C.
;                       L'octet a transmettre est dans la variable 'vI2COctet' 
;                       avant l'appel de la fonction.
;                       Parlez de la gestion du Ack                                
;       Fonctions appelees   : StartBitI2C, StopBitI2C, 
;			       Lire1BitI2C, Ecrire1BitI2C
;       Paramètres d'entree  : vI2COctet
;       Paramètres de sortie :     
;       Variables utilisees  : vI2CBits
;       Include		     : P16F88.INC
;       Equate		     :              
;       #Define		     : I2COUT, I2CIN, I2CINACK
;                                               
;******************************************************************************
Ecrire8BitsI2C
     movlw  .8
     movwf  vI2CCompt
     
Ecrire8BitsI2C_Boucle
     bcf    vI2CBits,I2COUT		; 
     btfsc  vI2COctet,7			; Prepare le MSB pour l'envoi
     bsf    vI2CBits,I2COUT		; 
     
     call   Ecrire1BitI2C		; Envoie 1 bit par I2C
     
     bcf    STATUS,C			; Les bits sont envoyer du
     rlf    vI2COctet			; MSB au LSB
     
     decfsz vI2CCompt			; Boucle sur les 8 bits
     goto   Ecrire8BitsI2C_Boucle	; a envoyer

; Fin de boucle 

     bcf    vI2CBits,I2CINACK		; 
     call   Lire1BitI2C			; Recoie le bit ACK et ecrit
     btfsc  vI2CBits,I2CIN		; le resultat dans I2CINACK
     bsf    vI2CBits,I2CINACK		; 
     
     return
; fin routine Ecrire8BitsI2C---------------------------------------------------
 
 

;***************************** EcrireMemI2C ***********************************
;       Nom de la fonction : EcrireMemI2C                                      
;       Auteur :                                          
;       Date de creation :                                  
;       Modification :                               
;       Description :   Routine de transmission d'un octet de donnee          
;                       vers la memoire I2C (24LC32).
;                       Genere les Start et les Stop.                  
;                                                                             
;       Fonctions appelees   :       
;       Paramètres d'entree  : vI2CAdrrH, vI2CAdrrB, vI2COctet
;       Paramètres de sortie : 
;       Variables utilisees  : vTempo, 
;       Include		     :                                          
;       Equate		     :                                                    
;       #Define		     :                                                     
;                                                                             
;******************************************************************************      
EcrireMemI2C
     movf   vI2COctet			; Sauvegarde les donnees dans un tampon
     movwf  vTempo			; pendant que l'adresse est envoye
     
     call   StartBitI2C			; Debut de la transmission
     
     movlw  b'10100000'			; 
     movwf  vI2COctet			; Appele le 24LC32 en ecriture
     call   Ecrire8BitsI2C		;
     
     movf   vI2CAdrrH			; 
     movwf  vI2COctet			; Moitie Haute de l'adresse memoire
     call   Ecrire8BitsI2C		; 
     
     movf   vI2CAdrrB			; 
     movwf  vI2COctet			; Moitie Basse de l'adresse memoire
     call   Ecrire8BitsI2C		; 

     movf   vTempo			; 
     movwf  vI2COctet			; Envoi les donnes a ecrire
     call   Ecrire8BitsI2C		; 
     
     call   StopBitI2C			; Fin de la transmission
     return
; fin routine EcrireMemI2C-----------------------------------------------------



;****************************** LireMemI2C ************************************
;       Nom de la fonction : LireMemI2C                  
;       Auteur :           
;       Date de creation :                            
;       Modification :  
;       Description :   Routine de reception d'un octet de donnee 
;                       provenant de la memoire I2C (24LC32).
;                       Genere les Start et les Stop. 
;                       Avant l'appel de la fonction: 
;                          Decrire les parametres d'entrees.
;                       A la sortie de la fonction:
;                          Decrire les parametres de sortie. 
;                       
;       Fonctions appelees :              
;       Paramètres d'entree :                   
;       Paramètres de sortie :                 
;       Variables utilisees : 
;       Include :              
;       Equate :                          
;       #Define : 
;                        
;******************************************************************************
LireMemI2C
     call   StartBitI2C			; Debut de la transmission
     
     movlw  b'10100000'			; 
     movwf  vI2COctet			; Appele le 24LC32 en ecriture
     call   Ecrire8BitsI2C		;
     
     movf   vI2CAdrrH			; 
     movwf  vI2COctet			; Moitie Haute de l'adresse memoire
     call   Ecrire8BitsI2C		; 
     
     movf   vI2CAdrrB			; 
     movwf  vI2COctet			; Moitie Basse de l'adresse memoire
     call   Ecrire8BitsI2C		; 
     
LireMemI2CSuivant
     call   StartBitI2C			; Debut de la transmission
     
     movlw  b'10100001'			; 
     movwf  vI2COctet			; Appele le 24LC32 en lecture
     call   Ecrire8BitsI2C		;
     
     call   Lire8BitsI2C		; Lit un octet
     
     call   StopBitI2C			; Fin de transmission
     return
; fin routine LireMemI2C-------------------------------------------------------



;******************************** Delai5us ************************************
;  Nom de la fonction : Delai      
;  Auteur :    
;       Date de creation :              
;  Description :   Routine de delai de 5 us.
;       Calcul du delai:
; 
;              
;  Fonctions appelees :        
;  Paramètres d'entree :        
;  Paramètres de sortie :        
;  Variables utilisees :    
;  Equate :      
;  #Define :      
;              
;******************************************************************************


; fin routine Delai5us---------------------------------------------------------



;****************************** Interruption **********************************
Interruption

;    movwf     w_temp         ; save off current W register contents
;    movf      STATUS,w       ; move STATUS register into W register
;    movwf     status_temp    ; save off contents of STATUS register
;    movf      PCLATH,W       ; move PCLATH register into W register
;    movwf     pclath_temp    ; save off contents of PCLATH register

; isr code can go here or be located as a call subroutine elsewhere


;    movf      pclath_temp,w  ; retrieve copy of PCLATH register
;    movwf     PCLATH         ; restore pre-isr PCLATH register contents
;    movf      status_temp,w  ; retrieve copy of STATUS register
;    movwf     STATUS         ; restore pre-isr STATUS register contents
;    swapf     w_temp,f
;    swapf     w_temp,w       ; restore pre-isr W register contents
    retfie                   ; return from interrupt

; fin de la routine Interruption-----------------------------------------------



        END                       ; directive 'end of program'





