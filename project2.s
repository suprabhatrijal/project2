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
seq $t4, $s4, $t2 # $s4 == ENTER

or $t1, $t3, $t4 # $s4 == NULL or $s4 == ENTER
li $t2, 1
bne $t1, $t2 firstPass # if not ($s4 == NULL or $s4 == ENTER)then loop


# length of string = end-start +1
sub $t1, $s6, $s5
addi $t1, $t1, 1

# if $t1 > 4 then it is an invalid char
# not $t1 < 5 ====> $t1 >= 5
slti $t2, $t1, 5
nor $t2, $t2, $zero
li $t1, 0xffffffff

beq $t1, $t2, invalidChar

sub $t1, $s6, $s5

addi $v1, $t1, 1

addi $s0, $s5, 0  # Address of the start of the string
addi $s1, $s6, 0 # Address of the end of the string


# reset all unused $s registers
li $s2, 0
li $s4, 0
li $s5, 0
li $s6, 0


li $s3, 0 # sum of all numbers

j loop




loop:
lb $s4, 0($s0) # current character

# character falls in the range  '0' to '9'

# char < 47
slti $t0, $s4, 48 

# not (char < 48)  ===> ( char >= 48)
nor $t0, $t0, $zero

# char < 58
slti $t1, $s4, 58

and $t0, $t0, $t1
li $t1, 1
# if char >= 48 and char < 58
beq $t0, $t1, Number

# character falls in the range  'a' to 'y'

# char < 97
slti $t0, $s4, 97 

# not (char < 97)  ===> ( char  >= 97)
nor $t0, $t0, $zero

# char < 123
slti $t1, $s4, 122

and $t0, $t0, $t1

Number:
addi $t1, $s4, -48
li $t2, 30
mult $t2, $s3
mflo $s3
add $s3, $s3, $t1 

j loopCOTD

invalidChar:
li $v0, -1
jr $ra
