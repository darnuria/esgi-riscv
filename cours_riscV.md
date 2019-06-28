# Introduction à d'architecture des ordinateurs et assembleur

Dans ce cours nous allons découvrir les bases de l'architecture des ordinateurs,
c’est-à-dire comment dans un ordinateur les différents composants opèrent leurs
calcul pour remplir des fonctions données.

Par exemple comment le processeur, charge des données de la mémoire, les traites à l'aide d'instructions et les écrit dans ma mémoire.

> _Note :_ Nous verrons plus tard que nos ordinateurs modernes
Exploitent le concept du programme «stocké» en mémoire. Le programme peut donc être
vue comme une donnée en mémoire.

Nous verrons en ouverture la mémoire virtuelle et les entrées, sorties avec les périphériques très succinctement.

## Contexte

## Architecture RiscV

Risc-V est une architecture d'ordinateur à jeu d'instruction _ISA Instruction Set Architecture_ dite [_Reduced Instruction Set Computer (RISC) _](https://fr.wikipedia.org/wiki/RISC-V),
c’est-à-dire à un processeur avec un jeu d'instruction réduit et régulier.

A titre d'exemple l'architecture externe des processeurs [Intel x86_64](https://en.wikipedia.org/wiki/X86-64) est de type
[_Complex Instruction Set Computer (CISC)_](https://en.wikipedia.org/wiki/Complex_instruction_set_computer).

> Note: C'est en dehors du cadre du cours mais dans la réalisation *interne* du processeur x86_64 on s'arrange pour obtenir un jeu interne RISC car c'est plus facile à optimiser et maintenir.

<!-- Parler plus de RiscV en général ou faire une ouverture sur le Hennessy et Patterson -->

### Vue d'ensemble

Un assembleur ou *langage d'assemblage* est un langage permettant de
directement utiliser les capacités de calcul d'un processeur.
La représentation textuelle, dois être traité par un programme nommé «[assembleur](https://fr.wikipedia.org/wiki/Programme_assembleur)» chargée de
transformer notre assembleur en code **machine** binaire qui sera lui exécutable par notre processeur.

Pour commencer directement avec du code voici un exemple de code C :

```c
int a = 32;
a += 10;
```

Il pourrait compiler en :

```mips
mon_code:
#         / 32 est un immédiat
li   t0, 32     # Ce programme charge 32 dans le registre t0
#      \ t0 est un registre
addi t0, t0, 10 # Puis additionne 10 à ce registre.
```

Dans le programme ci-dessus vois des éléments typiques d'un assembleur:

- Des **instructions** : `li` et `add`
- Des **immédiats** : `32` et `10` ce sont des entiers directement encodés dans l'instruction finale
- Un **registre** : `t0`, manipulé en lecture et écriture.
- Un **labels** : `mon_code` qui permettent de nommer une adresse dans le programme ici il pointe sur notre `li`.

Il existe d'autres instructions pour manipuler la mémoire et faire des branchements
conditionnels que nous verrons plus tard.

#### Registres

En assembleur RiscV, on manipule explicitement des petites unités de mémoire
disposées dans le processeur nommé des **registres**, il y en a 32 accessibles
dans le jeu d'instruction de base.

> _Note_: Les registres ont pour double but de contourner la «hiérarchie des temps d'accès à la mémoire»
> et aussi de facilité la réalisation hardware du processeur.

| Numéro | Nom | Description | Sauvegarde |
|:-------|:---:|:-----------:|:----------:|
| x0      | zero   | Vaut toujours 0    |           |
| x1      | ra     | Adresse de retour  | Appelant |
| x2      | sp     | Pointeur de pile   | Appelée   |
| x15     | gp     | Pointeur global    |           |
| x4      | tp     | Pointeur de thread |           |
| x5      | t0     | Temporaire         | Appelant |
| x6-x7   | t1-t2  | Temporaire         | Appelant |
| x8      | s0/fp  | Registre à sauvegarder / ancien sommet de pile | Appelée |
| x9      | s1     | Registre à sauvegarder | Appellé |
| x10-x11 | a0-a1  | Arguments de fonction ou valeur de retour | Appellant |
| x12-x17 | a2-a7  | Arguments de fonctions  | Appellant |
| x18-x27 | s2-s11 | Registre sauvegarder    | Appellé   |
| x28-x31 | t3-t6  | Vaut toujours 0         | Appellant |

Le tableau ci-dessus est inspiré par la [page wikipédia riscV](https://en.wikipedia.org/wiki/RISC-V)
et le chapitre 18 sur les [conventions d'appel](https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf) de la spécification du jeu d'instruction.

Certains registres ont un usage particulier tel que: `ra`, `sp`, `gp` `tp` on ne les utilisera pas dans la majorité des cas directement. Le registre `zero` à toujours la valeur 0.

On vera que certains doivent être sauvegardé si besoin lors des appels de fonctions par la fonction qui appelle une autre,
et la fonction qui est appelée.

> _Aller Plus loin_: D'autres jeux de registres sont accessibles dans des extensions
> du jeu d'instructions RiscV notamment pour les calculs en virgule flottante ou bien
> le jeu privilégié utile quand on réalise un OS ou programme pour des
> microcontrôleurs.

### Instructions

<!-- Schema? -->
Comme nous l'avons vu en RiscV on utilise des instructions pour manipuler les registres et la mémoire, les instructions sont représentées sous la forme de valeurs binaires sur par exemple 32 bit.

Pour rappel le programme de tout à l'heure:

```mips
li   t0, 32     # Ce programme charge 32 dans le registre t0
addi t0, t0, 10 # Puis additionne 10 à ce registre.
```

Et en binaire et la correspondance en hexadécimal nous donne,
les intervalles représentent les bits de 4 en 4:

| Format | 31-28| 27-24| 23-20| 19-16| 15-12| 11-8 | 7-4 | 3-0 |
|:-------|:----:|:----:|:----:|:----:|:----:|:----:|:---:|:---:|
| Hex    | 0    | 2    | 0    | 0    | 0    | 2    | 9   | 3   |
| Bin    | 0000 | 0010 | 0000 | 0000 | 0000 | 0010 | 1001| 0011|
| Hex    | 0    | 0    | a    | 2    | 8    | 2    | 9   | 3   |
| Bin    | 0000 | 0000 | 1010 | 0010 | 1000 | 0010 | 1001| 0011|

C'est le concept du programme stocké ou "[stored program concept](https://en.wikipedia.org/wiki/Stored-program_computer)",
cette suite de valeur binaire qui forme un programme est stocké dans la mémoire.

> _Note :_ C'est une simplification pour aller plus loin je vous recommande de lire sur
> la [mémoire virtuelle](https://en.wikipedia.org/wiki/Virtual_memory), je vous
> recommande le livre "[Operating System : Principles and Practice](http://ospp.cs.washington.edu/index.html)"
>Thomas Anderson and Michael Dahlin.

Il existe des instructions pour faire différentes opérations nous allons en voir une partie ensemble

Certaines des instructions que nous avons manipulées tel que `mv` qui copie un registre dans un autre et `li` qui charge
un immédiat, ou `la` qui charge une adresse sont des pseudo-instructions, c’est-à-dire qu’elles ne sont pas réalisées par le hardware,
elles ont vocations à être décomposé en instructions plus élémentaires.

Par exemple  `mv t1, t0` est décomposé en un `add t1, zero, t0`.

On verra dans la partie [Formatage binaire des instructions](#formatage-binaire-des-instructions) pourquoi `mv` et `li` ne sont pas réalisés par notre jeu d'instruction.

#### Mémoire

Comme vu l'avez peut-être vu en C on représente la mémoire comme un espace, allant
de l'adresse `0x0000_0000` jusque à l'adresse `0xFFFF_FFFF` pour un programme 32bits.

##### Segments

Dans nos programmes on décompose cet espace en segments par exemple pour le code
est le segment: `.text` pour les données du programme connues avant l'exécution c'est le segment `.data`.

> _Aller plus loin :_ Il existe d'autres segments tel que `.bss` beaucoup sont liée
> au système d'instruction plus que au jeu d'instruction.

Par exemple la pile est un segment particulier, qu'on utilise pour stocker des variables locales et conserver la valeur des registres entre les appels de fonctions ou appel au système d'exploitation.

##### Usage dans l'assembleur

<!-- todo Schemas -->

Dans nos programmes assembleurs on manipulera des adresses souvent. Les labels nous servirons à marquer une adresse particulière pour sauter dessus ou pour
charger un tableau du segment `.data`. Ou alors on utilisera le registre, `sp`
qui marque le sommet de la pile pour sauvegarder la valeur de nos registres.
Le registre `gp` ou `ra` sont utilisés calculer des jumps relatifs dans le
programme. Attention le registre `pc` est pas accessible directement à nos programmes.

<!-- ##### Mémoire virtuelle -->

#### Instruction arithmétique et logique

#### Instructions Mémoire

Pour faire un programme sur une machine de Turing tel que notre processeur, il nous faut une mémoire,
nos registres sont une forme de mémoire mais c'est assez limitant 32 mots de 32bits.

Notre processeur a donc besoin d'instructions pour manipuler la mémoire de notre
ordinateur. C'est le but des instructions de stockage (store) et de chargement
(load) mémoire.

>_Note :_ En riscV la mémoire est toujours alignée sur un multiple de 4 et on ne
> peut pas accéder sur autre chose que un multiple de 4.

##### Charger une adresse dans un registre

> la registre_destination, label

Pseudo-instruction permettant de charger l'adresse d'un label dans un registre.

Elle se décompose en l'instruction `aiupc` et souvent un `add`, l'idée est de construire une adresse relative au pointeur
de code `pc`, c'est pour des questions de praticité dans la réalisation du hardware et des compilateurs.

Exemple:
```mips
la t0, my_address # t0 contiendra l'adresse pointé par my_address
```

##### Load instructions

> lw registre_destination, offset(registre_source)

Cette instruction charge dans un registre de destination le contenu dans la mémoire
à l'adresse contenue dans le registre source un offset peut être additionné à l'addresse dans le registre source.

Équivalent en C:
```c
int a[2] = { 42, 1 }; // On réserve un array de 1 mot de 32bits.
int b = a[0];         // On récupère 42
int c = c[1];         // On récupère 1
```

```asm
.data
myInt: .word 42 # On réserve un mot de 32 bits pour stocker un entier.

.text
la t0, myInt # On charge dans t0 l'adresse de myInt.
lw t1, 0(t0) # On charge la valeur pointée par t0 dans t1 donc 42.
lw t2, 4(t0) # On récupère ici 1.
```

Pour incrémenter un sur un tableau de mots de 32bits on avance de 4 en 4.

> lh registre_destination, offset(registre_source)

Comme `lw` mais on charge et adresse des demis mots de 32 bits donc 16 bits.

Pour incrémenter sur un tableau de mot de 16bits on avance de 2 en 2.

> lb registre_destination, offset(registre_source)

Comme `lw` mais on charge et adresse des quarts de mots de 32 bits donc 8bits,
c'est très utilisé pour manipuler des chaines de caractères ASCII.

Pour être concret voici un C :

```c
char s = "chat"; // On déclare une chaine de caractère.
char c = s[0];   // on récupère le c.
char b = s[2]    // on récupère le a.
```

Il peut lieu à un schéma de compilation comme celui-là:

```mips
.data
s: .string "chat"

.text
la t0, s     # t0 contient l'adresse de base de notre chaine!
lb t1, 0(t0) # t1 contient 'c'
lb t2, 2(t0) # t2 contient 'a'
```

Note: Pour l'incrémentation sur un tableau de mots de 8bits (char) on avance de 1 en 1.

##### Store instructions

> sw lb registre_destination, offset(registre_source)

> sh lb registre_destination, offset(registre_source)

> sb lb registre_destination, offset(registre_source)

#### Instruction de Branchements

#### Appel systèmes

Un appel système ou syscall est une sorte de fonction spéciale que propose le système d'exploitation, cet appel s'exécutera en suspendant l'exécution du programme courant.

Pour les appeler on utilise l'instruction :

> ecall

`ecall` est l'instruction qui permet de déclencher une *exception*, qui force le
processeur à interrompre ce qu'il fessait pour sauter dans le code de gestion
des exceptions du noyau de notre système d'exploitation.

Pour passer des arguments aux appels systèmes _syscalls_, on les passe par les registres `a0`, `a1`, `a2` à `a3`, on charge dans le registre `a7` le numéro qui renseigne l'appel système désiré et ensuite on utilise `ecall`.

Exemple:
```mips
    li  a7, 1 # le syscall 1 permet d'afficher un entier
    li a0, 42
    ecall     # On peut lire 42 dans la console de Rars.
```

> _Note :_ Dans nos programmes C, JavaScript, etc. bien souvent on passera par l'abstraction de la libC pour faire appel aux services du noyau au lieu de directement faire des `ecall`.

> _Note :_ Cette _convention d'appel avec le noyau_ dépends de l'OS !

#### Formatage binaire des instructions

En RiscV les instructions sont divisées en 6 formats:

- Format R: Instructions de manipulation registre à registre ex: `add, sub, sll, slt, sltu, xor`
- Format I: Instructions avec un immédiat 11 bit ex: `lw, lh, lb, jalr`
- Format S: Instructions d'écriture mémoire ex: `sw, sh, sb`
- Format SB: Instructions de branchement relatifs ex: `beq, bne, bge, blt, bltu, bgeu`
- Format U: Instruction avec le haut d'un immédiat sur `[31:12]` ex: `aiupc, lui`
- Format UJ: Instructions de branchement sur un registre ex: `jal`

_Référence_: Si vous voulez en savoir plus je vous recommande le chapitre 7 du cours "[cs61c](https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf)" de l'université Berkley par Steven Ho ~45 min de lecture à tête reposée.

## Exercices

Sujets:

- Rechercher un entier passé en paramètre dans un tableau de entier.
    objectif : cionvention d'appel, comparaison, accès mémoire

- Incrémenter un tableau par un entier N.
    objectif : opération, accès mémoire

- Trouver le maximum d'un tableau de nombre.
    objectif : comparaison, accès mémoire

- Jouer une mélodie avec des appels système
    objectif : appel système, accès mémoire

- Swapp 2 à 2 des élèments d'un tableau
    objectif : découverte des écriture mémoires [1,2,3,4] deviendrais [2,1,4,3]

<!-- - Ecrire un compresseur RLE
    objectif : accès mémoire, registre
    -->

- Faire un chiffrement simple par décalage
    objectif : utilisation des décalage de bits
