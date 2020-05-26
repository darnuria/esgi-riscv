

.asciz ma_chaine "J'adore les chats"

.text

main:

#prepare les arguments pour to_upper
# On saute dans to_upper
# On affiche la chaine mise a jour! :)

# Passer en majuscule une chaine de caractere en ascii
# a0: pointeur sur la chaine de caracteres
# a1: taille chaine de caractere
to_upper:

# for x in str:
# On charge une lettre indice : caractere sur 8 bits pas 32! ;p

# if x est entre a et z indice: man ascii (spoiler A = 65; a = 97)
# then x + 32
# sinon rien

# Incremente le pointeur sur notre chaine indice mot de 8bits pas 32 ;p
# j for

# return rien
# On retourne dans le main