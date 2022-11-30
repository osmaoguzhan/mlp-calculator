STDOUT 		equ 1
SYS_EXIT 	equ 1
SYS_WRITE 	equ 4
SYS_READ 	equ 3
STDIN 		equ 0
%define SYSCALL int 0x80

section .data   
	nLine 	db	 '',0xA,0xD

;------------------------------
; print given message
;------------------------------
%macro print 1
	mov 	eax, %1
	call 	pprint
%endmacro

;------------------------------
; get input from user
;------------------------------
%macro input 1
	mov		ecx, %1  
	mov		edx, 6
	mov		eax, SYS_READ
	mov		ebx, STDIN
	SYSCALL
%endmacro

;------------------------------
; print new line
;------------------------------
print_new_line:
	mov		ecx, nLine
	mov		edx, 1
	mov     ebx, STDOUT
    mov     eax, SYS_WRITE
    SYSCALL
	ret

;------------------------------
; print procedure
; Note: Requires 0Ah (null byte at the end of the message)
;------------------------------
print_string:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    strlen
 
    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, STDOUT
    mov     eax, SYS_WRITE
    SYSCALL
 
    pop     ebx
    pop     ecx
    pop     edx
    ret
 
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    strlen
 
    mov     edx, eax
    pop     eax
 
    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h
 
    pop     ebx
    pop     ecx
    pop     edx
    ret
;------------------------------
; print procedure
; Note: Does not requires 0Ah (null byte at the end of the message)
;------------------------------
print_string_lf:
	call 	print_string 	; printing the message
	push 	eax				 
	mov		eax, 0h		; pushing null byte to eax
	;push	eax
	;mov		eax, esp
	call 	print_string
	;pop		eax
	pop		eax
	ret

;------------------------------
; read user input
;------------------------------
scan:
	mov		eax, SYS_READ
	mov		ebx, STDIN
	SYSCALL
	ret

;------------------------------
; stores the length of the string in eax
;------------------------------
strlen:
	push 	ebx			; push ebx to stack to preserve
	mov		ebx, eax	; point to the same address
next:
	cmp		byte [eax], 0	; zero is the end of the string
	jz		end				; if the condition is satisfied, jump to end
	inc		eax				; if the condition is not satisfied, increment 1 byte
	jmp		next			; loop
end:
	sub		eax, ebx		; eax is increased so eax - ebx will give the length (byte difference between addresses) of the string. 
	pop 	ebx				
	ret


to_int:
    .prepare:
        push    edx
        push    ecx
        xor     eax, eax 
    .convert:
        movzx   ecx, byte [edx] ; get a character
        inc     edx ; ready for next one
        cmp     ecx, '0' ; valid?
        jb      .finish
        cmp     ecx, '9'
        ja      .finish
        sub     ecx, '0' ; "convert" character to number
        imul    eax, 10 ; multiply "result so far" by ten
        add     eax, ecx ; add in current digit
        jmp     .convert ; until done
    .finish:
        pop     ecx
        pop     edx
        ret



    ;pop     esi             ; restore esi from the value we pushed onto the stack at the start
    ;pop     edx             ; restore edx from the value we pushed onto the stack at the start
    ;pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
   ; pop     ebx             ; restore ebx from the value we pushed onto the stack at the start
   ; ret
iprint:
    push    eax             ; preserve eax on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     ecx, 0          ; counter of how many bytes we need to print in the end
 
divideLoop:
    inc     ecx             ; count each byte to print - number of characters
    mov     edx, 0          ; empty edx
    mov     esi, 10         ; mov 10 into esi
    idiv    esi             ; divide eax by esi
    add     edx, 48         ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push    edx             ; push edx (string representation of an intger) onto the stack
    cmp     eax, 0          ; can the integer be divided anymore?
    jnz     divideLoop      ; jump if not zero to the label divideLoop
 
printLoop:
    dec     ecx             ; count down each byte that we put on the stack
    mov     eax, esp        ; mov the stack pointer into eax for printing
    call    sprint          ; call our string print function
    pop     eax             ; remove last character from the stack to move esp forward
    cmp     ecx, 0          ; have we printed all bytes we pushed onto the stack?
    jnz     printLoop       ; jump is not zero to the label printLoop
 
    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     eax
    ret

iprintLF:
    call    iprint          ; call our integer printing function
 
    push    eax             ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     eax, 0Ah        ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    eax             ; push the linefeed onto the stack so we can get the address
    mov     eax, esp        ; move the address of the current stack pointer into eax for sprint
    call    sprint          ; call our sprint function
    pop     eax             ; remove our linefeed character from the stack
    pop     eax             ; restore the original value of eax before our function was called
    ret








;------------------------------
; exit
;------------------------------
exit:
	mov		eax, SYS_EXIT
	SYSCALL
	ret