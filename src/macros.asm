%ifndef _CHESS_MACROS
%define _CHESS_MACROS

%define SYS_WRITE        1
%define SYS_EXIT         60
%define STDIN            0
%define STDOUT           1
%define CHAR_SIZE        1
%define QWORD_SIZE       8
%define BOARD_SIZE       0x40
%define NUMBER_OF_PIECES 12

%macro write_char_to_stdout 1
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, CHAR_SIZE
    mov rax, SYS_WRITE
    ; write(STDOUT, char, 1)
    syscall
%endmacro

%endif
