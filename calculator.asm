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
    firstMsg db 'Please enter the first number: ', 0h
    secondMsg db 'Please enter the second number: ', 0h  
    resultMsg db 'Result: ', 0h,
    incrementMsg db 'Please enter number to increment: ', 0h,
    decrementMsg db 'Please enter number to decrement: ', 0h,
    testMsg db 'This is the test message', 0h
    bye db 'Bye bye!', 0h
    
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

%macro print_result 0
    push    eax
    display_message resultMsg
    pop     eax
    call    print_integer
    call    print_new_line
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
    .menu:
        call    display_menu
        input   choice
        ;display_message menuDesign
        ;call print_new_line
        mov 	edx, choice
        call    to_int
        cmp     eax, 8
        je      .exit
        cmp     eax, 7
        je      .decrement
        cmp     eax, 6
        je      .increment
        cmp     eax, 5
        je      .modulo
        cmp     eax, 4
        je      .division
        cmp     eax, 3
        je      .multiplication
        cmp     eax, 2
        je      .subtraction
        cmp     eax, 1
        je      .addition
        loop    .menu
    .addition:
        display_message firstMsg
        input   first
        mov 	edx, first
        call    to_int
        mov     ebx, eax
        push    ebx
        display_message secondMsg
        input   second
        mov 	edx, second
        call    to_int
        pop     ebx
        add     eax, ebx
        print_result
        jmp     .menu
    .subtraction:
        display_message firstMsg
        input   first
        mov 	edx, first
        call    to_int
        mov     ebx, eax
        push    ebx
        display_message secondMsg
        input   second
        mov 	edx, second
        call    to_int
        pop     ebx
        mov     edx, eax
        mov     eax, ebx
        sub     eax, edx
        print_result
        jmp     .menu
    .multiplication:
        display_message firstMsg
        input   first
        mov 	edx, first
        call    to_int
        mov     ebx, eax
        push    ebx
        display_message secondMsg
        input   second
        mov 	edx, second
        call    to_int
        pop     ebx
        mul     ebx
        print_result
        jmp     .menu
    .division:
        display_message firstMsg
        input   first
        mov 	edx, first
        call    to_int
        mov     ebx, eax
        push    ebx
        display_message secondMsg
        input   second
        mov 	edx, second
        call    to_int
        pop     ebx
        mov     ecx, eax
        mov     eax, ebx
        mov     edx, 0
        div     ecx
        print_result
        jmp     .menu
    .modulo:
        display_message firstMsg
        input   first
        mov 	edx, first
        call    to_int
        mov     ebx, eax
        push    ebx
        display_message secondMsg
        input   second
        mov 	edx, second
        call    to_int
        pop     ebx
        mov     ecx, eax
        mov     eax, ebx
        mov     edx, 0
        div     ecx
        mov     eax, edx
        print_result
        jmp     .menu
    .increment:
        display_message incrementMsg
        input   first
        mov 	edx, first
        call    to_int
        inc     eax
        print_result
        jmp     .menu
    .decrement:
        display_message decrementMsg
        input   first
        mov 	edx, first
        call    to_int
        dec     eax
        print_result
        jmp     .menu
    .exit:
        display_message bye
        call 	print_new_line
        call 	exit