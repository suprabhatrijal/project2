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

# exit
li $v0, 10
syscall
