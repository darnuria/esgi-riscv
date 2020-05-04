# Exercice 06: CLZ / Découverte des fonctions

# Pour le 25 juin 2020!
# deux autres exercices vont arriver d'ici le 10 mai. :)

# Dans cet exercice on va compter le nombre de zéro avant le premier bit à 1
# dans un mot de 32 bits.

# Cette fonction souvent appellée "Count Leading Zeros" (clz) est assez utile
# dans l'embarqué et les systèmes d'exploitations ou databases.
# Notament quand vous voulez compresser des packets de 0 avant de la data ;)

# GROS INDICE: https://en.wikipedia.org/wiki/Find_first_set

# Tellement utile que souvent une instruction dédiée existe!

# On imagine un mot de 8 bits:

# +---+---+---+---+---+---+---+---+
# | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
# +---+---+---+---+---+---+---+---+
# | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 |
# +---+---+---+---+---+---+---+---+

# Ici votre code pour clz devrait renvoyer 4 !

# On va aussi s'initier aux fonctions.
.data
my_word: .word 512

.text

######
# Début du main
######
main:

la a0, my_word
lw a0, 0(a0) # On charge le mot située au label my_word.
jal ra, soft_clz # On saute dans la fonction soft_clz
# On se souviens de la position de retour avec le registre ra.
# a la sortie de la fonction on est ici.

# a0 contiens deja ce qu'on veux afficher.
li a7, 1 # print integer
ecall

# Syscall exit pour finir notre programme.
li a7, 10 # Exit
ecall
######
# Fin du main
######

###########################
# Debut de votre fonction #
###########################
soft_clz:
# Fonction soft_clz, calcule le nombre de 0 avant le premier bit à 1.
# Arguments:
# a0: mot de 32 bit dans lequel on cherche a determiner le nombre de 0 devant le premier 1.
# return (registre a0) nombres de 0 devant le premier bit à 1 si 0 renvoie 32.

# convention: Dans une fonction on utilise majoritairement les registres tX
# ce sont les registres temporaires, les registres aX sont les registres de paramètres
# C'est la fonction qui appelle qui les sauvegardes.
# les registres sX sont sauvegarder par la fonction appellée on les utilisera pas ici.

# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# Ici débute l'endroit ou vous pouvez écrire votre code!

# Pour réussir votre fonction vous pouvez faire une boucle un and et des décallages.
# Ou une version aggressive avec pleins de and.
# Essayez de le faire sur papier d'abbord dessinez un tableau de 8 bits et faites l'algo
# à la main pour compter. Vous verrez qu'il faut faire 3 choses, faire 32 comparaison,
# en décallant à gauche ou droite un curseur.
# Pour tester la valeur de deux bits entre-eux je vous recommand l'operation `and`.

# -+- Happy coding! -+-

# Fin du code que vous devriez écrire le résultat dois être dans a0!
# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
jr ra # on retourne d'ou on viens ici le main!
###########################
# Fin de votre fonction.  #
###########################