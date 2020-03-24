# Exercice 0
# Faire une addition dans un registre

.text # <- segment de code pour le code :)

# Exercice:
# On veux obtenir le nombre 64 modifier le code pour pouvoir avoir 64
# dans t0 à la fin du programme.

# Questions: C'est quoi un registre? (mettre un x dans la bonne réponse
#
# - [ ] Une mémoire dans le processeur de 32 bits
# - [ ] Une variable dans la mémoire

mon_code: # <- Label permet d'associer un nom a une adresse.

li   t0, 32     # load immediate: Charge un nombre sur max 12 bit dans un registre
addi t0, t0, 00 # Additionne l'operande 1 (t0) et un immediat et sauvegarde du résultat (t0)
#     |   \ operand 1
#     destination

# Bonus: avoir 64 dans un registre en une seule instruction
