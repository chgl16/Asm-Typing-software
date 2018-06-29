;-------�����������¼ʱ�䣬��ʾ�ɼ�--------

DSEG    SEGMENT 'DATA'
      ;;;;;;;���ݶ�;;;;;;;;;;
      INFOMENU DB '### Typing software (0.0.1-SNAPSHOT) ###',0AH,0DH,'$'
      WELCOMEMENU DB '* Welcome *',0AH,0DH,'$'
      STARTMENU  DB '* Press 'Enter' to start! *',0AH,0DH,'$'
      EXITMENU  DB '* Press 'Esc' to exit! *',0AH,0DH,'$'
      EXITTIP DB '* Goodbye, welcome to use again! *',0AH,0DH,'$' 
      EXAMPLETIP DB 'Example statement:',0AH,0DH,'$'
      EXAMPLESTATEMENT DB 'ABC123hello55world666',0AH,0DH,'$'
      AUTHOR DB '@Copyright 2018.6,JNU_LIN',0AH,0DH,'$'
      SCORETIP DB 'Score:','$'
      TIMETIP DB 'Time:','$'
      SCORE DB 0
      TIME DB '00:00:00','$'
      DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
      db   256  DUP(0)
SSEG    ENDS


;;;;;;;;;��;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRESS Esc TO EXIT    ; �������Ͼ�궨��,��Ʊ���
SCROLL    MACRO     N,ULR,ULC,LRR,LRC,ATT	;�궨��
          MOV       AH,6				;�������Ͼ�
          MOV       AL,N		;N=�Ͼ�������N=0ʱ���������ڿհ�
          MOV       CH,ULR		;���Ͻ��к�
          MOV       CL,ULC		;���Ͻ��к�
          MOV       DH,LRR		;���½��к�
          MOV       DL,LRC		;���½��к�
          MOV       BH,ATT		;����������
          INT       10H
          ENDM                                          ;;;;;;;;;; �� ;;;;;;;;;;;;;;;;
  
;;;;;;;;��ƹ��         
CURSE     MACRO     CURY,CURX    
          MOV       AH,2		     	;�ù��λ��
          MOV       DH,CURY			;�к�
          MOV       DL,CURX			;�к�
          MOV       BH,0			;��ǰҳ
          INT       10H
          ENDM
          
          
          
;;;;;�����;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CSEG    SEGMENT 'CODE'
   START   PROC    FAR
      ; set segment registers:
      MOV AX, DSEG
      MOV DS, AX
      MOV ES, AX


      ;;;;�ý����ӳ���;;;
      CALL MAINVIEW
      
      
    
      ;;;�����˳�;;;
      CURSE  17,36	
      GET1:
          MOV CX,30 ;��һ���ַ���
      GET2:     
          MOV AH,0 ;�ȴ�����
      INT 16H	
      CMP AH,1	;�Ƿ�ΪESC����  AH=1
      JZ TOEXIT	;�ǣ��˳�
      
      ;;���Ǻ��ж��Ƿ�ΪEnter����ʼ
      CMP AL, 13  ; 13=0D
      JZ BEGIN ;�ǣ���ʼ
      
      
      ;;������Щ�Ǵ��ֲ���Ҫ
      ;MOV AH,0EH ;��ʾ������ַ�
      ;INT  10H
      ;LOOP GET2
      ;SCROLL 1,8,20,18,50,2FH			;�Ͼ�һ��
      ;CURSE  18,20
      JMP GET1
      
      
      ;�����˳������ӳ��� --------------------------------
      TOEXIT:
      CALL EXITVIEW
      JMP EXITPROCESS
      
      ;���ô��ֳ��� --------------------------------------
      BEGIN:
      CALL TYPEVIEW 
     
      
      
      EXITPROCESS: ;���ս���
      ;;;;;;;;;;;;;;;;
      MOV AX, 4C00h ; exit to operating system.
      INT 21h    
   START   ENDP
   ;���������----------------------------------------------
   
   
   ;�������ӳ���-----------------------------------------
   MAINVIEW PROC 
      ;;;;���ô�ӡ����
      SCROLL    0,0,0,24,79,02		;����
      SCROLL    40,0,0,30,80,50H		;���ⴰ�ڣ�Ʒ���
      SCROLL    38,1,2,23,76,2FH	;���ڴ��ڣ��̵װ���
      
      ;;��ӡ�˵�;;
      
      ;;��ӡinfo��Ϣ�˵�
      CURSE  3,19			;�ù����7��32��
      MOV AH, 9
      LEA DX, INFOMENU
      INT 21H
      
      ;;��ӡWelcome�˵�
      CURSE  7,32			;�ù����7��32��
      MOV AH, 9
      LEA DX, WELCOMEMENU
      INT 21H
      
      ;;��ӡ��ʼstart�˵�
      CURSE 10,25
      MOV AH, 9
      LEA DX, STARTMENU
      INT 21H
      
      ;;;��ӡ�˳��˵�
      CURSE 13,26
      MOV AH, 9
      LEA DX, EXITMENU
      INT 21H
      
      ;;;��ӡ������Ϣ
      CURSE 23,51
      MOV AH, 9
      LEA DX, AUTHOR
      INT 21H
      
      RET
   MAINVIEW ENDP
   ;�����ӳ������------------------------------------

   
 
   ;�˳������ӳ���------------------------------------
   EXITVIEW PROC
      ;;;;;;�˳�����;;;;;
      SCROLL    0,0,0,24,79,7		;����f
      SCROLL    40,0,0,30,80,50H		;���ⴰ�ڣ�Ʒ���
      SCROLL    38,1,2,23,76,2FH	;���ڴ��ڣ��̵װ���
      
      ;;; ��ӡ�˳���Ϣ
      CURSE  11,22		
      MOV AH, 9
      LEA DX, EXITTIP
      INT 21H

      RET
   EXITVIEW ENDP
   ;�˳��ӳ������----------------------------------------
   
   ;����������--------------------------------------------
   TYPEVIEW PROC
       ;;����
      ;;;;���ô�ӡ����
      SCROLL    0,0,0,24,79,02		;����
      SCROLL    40,0,0,30,80,50H		;���ⴰ�ڣ�Ʒ���
      SCROLL    38,1,2,23,76,2FH	;���ڴ��ڣ��̵װ���
      
      ;;��ӡ�˵�;;                                                            
      
      ;;��ӡ������ʾ��Ϣ
      CURSE  4,10			;�ù����7��32��
      MOV AH, 9
      LEA DX, EXAMPLETIP
      INT 21H
      
      
      ;;��ӡ����
      CURSE 5,29
      MOV AH, 9
      LEA DX, EXAMPLESTATEMENT
      INT 21H
      
      ;;��ӡ�ɼ���ʾ
      CURSE 20, 18
      MOV AH, 9
      LEA DX, SCORETIP
      INT 21H
      ;��ӡ�ɼ�
      CURSE 20,25
      MOV AH, 2
      MOV DL, SCORE
      ADD DL, 30H
      INT 21H
      
      ;;��ӡʱ����ʾ
      CURSE 20, 50
      MOV AH, 9
      LEA DX, TIMETIP
      INT 21H
      ;��ӡʱ��
      CURSE 20,55
      MOV AH, 9
      MOV DX, OFFSET TIME
      INT 21H
      
      ;;;;;;;;@LIN;;;;;;;;
      ;;;��������;;;
      CURSE  8,27
     
      
      MOV AH, 2
      MOV DL, '>'
      INT 21H
      MOV AH, 2
      MOV DL, ' '
      INT 21H
 
      
      MOV BL, 30 ;������ֿ�ʼ��λ��
      MOV DI, 0 ;������ȡ����ƥ��
      	
      GET3:
          MOV CX,30 ;��һ���ַ���
      GET4:     
          MOV AH,0 ;�ȴ�����
      INT 16H	
      CMP AH,1	;�Ƿ�ΪESC����  AH=1
      JZ TOEXIT2 ;�ǣ��˳�
      
      ;CMP AL, 13
      ;JZ TYPEEND ;����Ϊ��Enter'��������ʾ�ɼ�
      
      MOV AH,0EH ;��ʾ������ַ�
      INT  10H
      
      ;�˴��ж�ƥ��ɼ�----------------------
      CMP AL, EXAMPLESTATEMENT[DI]
      JNZ NEXT
      
      INC SCORE
      ;��ӡ�ɼ�
      CURSE 20,25
      MOV AH, 2
      MOV DL, SCORE
      ADD DL, 30H
      INT 21H 
      CURSE  8,BL   ;�ص����ִ�
      
      NEXT:
      INC DI
      INC BL
      LOOP GET4
      
      SCROLL 1,8,20,18,50,2FH			;�Ͼ�һ��
      CURSE  18,20
      JMP GET3
      
      
      
      TOEXIT2:
      CALL EXITVIEW
      
      RET
   TYPEVIEW ENDP
   ;�����ӳ������--------------------------------------
   
CSEG    ENDS
END    START    ; set entry point.
