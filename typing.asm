;-------打字软件，记录时间，显示成绩--------

DSEG    SEGMENT 'DATA'
      ;;;;;;;数据段;;;;;;;;;;
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


;;;;;;;;;宏;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRESS Esc TO EXIT    ; 清屏或上卷宏定义,设计背景
SCROLL    MACRO     N,ULR,ULC,LRR,LRC,ATT	;宏定义
          MOV       AH,6				;清屏或上卷
          MOV       AL,N		;N=上卷行数；N=0时，整个窗口空白
          MOV       CH,ULR		;左上角行号
          MOV       CL,ULC		;左上角列号
          MOV       DH,LRR		;右下角行号
          MOV       DL,LRC		;右下角列号
          MOV       BH,ATT		;卷入行属性
          INT       10H
          ENDM                                          ;;;;;;;;;; 宏 ;;;;;;;;;;;;;;;;
  
;;;;;;;;设计光标         
CURSE     MACRO     CURY,CURX    
          MOV       AH,2		     	;置光标位置
          MOV       DH,CURY			;行号
          MOV       DL,CURX			;列号
          MOV       BH,0			;当前页
          INT       10H
          ENDM
          
          
          
;;;;;代码段;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CSEG    SEGMENT 'CODE'
   START   PROC    FAR
      ; set segment registers:
      MOV AX, DSEG
      MOV DS, AX
      MOV ES, AX


      ;;;;用界面子程序;;;
      CALL MAINVIEW
      
      
    
      ;;;键盘退出;;;
      CURSE  17,36	
      GET1:
          MOV CX,30 ;置一行字符数
      GET2:     
          MOV AH,0 ;等待输入
      INT 16H	
      CMP AH,1	;是否为ESC键？  AH=1
      JZ TOEXIT	;是，退出
      
      ;;不是后判断是否为Enter键开始
      CMP AL, 13  ; 13=0D
      JZ BEGIN ;是，开始
      
      
      ;;以下这些是打字才需要
      ;MOV AH,0EH ;显示输入的字符
      ;INT  10H
      ;LOOP GET2
      ;SCROLL 1,8,20,18,50,2FH			;上卷一行
      ;CURSE  18,20
      JMP GET1
      
      
      ;调用退出界面子程序 --------------------------------
      TOEXIT:
      CALL EXITVIEW
      JMP EXITPROCESS
      
      ;调用打字程序 --------------------------------------
      BEGIN:
      CALL TYPEVIEW 
     
      
      
      EXITPROCESS: ;最终结束
      ;;;;;;;;;;;;;;;;
      MOV AX, 4C00h ; exit to operating system.
      INT 21h    
   START   ENDP
   ;主程序结束----------------------------------------------
   
   
   ;主界面子程序-----------------------------------------
   MAINVIEW PROC 
      ;;;;调用打印背景
      SCROLL    0,0,0,24,79,02		;清屏
      SCROLL    40,0,0,30,80,50H		;开外窗口，品红底
      SCROLL    38,1,2,23,76,2FH	;开内窗口，绿底白字
      
      ;;打印菜单;;
      
      ;;打印info信息菜单
      CURSE  3,19			;置光标于7行32列
      MOV AH, 9
      LEA DX, INFOMENU
      INT 21H
      
      ;;打印Welcome菜单
      CURSE  7,32			;置光标于7行32列
      MOV AH, 9
      LEA DX, WELCOMEMENU
      INT 21H
      
      ;;打印开始start菜单
      CURSE 10,25
      MOV AH, 9
      LEA DX, STARTMENU
      INT 21H
      
      ;;;打印退出菜单
      CURSE 13,26
      MOV AH, 9
      LEA DX, EXITMENU
      INT 21H
      
      ;;;打印作者信息
      CURSE 23,51
      MOV AH, 9
      LEA DX, AUTHOR
      INT 21H
      
      RET
   MAINVIEW ENDP
   ;界面子程序结束------------------------------------

   
 
   ;退出结束子程序------------------------------------
   EXITVIEW PROC
      ;;;;;;退出用语;;;;;
      SCROLL    0,0,0,24,79,7		;清屏f
      SCROLL    40,0,0,30,80,50H		;开外窗口，品红底
      SCROLL    38,1,2,23,76,2FH	;开内窗口，绿底白字
      
      ;;; 打印退出信息
      CURSE  11,22		
      MOV AH, 9
      LEA DX, EXITTIP
      INT 21H

      RET
   EXITVIEW ENDP
   ;退出子程序结束----------------------------------------
   
   ;打字主程序--------------------------------------------
   TYPEVIEW PROC
       ;;背景
      ;;;;调用打印背景
      SCROLL    0,0,0,24,79,02		;清屏
      SCROLL    40,0,0,30,80,50H		;开外窗口，品红底
      SCROLL    38,1,2,23,76,2FH	;开内窗口，绿底白字
      
      ;;打印菜单;;                                                            
      
      ;;打印例句提示信息
      CURSE  4,10			;置光标于7行32列
      MOV AH, 9
      LEA DX, EXAMPLETIP
      INT 21H
      
      
      ;;打印例句
      CURSE 5,29
      MOV AH, 9
      LEA DX, EXAMPLESTATEMENT
      INT 21H
      
      ;;打印成绩提示
      CURSE 20, 18
      MOV AH, 9
      LEA DX, SCORETIP
      INT 21H
      ;打印成绩
      CURSE 20,25
      MOV AH, 2
      MOV DL, SCORE
      ADD DL, 30H
      INT 21H
      
      ;;打印时间提示
      CURSE 20, 50
      MOV AH, 9
      LEA DX, TIMETIP
      INT 21H
      ;打印时间
      CURSE 20,55
      MOV AH, 9
      MOV DX, OFFSET TIME
      INT 21H
      
      ;;;;;;;;@LIN;;;;;;;;
      ;;;键盘输入;;;
      CURSE  8,27
     
      
      MOV AH, 2
      MOV DL, '>'
      INT 21H
      MOV AH, 2
      MOV DL, ' '
      INT 21H
 
      
      MOV BL, 30 ;保存打字开始列位置
      MOV DI, 0 ;用来读取例句匹配
      	
      GET3:
          MOV CX,30 ;置一行字符数
      GET4:     
          MOV AH,0 ;等待输入
      INT 16H	
      CMP AH,1	;是否为ESC键？  AH=1
      JZ TOEXIT2 ;是，退出
      
      ;CMP AL, 13
      ;JZ TYPEEND ;输入为‘Enter'结束，显示成绩
      
      MOV AH,0EH ;显示输入的字符
      INT  10H
      
      ;此处判断匹配成绩----------------------
      CMP AL, EXAMPLESTATEMENT[DI]
      JNZ NEXT
      
      INC SCORE
      ;打印成绩
      CURSE 20,25
      MOV AH, 2
      MOV DL, SCORE
      ADD DL, 30H
      INT 21H 
      CURSE  8,BL   ;回到打字处
      
      NEXT:
      INC DI
      INC BL
      LOOP GET4
      
      SCROLL 1,8,20,18,50,2FH			;上卷一行
      CURSE  18,20
      JMP GET3
      
      
      
      TOEXIT2:
      CALL EXITVIEW
      
      RET
   TYPEVIEW ENDP
   ;打字子程序结束--------------------------------------
   
CSEG    ENDS
END    START    ; set entry point.
