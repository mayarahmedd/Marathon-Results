; demonstrate scan_num, print_num
;----------------------------------------

include 'emu8086.inc'
ORG    100h
mov cx,25          ;Load cx=25
lea di,numbers     ;Load dI by the first address in numbers table
lea si,time        ;Load SI by the first address in time table
jmp scanning       ;jump to scaning players numbers & time from user
space db '      ',0       
numbers dw 25 dup(?)        
time dw 25 dup(?)  
msg1   db  'Enter the player number: ' ,0  
msg2   DB  'Enter the recorded time: ', 0
str1 db "Numbers",0           ;str1 pointer on Numbers
str2 db "Time",0              ;str2 pointer on Time     
n_line      DB  0DH,0AH,'$'   ;new line 

Scanning:             ;Single function for both scanning
push   cx         
push si         
LEA    SI, msg1       ; ask for the number  
   
CALL   PRINT_STRING   ;printing msg1


CALL   scan_num       ;scaning player number from user 
 

LEA    dx,n_line      ;new line
MOV    ah,09h         ;displays string until '$' is reached
INT    21h            ;call the interrupt handler 0x21, DOS Function dispatcher.


mov [di] ,cx          
          
LEA    SI, msg2       
CALL   PRINT_STRING   ;printing msg2

CALL   scan_num       ;scaning recorded time from user
 
pop si             
mov [si] ,cx        
LEA    dx,n_line     
MOV    ah,09h         
INT    21h             
                               
                                       
add di,2                  ; increamenting di by 2 to move to the next number          
add si,2                  ; increamenting si by 2 to move to the next time      
pop cx                    ;
       
LEA    dx,n_line 
MOV    ah,09h         
INT    21h                
loop  scanning 
            
 

;.code

mov cx,25 

nextscan:
mov bx,cx
lea si,time
lea di,numbers
nextcomp:
mov ax,[si]
mov dx,[si+2]         ;increamenting si by 2 ,to move to next element (each element 16-bit)
cmp ax,dx             ;compare ax&dx(ax-dx)

jb noswap             ;jump noswap if below (ax<dx) Cf=1

mov [si],dx           ;else swap 
mov [si+2],ax         
mov ax,[di]
mov dx,[di+2]         
mov [di],dx
mov [di+2],ax         

noswap:               
add si,2              
add di,2
dec bx
jnz nextcomp

loop nextscan



LEA    dx,n_line 
MOV    ah,09h         
INT    21h

LEA    SI,STR1                 ;load address of STR1 in si 
CALL   PRINT_STRING            ;print string Numbers on screen
 
LEA    SI,space                
CALL   PRINT_STRING          ;print space on screen
 
LEA    SI,STR2               ;load address of STR2 in si 
CALL   PRINT_STRING          ;print string Time on screen
LEA    dx,n_line             ;new line
MOV    ah,09h                
INT    21h                    

                             
lea si,time                  ;load si by first address in time table 
lea di,numbers               ;load di by first address in numbers table               
mov cx,25                    ;load cx=25
printString:
    
mov    ax,[di]           
CALL   PRINT_NUM           ;printing player number
push   si                  ;push si to stack (address of time table)
LEA    SI,space            
CALL   PRINT_STRING        ;print space on screen
CALL   PRINT_STRING        ;print space on screen
pop    si                  ;pop si from stack (si carrying address of time table)
mov    ax,[si]             
CALL   PRINT_NUM           ;printing recorded time (stored at ax)
add    si,2                ;incremeanting si by 2 , to move to next time
add    di,2                ;incremeanting di by 2 ,to move to next number
LEA    dx,n_line           ;   
MOV    ah,09h              ;
INT    21h                 ;
loop printString           ;loop decreaments cx by 1 and loops until cx=0
 




  
  
  ; macros to define procs
DEFINE_SCAN_NUM       ;procedure that gets the multi-digit SIGNED number from the keyboard, and stores the result in CX register.
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM      ;procedure that prints a signed number in AX register
DEFINE_PRINT_NUM_UNS  ; required for print_num.

