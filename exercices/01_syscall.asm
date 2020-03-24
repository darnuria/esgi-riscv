# Exercice 1
# utiliser un appel système comme write

# On indique qu'on souhaite ranger des données dans le segment de data.
.data

# la directive .asciz permet de déclarer une chaine fini par un 0x00, '\0' en ascii.
msg: .asciz "Hello ASM from .data"

.text # <- segment de code.

# Exercice: Observation dans Rars
# - Quelle est l'addresse de base de la chaine msg? Son addresse de fin?
# - Dans quelle segment de la mémoire est elle?
# - Quelle sont les valeurs en hexadecimales présente dans .data?

la a0, ??? # argument de l'appel systeme
li a7, ??? # appel systeme 4 selon la doc de Rars printString
ecall # Peret de basculer en mode kernel pour faire l'appel systeme.

# Bonus: Afficher maintenant un nombre, vous aurrez besoin de la documentation.
