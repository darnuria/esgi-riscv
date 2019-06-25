# Introduction à d'architecture des ordinateurs et assembleur

Dans ce cours nous allons découvrir les bases de l'architecture des ordinateurs,
c'est à dire comment dans un ordinateur les différents composants oppérent leurs
calcul pour remplir des fonctions données.

Par exemple comment le processeur, traite des instructions et émet des rêquêtes à la mémoire.

Nous vérrons en ouverture la mémoire virtuelle et les entrées sorties très succinctement.

## Contexte

## Architecture RiscV

Risc-V est une architecture d'ordinateur dite [_Reduced Instruction Set Computer (RISC)_](https://fr.wikipedia.org/wiki/RISC-V),
c'est à dire à un processeur avec un jeu d'instruction réduit et régulier.

A titre d'exemple l'architecture externe des processeurs [Intel x86_64](https://en.wikipedia.org/wiki/X86-64) est de type
[_Complex Instruction Set Computer (CISC)_](https://en.wikipedia.org/wiki/Complex_instruction_set_computer).

### Vue d'ensemble

Un assembleur *(Ou langage d'assemblage)* est un langage permettant de
directement utiliser les capacité de calcul d'un processeur.
La représentation textuelle, dois être traité par un programme nommée «assembleur» chargée de
transformer notre assembleur en code **machine** binaire qui sera lui executable par notre processeur.

Pour commencé directement avec du code voici un exemple de code:

Imaginons le code C suivant:

```c
int a = 32;
a += 10;
```

Il pourrait compiler en:

```assembly
mon_code:
#         / 32 est un immédiat
li   t0, 32     # Ce programme charge 32 dans le registre t0
#      \ t0 est un registre
addi t0, t0, 10 # Puis additionne 10 à ce registre.
```

Et en binaire et la correspondance en hexadecimal cela donne:

| Format | 31-28| 27-24| 23-20| 19-16| 15-12| 11-8 | 7-4 | 3-0 |
|:-------|:----:|:----:|:----:|:----:|:----:|:----:|:---:|:---:|
| Hex    | 0    | 2    | 0    | 0    | 0    | 2    | 9   | 3   |
| Bin    | 0000 | 0010 | 0000 | 0000 | 0000 | 0010 | 1001| 0011|
| Hex    | 0    | 0    | a    | 2    | 8    | 2    | 9   | 3   |
| Bin    | 0000 | 0000 | 1010 | 0010 | 1000 | 0010 | 1001| 0011|

Dans le programme çi dessus vois des élèments typiques d'un assembleur:

- Des **instructions**: `li` et `add`
- Des **immédiats**: `32` et `10` ce sont des entiers directement encodé dans l'instruction finale
- Un **registre**: `t0`, manipulé en lecture et écriture.
- Des **labels**: `mon_code` qui permettent de nommer une adresse dans le programme ici `mon_code` pointe sur notre `li`.

Il existe d'autres instructions pour manipuler la mémoire et faire des branchements conditionnels
que nous verrons plus tard.

#### Registres

Dans le cas du jeu d'instructions RiscV, on manipule explicitement des petites unités de mémoire
disposées dans le processeur nommées des **registres**, il y en a 32 accessible à l'aide du langage
d'assemblage.

> _Note_: Ces unité ont pour double but de contourner la «hierarchie des temps d'accès à la mémoire» et aussi
> de facilité la réalisation hardware du processeur.

| Numéro | Nom | Description | Sauvegarde |
|:-------|:---:|:-----------:|:----------:|
| x0      | zero   | Vaut toujours 0    |           |
| x1      | ra     | Adresse de retour  | Appellant |
| x2      | sp     | Pointeur de pile   | Appellé   |
| x15     | gp     | Pointeur global    |           |
| x4      | tp     | Pointeur de thread |           |
| x5      | t0     | Temporaire         | Appellant |
| x6-x7   | t1-t2  | Temporaire         | Appellant |
| x8      | s0/fp  | Registre à sauvegarder / ancien sommet de pile | Appellé |
| x9      | s1     | Registre à sauvegarder | Appellé |
| x10-x11 | a0-a1  | Arguments de fonction ou valeur de retour | Appellant |
| x12-x17 | a2-a7  | Arguments de fonctions  | Appellant |
| x18-x27 | s2-s11 | Registre sauvegarder    | Appellé   |
| x28-x31 | t3-t6  | Vaut toujours 0         | Appellant |

Le tableau çi-dessus est inspiré par la [page wikipédia riscV](https://en.wikipedia.org/wiki/RISC-V)
et le chapitre 18 sur les [conventions d'appel](https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf)

Certains registres ont un usage particulier tel que: `ra`, `sp`, `gp` `tp` on ne les utilisera pas dans la majorité des cas directement. le registre `zero` à toujours la valeur 0.

On vera que certains doivent être sauvegardé si besoin lors des appels de fonctions par la fonction qui appelle une autre,
et la fonction qui est appellée.

### Instructions

<!-- Schema? -->
Comme nous l'avons vu en RiscV on utilise des instructions pour manipuler les registres et la mémoire,
ces sont représenté sous la formes de valeurs binaires sur par exemple 32 bit.

C'est le concept du programme stocké ou "[stored program concept](https://en.wikipedia.org/wiki/Stored-program_computer)",
cette suite de valeur binaire qui forme un programme est stocké dans la mémoire.

Note: C'est une simplification pour aller plus loin je vous recommande de lire sur la [mémoire virtuelle](https://en.wikipedia.org/wiki/Virtual_memory), je vous recommande le livre "[Operating System : Principles and Practice](http://ospp.cs.washington.edu/index.html)"
Thomas Anderson and Michael Dahlin.

Il existe des instructions pour faire différentes opérations nous allons en voir une partie ensemble

Certaines des instructions que nous avons manipulées tel que `mv` qui copie un registre dans un autre et `li` qui charge
un immédiat, ou `la` qui chage une adresse sont des pseudo instructions, c'est à dire quelles ne sont pas réalisé par le hardware,
elles ont vocations à être décomposé en instructions plus élèmentaires.

Par exemple  `mv t1, t0` est décomposé en un `add t1, zero, t0`.

On vera dans la partie [Formatage binaire des instructions](#formatage-binaire-des-instructions) pourquoi `mv` et `li` ne sont pas réalisé par notre jeu d'instruction.

#### Instruction arithmetique et logique

#### Instructions Memoire

Pour faire un programme sur une machine de turing tel que notre processeur, il nous faut une mémoire,
nos registres sont une forme de mémoire mais c'est assez limitant 32 mots de 32bits.

Notre processeur à donc besoin d'instructions pour manipuler la mémoire de notre ordinateur. C'est le but des instructions
de stockage (store) et de chargement (load) mémoire.

_Note_: En riscV la mémoire est toujours allignée sur un multiple de 4 et on ne peut pas accèder sur autre chose que un multiple de 4.

En RiscV ce sont les instructions suivantes

> la registre_destination, label

Pseudo instruction permetant de charger l'adresse d'un label dans un registre.

Elle se décompose par l'instruction `aiupc` et souvent un `add`, l'idée est de construire une adresse relative au pointeur
de code `pc`, c'est pour des questions de praticité dans la réalisation du hardware et des compilateurs.

##### Load instructions

> lw registre_destination, offset(registre_source)

Cette instruction charge dans un registre de destination le contenu dans la mémoire à
l'adresse contenue dans le registre source un offset peut être additionné à l'addresse dans le registre source.

Équivalent en C:
```c
int a[1] = { 42 }; // On reserve un array de 1 mot de 32bits.
int b = *a[0];     // On récupére la valeur de l'entier
```

```asm
.data
myInt: .word 42 # On réserve un mot de 32 bits pour stocker un entier.

.text
la t0, myInt # On charge dans t0 l'adresse de myInt.
lw t1, 0(t0) # On charge la valeur pointé par t0 dans t1.
```

Pour incrémenter un sur un tableau de mots de 32bits on avance de 4 en 4.

> lh registre_destination, offset(registre_source)

Comme `lw` mais on charge et adresse des demis mots de 32 bits donc 16 bits.

Pour incrémenter sur un tableau de mot de 16bits on avance de 2 en 2.

> lb registre_destination, offset(registre_source)

Comme `lw` mais on charge et adresse des quart de mots de 32 bits donc 8bits,
c'est très utilisé pour manipuler des chaines de charactères Ascii.

Note: Pour l'incrémentation sur un tableau de mots de 8bits (char) on avance de 1 en 1.


##### Store instructions

> sw lb registre_destination, offset(registre_source)

> sh lb registre_destination, offset(registre_source)

> sb lb registre_destination, offset(registre_source)

#### Instruction de Branchements

#### Appel systèmes

#### Formatage binaire des instructions

En RiscV les instructions sont divisé en 6 formats:

- Format R: Instructions de manipulation registre à registre ex: `add, sub, sll, slt, sltu, xor`
- Format I: Instructions avec un immédiat 11 bit ex: `lw, lh, lb, jalr`
- Format S: Instructions d'écriture mémoire ex: `sw, sh, sb`
- Format SB: Instructions de branchement relatifs ex: `beq, bne, bge, blt, bltu, bgeu`
- Format U: Instruction avec le haut d'un immédiats sur `[31:12]` ex: `aiupc, lui`
- Format UJ: Instructions de branchement sur un registre ex: `jal`

_Référence_: Si vous voulez en savoir plus je vous recommande le chapitre 7 du cours "[cs61c](https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf)" de l'université Berkley par Steven Ho ~45 min de lecture à tête reposée.
