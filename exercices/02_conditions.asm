# Exercice 2
# Notions:
#
# Pouvoir faire un saut conditionnel dans un programme ici
# tester l'egalité entre deux registres.
# Effectuer un branchement conditionnel puis non conditionnel.
# Puis afficher un message selon le résultat.

# Objectif du programe:
#
# Assigner des nombres dans des registres:
# - `t0` <- 5
# - `t1` <- 4
.data
msg_eq: .asciiz "Ces nombres sont egaux!"
msg_neq: .asciiz "Ces nombres ne sont pas egaux"
.text

# En rust on aurais surement fait un truc du genre
# ```rust
# let a = 5;
# let b = 4;
# let msg = if a == b { "Ces nombres sont egaux!" } else { "Ces nombres ne sont pas egaux" };
# println!(msg);
# ```

### Ici à vous de jouer utiliser
# deux instructions à écrire pour charger 5 dans t0 et t1 dans 4.

bne t0, t1, not_eq # if t0 != t1 jump not_eq

# Cas égaux
la a7 # msg <- "Ces nombres sont egaux!" 
j end # On a fini donc on peut sortir du if.

# Cas Inégaux
not_eq:
la a7 ??? # msg <- "Ces nombres ne sont pas egaux"
###

end:
# Affichage
#
# Ici on souhaite afficher sur la console via un appel système.
# inspirez vous de l'exercice 01_syscall, le registre a0 doit contenir
# le numéro du syscall printString: 4 et a7 la chaine à afficher.

li ?? ???
ecall