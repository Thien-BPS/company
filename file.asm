section .data
    hi: db "Hello there.", 10 ; Main string
    hiLen: equ $-hi ; String's length

section .bss


section .text
    global _start ; Entry point
    _start: ; Main function
        mov rax,1 ; sys_write
        mov rdi,1 ; Standard Output
        mov rsi,hi ; Write the message
        mov rdx,hiLen ; Write the message length
        syscall ; call kernel

        ; End the program (sysexit)
        mov rax,60 ; sysexit
        mov rdi,0 ; exit status 0
        syscall ; call kernel again