# Exercice 3
#
# Objectif: Additionner toutes les cases d'un tableau version «naive»
# Sans boucle, ça correspond à faire l'addition de array_g[0] + array_g[1] + array_g[2].
#
# A faire: complêter le programme à trou.
#
# Questions:
#
# - Que fait l'instruction lw: load word?
# - lw: À quoi sert l'immédiat devant le registre contenant l'adresse?
# - Que va contenir le registre de destination de lw?
#
# - Avec une instruction comme add à quoi correspondent les trois registes?
# `add reg0, reg1, reg2`
#   - reg0:
#   - reg1:
#   - reg2:
#
# - `la` sert à quoi?
# - Quand on travail sur des mots de 32 bits les addresses sont allignées de combien en combien?

.data
# /!\ Attention! ce sont des variables globales en mémoire! /!\

# On déclare «naivement» un tableau et sa taille, dans le segment data.
# On vera dans la suite du cours que c'est pas exactement comme ça qu'on fait,
# dans la vrai vie des choses de font dans la pile.
size_array_g: .word 3
array_g: .word 124, 256, 512

# Chaines pour les test
msg_success: .asciz "La somme correspond bien! Bravo."
msg_fail: .asciz "Whops c'est pas encore ça, courage! :)"

.text

main:

la t0, array_g # t0 = @array_g;
# On souhaite faire la somme du tableau! On va additionne toute les cases dans un registre.

# Ici on utilise le nombre devant le registre pour faire une petit calcul de mémoire.
lw  t1, 0(t0) # t1: array_g[0]
# lw ???, 4(???) <- TODO: À completer!
add a0, t1, t2 # sum = t2 + t1

# A vous de jouer il faut écrire deux instructions!
# t1: array_g[2]
# sum = sum + t1

###
# Partie prof test si ça fonctionne et affiche un message en fonction.
###
test:
# Test sum == 892
li  a1, 892
bne a0, a1, fail_test # if a0 !t1 then fail_test
la a0, msg_success
j print
fail_test:
la a0, msg_fail

print:
li a7, 4
ecall
