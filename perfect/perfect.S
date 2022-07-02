.data

msg1:   .asciz "Perfect: %d\n"

.text

.global main

/**
  * unsigned int main()
  * Program that computes all perfect 
  * numbers from 1 to 10,000!
  * @author Yogesh Prabhu
  */

main:
    fp .req x29
    lr .req x30

    .equ number, 16   // word, starts at 16
    .equ divisor, 20  //word
    .equ sum, 24 //word
    .equ quotient, 32 //dword
    .equ remainder, 40 //dword
    .equ size, 48 //end on multiple of 16

    // Store fp and lr and makes space on the stack
    stp fp, lr, [sp, #-size]!
    mov fp, sp
    
    // Save number as local variable
    str w0,[fp,#number]

    //Save value of number
    mov w0, #0
    str w0, [fp, #number]


main_loop:
    
    //Number starts at 1 so add 1
    ldr w0, [fp, #number]
    add w0, w0, #1
    str w0, [fp, #number]
    
    //check if number > 10000
    ldr w0, [fp, #number]
    mov w1, #10000
    cmp w0, w1
    bgt main_return

    //Save value for divisor and sum
    mov w0, #0
    str w0, [fp, #divisor]
    
    mov w0, #0
    str w0, [fp, #sum]
    
inner_loop:
    //Add 1 to divisor so it starts at 1
    ldr w0, [fp, #divisor]
    add w0, w0, #1
    str w0, [fp, #divisor]
    
    //compare divisor and number -> divisor < number
    ldr w0, [fp, #divisor]
    ldr w1, [fp, #number]
    cmp w0, w1
    bge after_inner

    //divide divisor and number
    ldr w1, [fp, #divisor]
    ldr w0, [fp, #number]
    bl ldiv

    //store the values returned
    str x0, [fp, #quotient] 
    str x1, [fp, #remainder] 
  
    //compare the remainder to 0, i.e. if modulus is 0
    ldr x0, [fp, #remainder]
    cmp x0, #0
    beq proper_divisor

    b inner_loop

proper_divisor:
    //add the divisor on to the sum and looping back to inner loop
    ldr w0, [fp, #sum]
    ldr w1, [fp, #divisor]

    add w0, w0, w1
    str w0, [fp, #sum]
    
    b inner_loop 

after_inner:    
    //compare the sum and number to see if its perfect
    ldr w0, [fp, #number]
    ldr w1, [fp, #sum]
    cmp w0, w1
    beq perfect_print
  
    b main_loop

perfect_print:
    //printing the perfect number and looping back to main loop
    ldr x0, =msg1
    ldr w1, [fp, #number] 
    bl printf
    
    b main_loop

main_return:

    // Pop lr and fp and free stack space
    ldp x29, x30, [sp], #size
    ret
