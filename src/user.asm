%include "src/macros.asm"

section .text

convert_string_to_bits:
    ; e.g. rdi is e2e4, rax should be 100 001 100 011
    push rbp
    mov rbp, rsp
    sub rsp, 8
    
    push rbx
    xor rax, rax
    xor rcx, rcx

    covnert_char_to_bit:
        xor rbx, rbx
        cmp rcx, 4
        je convert_string_to_bits_end
        mov bl, byte [rdi + rcx]
        test rcx, 1
        jne convert_digit_to_bit
        sub rbx, 'a'
        jmp covnert_char_to_bit_loop_end
        convert_digit_to_bit:
            sub rbx, '1'
        covnert_char_to_bit_loop_end:
        or rax, rbx
        shl rax, 3
        inc rcx
        jmp covnert_char_to_bit
    
    convert_string_to_bits_end:
    shr rax, 3
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
    ret

get_user_move:
    push rbp
    mov rbp, rsp
    sub rsp, 4

    mov rdi, STDIN
    mov rsi, rsp
    mov rdx, 4
    xor rax, rax
    syscall

    mov rdi, rsi
    call convert_string_to_bits

    mov rsp, rbp
    pop rbp
    ret