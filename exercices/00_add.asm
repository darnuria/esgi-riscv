# Exercice 0
# Faire une addition dans un registre

.text # <- segment de code.

# Exercice:
# On veux obtenir le nombre 64 modifier le code pour pouvoir avoir 64
# dans t0 à la fin du programme.

mon_code: # <- Label
li   t0, 32
addi t0, t0, 0

# Bonus: avoir 64 dans un registre en une seule instruction
