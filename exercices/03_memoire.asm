# Exercice 3
#
# Objectif: Jouer avec des entiers dans la mémoire pour commencer!
#
# A faire: complêter le programme à trou.
#
# Questions:
# 
# - Quelle est l'addresse de `num0`, `num1`, `resultat`?
# - La dernière addresse du code votre programme
# - Comment est coté en langage machine (hexadecimal) l'instruction: `lw  t1, 0(t0)`
# - La mémoire est-elle dans le processeur
# - Quand on accede à la mémoire par mots de 32 bits est accessible de combien en combien?
# - Quelle est la valeur dans la mémoire de la valeur à l'addresse `num0`

# On déclare deux nombres de 32 bits dans la mémoire
# .word permet de specifier qu'on veux un mot de 32bits.
num0: .word 124
num1: .word 256

# On souhaite charger le resultat de l'addition dans la memoire a
# l'adresse resultat:
resultat: .word 0

# ??? <- @num0
l?  ???, num0
# load word depuis l'addresse 0 + register dans le register t1
lw  t1, 0(t0)

# t2 <- @num1
l?  t2,  ???
# Quelle instruction permet de charger un mot mémoire?
??? t3, 0(t2)

# chargement de l'addresse du resultat.
la t4, ???
# fait l'addition entre nos deux registres dans un registre.
add ???, ???, ???
# store word, stock le contenu du registre dans l'addresse à 0 + t4
sw ???, 0(t4)

# A faire par vous totalement:
# Afficher nos deux nombres dans la console
# indice: syscall printInt
