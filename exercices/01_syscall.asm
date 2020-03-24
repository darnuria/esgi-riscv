# Exercice 1
# utiliser un appel système comme write
.data
msg: .asciz "Hello World form .data"

.text # <- segment de code.

# Exercice: Observation dans Rars
# - Quelle est l'addresse de base de la chaine msg? Son addresse de fin?
# - Dans quelle segment de la mémoire est elle?
# - Quelle sont les valeurs en hexadecimales présente dans .data?
j test

la a0, msg
li a7, 4 # appel systeme 4 selon la doc de Rars printString
ecall

test:
addi t0, t0, 5
# Bonus: avoir 64 dans un registre en une seule instruction
