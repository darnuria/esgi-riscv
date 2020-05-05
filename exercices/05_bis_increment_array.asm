.data

# array: [1, 2, 3]
array: .word 3,4,5 
size: 3

.text

main:

# Preparer les arguments pour increment_array
# a0: contiens l'addresse du tableau
la a0, array

# a1: contiens la taille du tableau
la a1, size  # On charge l'addresse de size dans a0
lw a1, 0(a1) # On charge la valeur qui est à l'addresse de size

# Sauter dans la fonction increment_array
jal increment_array

## Call exit syscall
li a7, 10
ecall
# Le programme s'arrette


# Fonction increment_array
# Arguments:
# a0 : addresse du tableau a incrementer
# a1 : taille du tableau
#
# Return
# a0: return base address of array.
#
## Registres utilisées par la fonction:
# - t0: index sur le tableau
# - t1: a0[i] valeur à l'itérateur du tableau
# - t2: addresse de base + index
increment_array:

li t0, 0 # index = 0

# Itérer sur notre array
#  - stop si fin du tableau
#  - charger la valeur de a[i] dans t1
#  - faire t1 = t + 1
#  - recharger t1 dans a[i]

for:
# stop si index >= size
beqz a1, end_for
add t2, a0, t0 # array + index : array[i]
# t1 <- a[i]
lw t1, 0(t2)
# t1 = t1 + 1
addi t1, t1, 1
# a[i] <- t1
sw t1, 0(t2)

# index + 1
addi t0, t0, 4 # index++
addi a1, a1, -1
j for
end_for:
# a0 contiens deja l'addresse de base 
jr ra
## End increment_array