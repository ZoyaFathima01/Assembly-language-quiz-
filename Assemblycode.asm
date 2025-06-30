section .data
    a dd 4
    b dd 3
    c dd 2
    d dd 5
    x dd 0
    result_msg db "Result: ", 0
    newline db 10

section .bss
    buffer resb 10   ; buffer for number to string conversion

section .text
    global _start

_start:
    ; Multiply a * b → eax
    mov eax, [a]
    mov ebx, [b]
    imul ebx

    ; Save result in ecx
    mov ecx, eax

    ; Multiply c * d → eax
    mov eax, [c]
    mov ebx, [d]
    imul ebx

    ; Add (a*b) + (c*d)
    add eax, ecx

    ; Store result in x
    mov [x], eax

    ; Convert eax to string in buffer
    mov edi, buffer + 9    ; point to end of buffer
    mov byte [edi], 0      ; null terminator
    dec edi

    mov ebx, 10

.convert_loop:
    xor edx, edx
    div ebx                 ; divide eax by 10, remainder in edx
    add dl, '0'             ; convert digit to ASCII
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .convert_loop

    inc edi                 ; edi points to first digit now

    ; Print "Result: "
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 8
    int 0x80

    ; Print number string
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, buffer + 10
    sub edx, edi
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit cleanly
    mov eax, 1
    xor ebx, ebx
    int 0x80
