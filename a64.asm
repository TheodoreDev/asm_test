bits 64 ;Définition de l'architecture système

%define message_written "Hello from quantum world !" ;Macro (semblable à une constante python)
%define message_written2 "I am a micro-particle stuck in the quantum vacuum."
%define message_written3 "I'm on the scale of quantum uncertainty."
%define smiley_part1 "        0110010001"
%define smiley_part2 "      01100010001011"
%define smiley_part3 "    0101   0001   1010"
%define smiley_part4 "   01001   1001   11101"
%define smiley_part5 "   01001010011101011100"
%define smiley_part6 "    01010  1100  01010"
%define smiley_part7 "      01001    01101"
%define smiley_part8 "        0100101000"

extern GetStdHandle  ;Gestionnaire de périphériques
extern WriteConsoleA ;Ecrire en mode console
extern ExitProcess   ;Arrêt du process

section .data
    message db message_written, 10, message_written2, 10, message_written3, 10 ;Définition du message (db = chaîne d'octets)
    smiley db 10, smiley_part1, 10, smiley_part2, 10, smiley_part3, 10, smiley_part4, 10, smiley_part5, 10, smiley_part6, 10, smiley_part7, 10, smiley_part8, 10, 10
    MESSAGE_LENGTH equ $-message   ;Définition de la longueur du message (Macro spéciale)(constante)
    SMILEY_LENGTH equ $-smiley

section .bss
    written resq 1

section .text
    global main
    main:
        mov rcx, -11      ;Définition de l'Output
        call GetStdHandle ;appelle de la fonction

        sub rsp, 32 ;Allouer un espace fantome
        sub rsp, 8  ;8 octets pour le retour de la fonction

        mov rcx, rax           ;Récupération de l'Output
        mov rdx, message       ;Récupération du message
        mov r8, MESSAGE_LENGTH ;Récupération de la longueur du message
        mov r9, written        ;Récupération du nombre de caractère écrit
        mov qword [rsp + 32], 0  ;Se placer après l'espace fantôme pr écrire (espace fantôme rempli avec 0)
        call WriteConsoleA

        mov rcx, rax
        mov rdx, smiley
        mov r8, SMILEY_LENGTH
        mov r9, written
        mov qword [rsp + 32], 0
        call WriteConsoleA

        add rsp, 32+8 ;On remet la pile à 0

        xor ecx, ecx ;mettre ecx = 0 (Optimisé)
        call ExitProcess