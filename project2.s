.data
input: .space 1001
input_prompt: .asciiz "Input: "
.text
main:

# input prompt for testing
li $v0, 4
la $a0, input_prompt
syscall

# exit
li $v0, 10
syscall
