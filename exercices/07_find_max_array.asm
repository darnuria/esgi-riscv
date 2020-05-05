# Exercice 07 Incrementer tout les elements d'un tableau

# Dans cet exercice, on va encore une fois pratiquer les boucles.
# l'objectif est de trouver le maximum d'un tableau.

# On souhaite écrire une fonction au label:`find_max`

.data

array:
# A vous de definir un morceau de mémoire contigue contenant des entiers sur 32bits.
# Indice .word 1,2,3,4
array_size:
# Vous pouvez definir la taille du tableau ça sera pratique ;)
# Indice: .word 4


.text
main:

# Préparer les arguments de find_max dans les registres a0 et a1!

# sauter à find_max

# On reviens de find_max, affichons le resultat

# On quite le programme en sautant à la fonction exit.
jal exit

## find_max
##
## Arguments
##
## a0: Address of a contiguous memory chunck containing integer on 32bits.
## a1: Size of the continuguous memory chunck
##
## Return:
## Return address of the max element, if array is empty return NULL address (0)

find_max:

## Exit a program by calling corresponding exit syscall.
## Do not return.
exit:
li a7, 10
ecall