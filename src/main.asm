section .text
global _start

%include "src/macros.asm"
%include "src/board.asm"
%include "src/user.asm"

_start:
    call print_board
    call get_user_move
    mov rdi, rax
    call move_piece
_fin:
    mov rax, SYS_EXIT
    mov rdi, 0
    ; exit(0)
    syscall
