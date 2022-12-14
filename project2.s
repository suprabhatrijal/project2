.data
input: .space 1001
invalid_output: .asciiz "Unrecognized input"
.text
main:

# get input string from the user
li $v0, 8
la $a0, input
li $a1, 1001
syscall

# use the input as parameter and call the base_to_decimal function
la $a0, input
jal base_to_decimal

# if the function returns -1 print invalid input
li $t1, -1
beq $v0, $t1, printInvalid
# else print the output
addi $s0, $v0, 0
addi $s1, $v1, 0
# if $s1 is less than 1 handle edge case
slti $t1, $s1, 1
li $t2, 1
beq $t2, $t1 oneChar
j fixedEdgeCase

fixedEdgeCase:
# print the length
addi $a0, $s1, 0
li $v0, 1
syscall

#print comma
li $v0, 11
addi $a0, $zero, 44
syscall

# print the decimal number
addi $a0, $s0, 0
li $v0, 1
syscall

j exit


exit:
# exit
li $v0, 10
syscall

printInvalid:
# print the invalid output message
li $v0, 4
la $a0, invalid_output
syscall
j exit

base_to_decimal:
# go through the string find the address of start and end of string removing spaces

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
## if not space or tab go to notSpace
bne $t1, $t2 notSpace # if not ($s4 == SPACE or $s4 == SPACE)

# if it is space or tab continue
j firstPassCOTD

notSpace:
li $t1, 1
# if the first non space non tab char encountered store the location and continue
beq $s0, $t1, firstCharEncountered
# else store the location of current non space non tab char to $s5
addi $s5, $s2, 0 # save the address in #s5
li $s0, 1

j firstPassCOTD


firstCharEncountered:
addi $s6, $s2, 0 # save the address in #s5
j firstPassCOTD

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

# length is greater than 4 then it is invalid input
beq $t1, $t2, invalidChar

sub $t1, $s6, $s5


# if valid input then save the length as return value
addi $v1, $t1, 1

addi $s0, $s5, 0  # Address of the start of the string
addi $s1, $s6, 0 # Address of the end of the string


# reset all unused $s registers
li $s2, 0
li $s4, 0
li $s5, 0
li $s6, 0

# initialize the second pass
li $s3, 0 # sum of all numbers

j loop




loop:
beq $s0, $zero, invalidChar
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
li $t1, 1
# if char >= 97 and char < 123
beq $t0, $t1, Lower

# character falls in the range  'A' to 'Y'

# char < 65
slti $t0, $s4, 65 

# not (char < 65)  ===> ( char >= 65)
nor $t0, $t0, $zero

# char < 90
slti $t1, $s4, 90

and $t0, $t0, $t1
li $t1, 1
# if char >= 65 and char < 90
beq $t0, $t1, Upper

j invalidChar

Number:
# convert ascii into number
addi $t1, $s4, -48
# sum = sum*35 + cur_number
li $t2, 35
mult $t2, $s3
mflo $s3
add $s3, $s3, $t1 

j loopCOTD

Lower:
# convert ascii into number
addi $t1, $s4, -87
# sum = sum*35 + cur_number
li $t2, 35
mult $t2, $s3
mflo $s3
add $s3, $s3, $t1 

j loopCOTD

Upper:
# convert ascii into number
addi $t1, $s4, -55
# sum = sum*35 + cur_number
li $t2, 35
mult $t2, $s3
mflo $s3
add $s3, $s3, $t1 

j loopCOTD

loopCOTD:
# set the register t2 to point at the next character
addi $s0, 1

addi $t1, $s1, 1
slt $t1, $s0, $t1
li $t2, 1
beq $t1, $t2 loop # if current address < the address of null or enter char then loop

# loop ends then add the decimal value to return register and return
addi $v0, $s3, 0

# reset all the $s registers
li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
# return to main program
jr $ra

invalidChar:
li $v0, -1
jr $ra

oneChar:
li $s1, 1
j fixedEdgeCase
