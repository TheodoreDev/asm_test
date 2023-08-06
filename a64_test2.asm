bits 64

extern GetStdHandle
extern WriteConsoleA
extern ReadConsoleA
extern ExitProcess

STD_OUTPUT_HANDLE equ -11
STD_INTPUT_HANDLE equ -10
SHADOWSPACE_SIZE equ 32 + 8
NULL equ 0

section .data
    message db "What's your username ? "
    MESSAGE_LENGTH equ $-message
    welcome_message db "Welcome back sir !", 10
    WELCOME_MESSAGE_LENGTH equ $-welcome_message
    not_welcome_message db "Wrong username [ERROR]", 10
    NOT_WELCOME_MESSAGE_LENGTH equ $-not_welcome_message
    USERNAME_MAX_LENGTH equ 12
    n1 equ 56
    n2 equ 56

section .bss
    written resd 1
    read resd 1
    username resb USERNAME_MAX_LENGTH

section .text
    global main
    main:
        sub rsp, SHADOWSPACE_SIZE

        ;Demander la saisie
        writting_msg1:
            mov rcx, STD_OUTPUT_HANDLE
            call GetStdHandle

            mov rcx, rax
            mov rdx, message
            mov r8, MESSAGE_LENGTH
            mov r9, written
            mov qword [rsp + SHADOWSPACE_SIZE], NULL
            call WriteConsoleA

        ;lecture au clavier
        read_answer1:
            mov rcx, STD_INTPUT_HANDLE
            call GetStdHandle

            mov rcx, rax
            mov rdx, username
            mov r8, USERNAME_MAX_LENGTH
            mov r9, read
            mov qword [rsp + SHADOWSPACE_SIZE], NULL
            call ReadConsoleA

        ;Affichage de la saisie
        writting_msg2:
            mov rcx, STD_OUTPUT_HANDLE
            call GetStdHandle

            mov rcx, rax
            mov rdx, username
            mov r8, USERNAME_MAX_LENGTH
            mov r9, written
            mov qword [rsp + SHADOWSPACE_SIZE], NULL
            call WriteConsoleA

        compare:
            mov rcx, n1
            mov rdx, n2
            cmp rcx, rdx
            je welcome
            jne not_welcome

        welcome:
            ;Compteur à décrémentation
            mov rbx, 3

            loop_message:
                mov rcx, STD_OUTPUT_HANDLE
                call GetStdHandle

                mov rcx, rax
                mov rdx, welcome_message
                mov r8, WELCOME_MESSAGE_LENGTH
                mov r9, written
                mov qword [rsp + SHADOWSPACE_SIZE], NULL
                call WriteConsoleA

                dec rbx
                jnz loop_message

            jmp exit_program

        not_welcome:
            ;Compteur à incrémentation
            mov rbx, 0

            loop_message2:
                mov rcx, STD_OUTPUT_HANDLE
                call GetStdHandle

                mov rcx, rax
                mov rdx, not_welcome_message
                mov r8, NOT_WELCOME_MESSAGE_LENGTH
                mov r9, written
                mov qword [rsp + SHADOWSPACE_SIZE], NULL
                call WriteConsoleA

                inc rbx
                cmp rbx, 3
                jne loop_message2

            jmp exit_program

        exit_program:
            add rsp, SHADOWSPACE_SIZE
            xor ecx, ecx
            call ExitProcess