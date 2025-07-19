%ifndef _CHESS_BOARD
%define _CHESS_BOARD

section .data

whole_board:

white_pawn_board: dq 0xff000000000000
white_knight_board: dq 0x4200000000000000
white_bishop_board: dq 0x2400000000000000
white_rook_board: dq 0x8100000000000000
white_queen_board: dq 0x800000000000000
white_king_board: dq 0x1000000000000000

black_pawn_board: dq 0xff00
black_knight_board: dq 0x42
black_bishop_board: dq 0x24
black_rook_board: dq 0x81
black_queen_board: dq 0x8
black_king_board: dq 0x10

whole_board_end:

pieces_chars: db "PNBRQKpnbrqk.", 0
new_line: db 0xA, 0


section .text

%include "src/macros.asm"

print_board:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    push rbx
    push rcx

    xor rcx, rcx
    ; rcx is the loop counter
    print_board_loop:
        ; for (rcx = 0; rcx <= BOARD_SIZE; rcx ++)
        cmp rcx, BOARD_SIZE
        jne print_board_piece

        write_char_to_stdout new_line

        pop rcx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret
        print_board_piece:
            push rcx
            test rcx, 7
            jne dont_print_newline
            ; if rcx % 8 == 0
            push rcx
            ; print \n
            write_char_to_stdout new_line
            pop rcx
            dont_print_newline:
                mov rdi, rcx
                call get_piece_by_bit
                ; print board[index] as char
                ; P for white pawn
                ; p for black pawn
                write_char_to_stdout rax
        pop rcx
        inc rcx
        jmp print_board_loop

get_board_by_bit:
    mov rax, whole_board
    ; for (rax = whole_board; rax != whole_board_end; rax += 8)
    get_board_by_bit_loop:
        cmp rax, whole_board_end
        je get_board_by_bit_end
        bt [rax], rdi
        jc get_board_by_bit_end
        add rax, 8
        jmp get_board_by_bit_loop

    get_board_by_bit_end:
    ret

get_piece_by_bit:
    call get_board_by_bit
    mov rbx, whole_board
    sub rax, rbx
    ; rax /= 8
    shr rax, 3

    add rax, pieces_chars

    get_piece_by_bit_end:
        ret

move_piece:
    ; rdi is only argument, only 12 lower bits matter, e.g.
    ; 100 001 100 011 = e2e4
    ; 001 000 010 010 = b1c3
    push rbp
    mov rbp, rsp
    sub rsp, 8

    ; save rdi
    mov rdx, rdi

    ; take the first move row
    shr rdi, 9
    and rdi, 0b111

    ; take the first move column
    mov rbx, rdx
    shr rbx, 6
    and rbx, 0b111

    ; rbx = 7 - rbx
    neg rbx
    add rbx, 7
    ; rbx *= 8
    shl rbx, 3

    ; rdi is the interesting square
    add rdi, rbx


    call get_board_by_bit
    ; rax is pointing to the correct board
    cmp rax, whole_board_end
    je move_piece_end

    ; delete piece at the correct square
    mov rcx, rdi
    mov r8, 1
    shl r8, cl
    xor QWORD [rax], r8

    ; put piece on new square
    ; take the second move row
    mov rcx, rdx
    shr rcx, 3
    and rcx, 0b111

    ; take the second move column
    mov rbx, rdx
    and rbx, 0b111

    ; rbx = 7 - rbx
    neg rbx
    add rbx, 7
    ; rbx *= 8
    shl rbx, 3

    ; rcx is the interesting square
    add rcx, rbx

    mov r8, 1
    shl r8, cl
    xor QWORD [rax], r8

    move_piece_end:
    mov rsp, rbp
    pop rbp
    ret

%endif