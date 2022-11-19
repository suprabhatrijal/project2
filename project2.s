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

# return to main program
jr $ra
