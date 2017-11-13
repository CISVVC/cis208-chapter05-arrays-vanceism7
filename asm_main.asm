;
; file: asm_main.asm

%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
        syswrite: equ 4
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h

array:	dw 1,2,3,4,5,12

; uninitialized data is put in the .bss segment
;
segment .bss

;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
; *********** Start Assignment Code ********************
	
	lea	eax, [array]
	push	dword 3 ;scalar
	push	dword 6 ;Length of array
	push	eax
	call	ScaleArray
	add	esp, 12

; *********** End Assignment Code **********************

        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret

ScaleArray:
	;3 arguments:
	;[ebp+8]  : address of a[0]
	;[ebp+12] : length of array
	;[ebp+16] : scalar int
	enter	0,0

	mov	ebx, [ebp+16]
	mov	ecx, [ebp+12]
	mov	esi, [ebp+8]
	mov	edi, [ebp+8]

	;Multiply array by scalar
arr_loop:
	lodsw
	mul	bx
	stosw
	loop	arr_loop

	;Print the array
	mov	ecx, [ebp+12]
	mov	esi, [ebp+8]
print_loop:
	lodsw
	movsx	eax, ax
	call	print_int
	call	print_nl
	loop	print_loop

	leave
	ret
