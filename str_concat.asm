section .data
    str1  db  "1st string.",10,0
    str2  db  "This is the second string. I believe they can be very long; I reserved 128 bytes",10,0

section .bss
    len1  resb  2
    len2  resb  2
    tot   resb  2
    str3 resb  128

section .text
global  _start
_start:

    mov   rdi, str1
    call  _str_len
    mov   [len1], cl

    mov   rsi, str1
    xor   rdx, rdx
    mov   dx, [len1]
    call  _print

    mov   rdi, str2
    call  _str_len
    mov   [len2], cl

    mov   rsi, str2
    xor   rdx, rdx
    mov   dx, [len2]
    call  _print

    xor   rcx, rcx
    xor   rdx, rdx

    mov   rax, str1
    mov   rbx, str2
    mov   rdi, str3
    mov   cx, word [len1]
    mov   dx, word [len2]
    call  _concat

    mov   rsi, str3
    xor   rdx, rdx
    mov   dx,[len1]
    add   dx, [len2]
    call  _print

    call  _exit

;@param: str1 pointer in rax
;@param: str2 pointer in rbx
;@param: 2b int len of str1 in rcx
;@param: 2b int len of str2 in rdx
;@param: str3 pointer in rdi

;@return: str3 updated in mem
_concat:
    push  rax
    push  rbx
    push  rcx
    push  rdx
    push  rdi
    push  r15

    xor   r15, r15

    dec   rcx
s1  mov   r15b, [rax]
    mov   [rdi], r15b
    inc   rax
    inc   rdi
    loop  s1

    inc   rdi

    mov   rcx, rdx
    dec   rcx

s2  mov   r15b, [rbx]
    mov   [rdi], r15b
    inc   rbx
    inc   rdi
    loop  s2

    pop   r15
    pop   rdi
    pop   rdx
    pop   rcx
    pop   rbx
    pop   rax

;@param: str pointer in rsi
;@param: int len of str in rdx
_print:

  	push	rax
  	push	rdi

  	mov  	rax, 1
  	mov	  rdi, 1
  	syscall

  	pop	  rdi
  	pop	  rax

  	ret


;@param: str pointer in rdi
;@return: str pointer in rdi
;@return: int length of str in rcx
_str_len:

  	push	rdi

  	sub	  rcx, rcx
  	not	  rcx	;init rcx = max(64-bit) = immense =-1

  	sub	  ax, ax

  	cld
  repne	scasb  		;Compare al with byte at es:rdi then set status flags

  	not	  rcx	;gather length as ecx = -(strlen - 2)
  	dec	  rcx

  	pop	  rdi
  	ret



_exit:
    mov rax, 60
    xor rdi, rdi
    syscall
