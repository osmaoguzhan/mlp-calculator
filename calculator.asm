%include 'functions.asm'

section .data
    menuDesign db  '****************************', 0h
    additionMenuItem db '1 - Addition', 0h
    subtractionMenuItem db '2 - Subtraction', 0h
    multiplicationMenuItem db '3 - Multiplication', 0h
    divisionMenuItem db '4 - Division', 0h
    moduloMenuItem db '5 - Modulo', 0h
    incrementMenuItem db '6 - Increment', 0h
    decrementMenuItem db '7 - Decrement', 0h
    exitMenuItem db '8 - Exit', 0h
    yourChoice db 'Your choice: ', 0h
    firstMsg db 'Please enter the first digit: ', 0h
    secondMsg db 'Please enter the second digit: ', 0h  
    resultMsg db 'Result: ', 0h,
    incrementMsg db 'Please enter number to increment: ', 0h,
    decrementMsg db 'Please enter number to decrement: ', 0h,
    testMsg db 'This is the test message', 0h
    
section .bss          
   first resb 6
   second resb 6
   result resb 6
   choice resb 1

section .text
   global _start

%macro display_message 1
    mov     eax, %1
    call 	print_string
%endmacro

display_menu:
    display_message menuDesign
    call print_new_line
    display_message additionMenuItem
    call print_new_line
    display_message subtractionMenuItem
    call print_new_line
    display_message multiplicationMenuItem
    call print_new_line
    display_message divisionMenuItem
    call print_new_line
    display_message moduloMenuItem
    call print_new_line
    display_message incrementMenuItem
    call print_new_line
    display_message decrementMenuItem
    call print_new_line
    display_message exitMenuItem
    call print_new_line
    display_message menuDesign
    call print_new_line
    display_message yourChoice
    ret

_start:
	display_message firstMsg
	input 	first
	
	;mov 	eax, secondMsg
    ;call 	print_string
    ;display_message secondMsg
    ;input 	second

    mov     edx, first
    call    to_int

    ;mov     eax, 100    ; move our first number into eax
    mov     ebx, 10     ; move our second number into ebx
    mul     ebx         ; multiply eax by ebx
    call    iprint
    call    exit