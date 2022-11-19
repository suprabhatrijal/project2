.data
input: .space 1001
input_prompt: .asciiz "Input: "
.text
main:

# get input string from the user
li $v0, 8
la $a0, input
li $a1, 1001
syscall

la $a0, input
jal base_to_decimal

j exit

exit:
# exit
li $v0, 10
syscall

base_to_decimal:
# go through the string find the address of start and end of string without spaces or tabs

# initialize the loop
li $s0, 0 # flag which is true if first valid char has been encountered
addi $s2, $a0, 0 # Address of the input string
firstPass:
lb $s4, 0($s2) # current character

### if char is space or tab
li $t1, 32
li $t2, 9
seq $t3, $s4, $t1 # $s4 == SPACE
seq $t4, $s4, $t2 # $s4 == TAB

or $t1, $t3, $t4 # $s4 == SPACE or $s4 == TAB
li $t2, 1
## else if not space or tab $v0 = -1 and jr $ra
bne $t1, $t2 notSpace # if not ($s4 == SPACE or $s4 == SPACE)

j firstPassCOTD

notSpace:
li $t1, 1
beq $s0, $t1, firstCharEncountered
addi $s5, $s2, 0 # save the address in #s5

li $s0, 1

j firstPassCOTD

firstCharEncountered:
addi $s6, $s2, 0 # save the address in #s5
j firstPassCOTD
# return to main program
jr $ra

firstPassCOTD:
# set the register t2 to point at the next character
addi $s2, 1

lb $s4, 0($s2) # current character
# increment the counter variable
li $t1, 0
li $t2, 10
seq $t3, $s4, $t1 # $s4 == NULL
