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
# return to main program
jr $ra
