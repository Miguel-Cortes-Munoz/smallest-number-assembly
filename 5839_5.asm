.data
msg: .asciiz "Minimum value: "
T20numbers: .word 12, 20, -21, 13, 15, 18, -8, 10, -20, -1 # The ten numbers
max: .space 4 # The minimum

.text
main:
    la $s0, T20numbers       # Load address of the array into $s0

    # First min3 call with elements 0,1,2
    lw $a0, 0($s0)           # Load T[0] into $a0
    lw $a1, 4($s0)           # Load T[1] into $a1
    lw $a2, 8($s0)           # Load T[2] into $a2
    jal min3                 # Call min3, result in $v0

    # Second min3 call with previous min (in $v0), elements 3,4
    add $a0, $v0, $zero      # Move previous min to $a0
    lw $a1, 12($s0)          # Load T[3] into $a1
    lw $a2, 16($s0)          # Load T[4] into $a2
    jal min3                 # Call min3, result in $v0

    # Third min3 call with previous min, elements 5,6
    add $a0, $v0, $zero      # Move previous min to $a0
    lw $a1, 20($s0)          # Load T[5] into $a1
    lw $a2, 24($s0)          # Load T[6] into $a2
    jal min3                 # Call min3, result in $v0

    # Fourth min3 call with previous min, elements 7,8
    add $a0, $v0, $zero      # Move previous min to $a0
    lw $a1, 28($s0)          # Load T[7] into $a1
    lw $a2, 32($s0)          # Load T[8] into $a2
    jal min3                 # Call min3, result in $v0

    # Fifth min3 call with previous min and element 9 (twice)
    add $a0, $v0, $zero      # Move previous min to $a0
    lw $a1, 36($s0)          # Load T[9] into $a1
    add $a2, $a1, $zero      # Copy T[9] to $a2
    jal min3                 # Call min3, result in $v0

        # Store the result in 'max'
    la $s1, max              # Load address of 'max' into $s1
    sw $v0, 0($s1)           # Store the minimum value in 'max'

    # Copy $v0 to another register before printing
    move $t2, $v0           # Save minimum value in $t2

    # Print the message
    li $v0, 4               # Syscall code for print string
    la $a0, msg             # Load message
    syscall                 # Print message

    # Print the integer result
    li $v0, 1               # Syscall code for print integer
    move $a0, $t2           # Move saved min value to $a0
    syscall                 # Print integer

    # Exit the program
    li $v0, 10              # Exit syscall
    syscall

# Procedure min3: returns the minimum of $a0, $a1, $a2 in $v0
min3:
    slt $t0, $a0, $a1        # Check if $a0 < $a1
    bne $t0, $zero, a0_less_a1  # Branch if $a0 < $a1
    add $t1, $a1, $zero      # Else, $a1 is smaller
    j compare_a2
a0_less_a1:
    add $t1, $a0, $zero      # $a0 is smaller
compare_a2:
    slt $t0, $t1, $a2       # Check if $t1 < $a2
    bne $t0, $zero, t1_min  # Branch if $t1 < $a2
    add $v0, $a2, $zero      # Else, $a2 is the minimum
    j end_min3
t1_min:
    add $v0, $t1, $zero      # $t1 is the minimum
end_min3:
    jr $ra                   # Return to caller