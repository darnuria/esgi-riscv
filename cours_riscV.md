# Introduction à l'assembleur RiscV

Cours de 15h initialement donné pour les 4èmes années mobilité et objets connecté de l'ESGI en 2019 et 2020.

Dans ce cours, nous allons découvrir les bases de l'assembleur RiscV, il s'agit d'un jeu
réduit il y a peu d'instructions comparé à Intel nous verrons que cela n'est pas un problème en soit.

Par exemple comment le processeur, charge des données de la mémoire, les traite à l'aide d'instructions et les écrit dans la mémoire.

> _Note :_ Nous verrons plus tard que nos ordinateurs modernes
Exploitent le concept du programme «stocké» en mémoire. Le programme peut donc être
vu comme une donnée en mémoire.

Nous verrons en ouverture la mémoire virtuelle, les entrées/sorties avec les périphériques très succinctement et
le pipelining.

## Préambule

Afin de se préparer et de commencer avec un support sympa je vous recommande très fortement le [Crash Course Computer Science](https://www.youtube.com/playlist?list=PL8dPuuaLjXtNlUrzyH5r6jN9ulIgZBpdo) de [Carrie Anne Philbin](https://en.wikipedia.org/wiki/Carrie_Anne_Philbin) disponnible sur Youtube, les chapitres [1 The Mechanics of How Computers Work](https://www.youtube.com/watch?v=O5nskjZ_GoI&list=PL8dPuuaLjXtNlUrzyH5r6jN9ulIgZBpdo&t=0s)
et [3 Computer Hardware](https://www.youtube.com/watch?v=6-tKOHICqrI&list=PL8dPuuaLjXtNlUrzyH5r6jN9ulIgZBpdo&t=0s)
donnent une bonne introduction des concepts du cours.

Je vous encourage à regarder le reste par curiosité.

### Exercices -  Notes

Dans ce cours il est indispensable de faire les exercices, je demanderais donc que vous forkiez ce dépot et réalisiez quotidiennement
les exercices.

Il y aura aussi un qcm et des devoirs maisons raisonnables.
Concernant projet ou examen avec le confinnement je dois contacter la direction pédagogique pour décider.

## Contexte

## Assembleur c'est quoi

Nos ordinateurs ne mangent pas de JavaScript, ni de C, ni du Rust directement, ils executent de l'assembleur et soit
vous compilez vers l'assembleur comme en Rust, C, C++ soit vous utilisez un compilateur Juste à Temps (JIT), soit vous interpretez
un jeu d'instruction haut niveau. Mais au final votre processeur lui ne vois que du code machine.

L'assembleur, sous la forme de *code machine* est ce que nos processeurs executent, des séries de 0 et de 1
organisé sous la forme d'un mot machine d'un nombre de bit définit. Dans notre cas pour le RiscV les mots
seront de 32 bits, certains jeux d'Instructions tel [Intel x86_64](https://en.wikipedia.org/wiki/X86-64) 
ont des jeux à taille de mot variable et beaucoup plus d'instructions.

Nous manipuleront une forme textuelle de l'assembleur qui sera traduit en code machine par un
programme dit [assembleur](https://fr.wikipedia.org/wiki/Programme_assembleur).

Ces mots permettent de manipuler la mémoire, les registres qui sont l'unité de mémoire du processeur, dans ces mots
les bits sont organisé pour avoir un sens, plusieurs formats existent pour pouvoir encoder différentes choses,
comme de la manipulation de mémoire, une addition ou une comparaison ou un saut.

### Mise en pratique

Dans ce le cadre de ce cours nous allons utilisers le logiciel [Rars](https://github.com/TheThirdOne/rars) _RISC-V Assembler and Runtime Simulator_,
afin de visualiser ce qui se passe. Malheureusement nous n'aurons pas de hardware RiscV ce sera plus l'année prochaine, mais il existe des cartes de
developpement avec un processeur RiscV.

Rars est un simulateur permetant d'executer du RiscV comme si il y avait un OS sout-jacent, l'interet de Rars est de pouvoir visualiser toutes les
interactions avec la mémoire de façon visuelle. Nous utiliseront [la version 1.4](https://github.com/TheThirdOne/rars/releases/tag/v1.4) il vous faudra
OpenJDK version égale ou supérieur à 8 ou Java de Oracle.

#### Prise en main de Rars

Voici un exemple concret et notre premier programme, ce premier programme additionne deux nombre et sauvegarde le résultat dans un
registre.

Ici on veux additionner 32 avec 10 et à la fin le résultat sera dans le registre `t0` voici deux façons naives de faire
en C, Rust et RiscV.

En Rust on aurait fait:

```rust
let mut a = 32;
a += 10;
```

En C:

```c
int a = 32;
a += 10;
```

Et en RiscV

```mips  
mon-code:
#        / 32 est un immédiat c'est à dire on encode 32 dans l'instruction.
li   t0, 32
#     \ t0 est un registre
addi t0, t0, 10  # Puis additionne l'immédiat 10 à ce registre.
```

Dans le programme ci-dessus on voit des éléments typiques d'un assembleur:

- Des **instructions** : `li` et `add`
- Des **immédiats** : `32` et `10` ce sont des entiers directement encodés dans l'instruction finale
- Un **registre** : `t0`, manipule en lecture et écriture.
- Un **labels** : `mon_code` qui permettent de nommer une adresse dans le programme ici il pointe sur notre `li`.

Dans Rars ça devrait donner ça [Interface d'edition de notre programme](00_rarsUI.png).

Instructions présentées au dessus.

`li`: Pseudo instruction qui charge dans son registre de destination un immédiat sur 12 bit si signé ou 32 bits si  non signé
`addi`: Additionne son registre de source à un immédiat sur 12 bits et assigne le résultat dans son registre de destination.

Une fois que vous aurrez assemblé votre programme vous devriez voir ça:
[Interface d'execution de notre programme](01_rarsUI_Assembly.png).

*Question*: À la fin du programme quelle valeur contiens le registre `t0` ?

## Architecture RiscV

Dans ce cours nous allons utiliser le jeu d'instruction Risc-V, il s'agit d'une architecture d'ordinateur
à jeu d'instruction _ISA Instruction Set Architecture_ dite [_Reduced Instruction Set Computer (RISC) _](https://fr.wikipedia.org/wiki/RISC-V),
c’est-à-dire à un processeur avec un jeu d'instruction réduit et régulier avec peu de formats.

A titre d'exemple l'architecture externe des processeurs  est de type
[_Complex Instruction Set Computer (CISC)_](https://en.wikipedia.org/wiki/Complex_instruction_set_computer).

> Note: Pour votre curiosité dans la réalisation *interne* d'un processeur x86_64
les concepteurs s'arrangent pour obtenir un jeu interne RISC car c'est plus facile à optimiser et maintenir.

<!-- Parler plus de RiscV en général ou faire une ouverture sur le Hennessy et Patterson -->

### Registres

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
| x9      | s1     | Registre à sauvegarder | Appellée |
| x10-x11 | a0-a1  | Arguments de fonction ou valeur de retour | Appellant |
| x12-x17 | a2-a7  | Arguments de fonctions  | Appellant |
| x18-x27 | s2-s11 | Registre sauvegarder    | Appellée   |
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

Par exemple le programme suivant:

```mips
li   t0, 32     # Ce programme charge 32 dans le registre t0
addi t0, t0, 10 # Puis additionne 10 à ce registre.
```

Ce petit programme assembleur une fois en code machine équivaut aux mots de
32bits,`0x02000293` et `0x00a28293` si on décompose ça donne ça :

| Format | 31-28| 27-24| 23-20| 19-16| 15-12| 11-8 | 7-4 | 3-0 |
|:-------|:----:|:----:|:----:|:----:|:----:|:----:|:---:|:---:|
| Hex    | 0    | 2    | 0    | 0    | 0    | 2    | 9   | 3   |
| Bin    | 0000 | 0010 | 0000 | 0000 | 0000 | 0010 | 1001| 0011|
| Hex    | 0    | 0    | a    | 2    | 8    | 2    | 9   | 3   |
| Bin    | 0000 | 0000 | 1010 | 0010 | 1000 | 0010 | 1001| 0011|

> Note: C'est le concept du programme stocké ou "[stored program concept](https://en.wikipedia.org/wiki/Stored-program_computer)",
> cette suite de valeur binaire qui forme un programme est stocké dans la mémoire.

> _Aller plus loin :_ C'est une simplification pour aller plus loin je vous recommande de lire sur
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
de l'adresse `0x0000_0000` jusque à l'adresse `0xFFFF_FFFF` pour un programme 32 bits.

##### Segments

Dans nos programmes on décompose cet espace en segments par exemple pour le code
est le segment: `.text` pour les données du programme connues avant l'exécution c'est le segment `.data`.

> _Aller plus loin :_ Il existe d'autres segments tel que `.bss` beaucoup sont liée
> au système d'instruction plus que au jeu d'instruction.

Par exemple la pile est un segment particulier, qu'on utilise pour stocker des variables locales et conserver la valeur des registres entre les appels de fonctions ou appel au système d'exploitation.

##### Adresses en l'assembleur

<!-- todo Schemas -->

Dans nos programmes assembleurs on manipulera des adresses souvent.
Les labels nous servirons à marquer une adresse particulière pour sauter dessus ou pour
charger une valeur dans le segment `.data`. 

Ou alors on utilisera le registre, `sp` qui marque le sommet de la pile pour sauvegarder la valeur de nos registres.
Le registre `gp` ou `ra` sont utilisés calculer des jumps relatifs dans le
programme.
Il existe aussi le programme counter qui contiens l'addresse de l'instruction courante.

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
int a[2] = { 42, 1 }; // On réserve un array de 2 mot de 32bits.
int b = a[0];         // On récupère 42
int c = c[1];         // On récupère 1
```

```asm
.data
myInt: .word 42, # On réserve un mot de 32 bits pour stocker un entier.

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

Permet de d'écrire dans la mémoire un mot de 32 bit contenu dans votre registre de destination
à l'adresse contenue dans le registre source plus un offset.

La mémoire est adressable de de 4 en 4.

Exemple de code pour stocker un mot
```mips
.data
myInt .word 0

.text
la t1, myInt # t1    <- myInt
li t0, 42    # t0    <- 42
sw t0, 0(t1) # M[t1] <- t0
```

> sh lb registre_destination, offset(registre_source)

Écrire un 16 bits un demi-mot dans la mémoire c'est utile pour gérer du hardware.
La mémoire est addressable de 2 en 2.

> sb lb registre_destination, offset(registre_source)

Cette instruction permet d'écrire un byte 8bits dans la mémoire c'est utile pour gérer des caractères ou du hardware.

la mémoire est adressable de 1 en 1.

#### Instruction de Branchements

Pour pouvoir écrire des programmes en fonctions de résultats de vos calculs, il faut pouvoir
«choisir» quel code executer selon un résultat, il s'agit des instructions de branchement.
Dans nos langages hauts niveaux ont fait ça avec des boucles, `for`, `loop`, `if`, `else`, des appels de fonctions
voir des exceptions.

Cas particulier: le `match` de Rust ou swift ou le `switch-case` en C, Javascript etc. Est un peu différent en terme de comment
on le compile par rapport à un `if`.

Pour réaliser cela nous avons à notre disposition des instructions de branchement conditionnelles et non conditionnelles,
l'idée générale est de sauter en fonction d'un test sur plusieurs registres à une adresse via son label ou à un registre.

#### Branchements non conditionnels (Jumps)

Pour faire des sauts inconditionnel il existe la pseudo instruction:

> j label

```mips
li t0, 42
j my_exit # On saute à my_exit directement

# Ici cette instruction ne sera jamais executé :(
add t0, t0, 1

my_exit:
# t0 vaut donc 42 ici.
```

`jal` jump and link, instruction qui sauvegarde l'addresse ou on était
et saute au label, très utile pour lorsque nous feront des fonctions.

> jal reg_save_addr, label

Not: En réalité `j` est réalisé par un `jal x0 label` on sauvegarde pas l'addresse courante avant le saut
et on saute! ;)

#### Branchements conditionnels

| Format | Signification
|:-------|:----:|
| beq    | Branch if equal    |
| bge    | Branch if greater than or equal |
| bgeu   | Branch if greater than or equal (unsigned)    |
| blt    | Branch if less than |
| bltu   | Branch if less than (unsigned) |
| bne    | Branch not equal |

Ici le format est très régulier entre toutes ces instructions vous aurrez toujours:

> branch_instruction op1 op2 label

Ça permet de réaliser les branchements utiles pour faire des programmes.

#### Affectation conditionnelles

Comming Soon

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

> Aller plus loin: Pourquoi avoir une instruction pour «appeller» le système d'exploitation? Car il s'execute avec des droits étendus
> sur l'ordinateur et a access à des instructions privilégiées: https://content.riscv.org/wp-content/uploads/2017/05/riscv-privileged-v1.10.pdf

#### Formatage binaire des instructions

En RiscV les instructions sont divisées en 6 formats:

- Format R : Instructions de manipulation registre à registre ex: `add, sub, sll, slt, sltu, xor`
- Format I : Instructions avec un immédiat 11 bit ex: `lw, lh, lb, jalr`
- Format S : Instructions d'écriture mémoire ex: `sw, sh, sb`
- Format SB : Instructions de branchement relatifs ex: `beq, bne, bge, blt, bltu, bgeu`
- Format U : Instruction avec le haut d'un immédiat sur `[31:12]` ex: `aiupc, lui`
- Format UJ : Instructions de branchement sur un registre ex: `jal`

_Référence_: Si vous voulez en savoir plus je vous recommande le chapitre 7 du cours «[cs61c](https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf)» de l'université Berkley par Steven Ho ~45 min de lecture à tête reposée.

### Fonctions et conventions d'appels

Une fonction c'est juste un ensemble d'instructions «regroupé», pour
l'utiliser on «saute» à son adresse de début puis on en revient une fois fini. Pour sauter,
facilement au début de ce bloc, on nomme les entrées d'un suite d'instructions à l'aide de
label/étiquette.

Les fonctions peut être écrite par des personnes différentes
directement en assembleur, ou même résulter des compilations sous format
de fichier objet `.o` provenant de compilateurs différent.

Il n'est pas possible de seulement définir pour 2 personnes une convention pour communiqué,
notamment car il n'y pas forcément de relation/communication entre les
différents programmeur, par exemple dans le cas de librairie de code.


Pour résoudre ce problème, une convention stardard, appellé [Aplication Binary Interface](https://en.wikipedia.org/wiki/Application_binary_interface) est défini selon au moins :

- jeux d'instruction
- format du binaire
- système d'exploitation
- des détails hardware par exemple la gestion des flottants.

Nous concrétement en RiscV on utilise l'ABI [riscv-elf-linux](https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md).

Pour revenir à notre fonction `somme` son code pourrais ressembler de façon optimiser :

```mips
# a0: Addresse d'itération sur le tableau
# a1: Taille du tableau
somme:
    mv   t2, zero     # sum <- 0
    beqz a1, end_loop # size == 0?

    slli a1, a1, 2    # size <- (size * 4)
    mv   t0, a0       # @fin <- @base
    # Calcul adresse de fin du tableau
    # @fin <- @base + (size * 4)
    add  t0, a0, a1 # @Fin <- @base + size

# Notre boucle qui fait la somme.
loop:
    lw   t1, 0(a0)    # val <- *iterateur
    addi a0, a0, 4    # @iterateur + 4
    add  t2, t2, t1   # somme += val
    bne  t0, a0, loop # @iterateur == @fin

end_loop:
    mv   a0, t2  # On copie sum dans le registre de retour
    jr   ra, 0   # On retourne dans la fonction qui avait appellée somme
```

Et le code pour appeller `somme` à:

```mips
array: .word 1, 1, 1

.text

# On charge les paramètres pour appeller somme
# a0: contiens l'adresse du tableau
# a1: contiens la somme
la a0, array
li a1, 3
jal somme

# print result of sum contained in a0.
li a7, 1
ecall

# call exit pour terminer le programme.
li a7, 10
ecall
```

`somme` ici est une fonction dite terminale, elle n'appelle pas d'autres fonctions donc on à pas besoin de sauvegarder
le contenu des registres et on à utiliser que des registres temporaires et à sauvegarder par l'appellant dans le corps de `somme`.

Cependant il s'agit d'une optimisation un compilateur C sans aucune optimisation aurait produit un code avec une
sauvegarde des registres sur la pile.

<!-- TODO: Schema pile -->

<!--

```mips
somme:
    # Prologue de la convention d'appel
    # Somme utilise 3 registres
    # temporaires non sauvegardé: t0, t1, t2
    # @retour: ra
    # On dois donc réserver 3 + 1 * 4 mots dans la pile
    addi sp, sp, -16 # On reserve 4 emplacements de 32bits dans la pile.
    sw   ra, 0(sp)   # On sauve l'addresse de retour

    # Le Corps de la fonction reste inchangé
    # ...
    # Sur une fonction plus compliqué on pourrais appeller des fonctions dans son corps

    # Epilogue de la convention d'appel
    lw   ra, sp(0)  # On récupére notre addresse de retour
    addi sp, sp, 16 # On libère 4 mots de 32 bits dans la pile
    jal ra
```

On retrouve bien la convention d'appel qui sauvegarde tout les registres.

On vois ici que les registres sauvegardé sont:
-->
<!--
## Exercices

(refactoring à venir)
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

< !-- - Ecrire un compresseur [RLE](https://fr.wikipedia.org/wiki/RLE)
    objectif : accès mémoire, registre
    -- >

- Faire un chiffrement simple par décalage
    objectif : utilisation des décalage de bits
-->

### Références:

- https://en.wikipedia.org/wiki/RISC-V
- https://rv8.io/asm.html
- https://rv8.io/isa
- https://github.com/riscv/riscv-isa-manual

- Cours MIT archi https://www.youtube.com/channel/UC1DcxXg6GkAcp2zk2w7U6qQ/videos
- https://riscv.org/specifications/
- https://inst.eecs.berkeley.edu/~cs61c/fa17/lec/05/L05%20RISCV%20Intro%20(1up).pdf
