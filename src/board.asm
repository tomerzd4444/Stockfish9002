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

get_piece_by_bit:
    mov rbx, whole_board
    mov rax, pieces_chars
    loop_start:
        ; If we got to '.' we searched through all of the pieces
        cmp byte [rax], '.'
        je get_piece_by_bit_end
        bt [rbx], rdi
        ; bt sets the carry flag, not the zero flag so we need `jc` and not `je`
        jc get_piece_by_bit_end
        add rbx, QWORD_SIZE
        inc rax
        jmp loop_start

    get_piece_by_bit_end:
        ret

move_piece:
    ; rdi is only argument, only 12 lower bits matter, e.g.
    ; 100 010 100 100 = e2e4
    ; 001 001 010 011 = b1c3
    ret