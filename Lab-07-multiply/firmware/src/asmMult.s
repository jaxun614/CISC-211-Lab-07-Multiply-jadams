/*** asmMult.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Jackson Adams"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global a_Multiplicand,b_Multiplier,rng_Error,a_Sign,b_Sign,prod_Is_Neg,a_Abs,b_Abs,init_Product,final_Product
.type a_Multiplicand,%gnu_unique_object
.type b_Multiplier,%gnu_unique_object
.type rng_Error,%gnu_unique_object
.type a_Sign,%gnu_unique_object
.type b_Sign,%gnu_unique_object
.type prod_Is_Neg,%gnu_unique_object
.type a_Abs,%gnu_unique_object
.type b_Abs,%gnu_unique_object
.type init_Product,%gnu_unique_object
.type final_Product,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmMult gets called, you must set
 * them to 0 at the start of your code!
 */
a_Multiplicand:  .word     0  
b_Multiplier:    .word     0  
rng_Error:       .word     0  
a_Sign:          .word     0  
b_Sign:          .word     0 
prod_Is_Neg:     .word     0  
a_Abs:           .word     0  
b_Abs:           .word     0 
init_Product:    .word     0
final_Product:   .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmMult
function description:
     output = asmMult ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmMult
.type asmMult,%function
asmMult:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmMult.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 8 Multiply
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* DON'T TOUCH R0 or R1!!! they hold the cand and the plier */
    
    
    
    /* initalize values of each mem address to 0 */
    mov r11, 0
    
    ldr r3, =rng_Error /* rng_error mem location (0x964) */
    str r11, [r3]
    
    ldr r3, =a_Sign /* a_Sign mem location (0x968) */
    str r11, [r3]
    
    ldr r3, =b_Sign /* b_Sign mem location (0x96C) */
    str r11, [r3]
    
    ldr r3, =prod_Is_Neg /* prod_Is_Neg mem location (0x970) */
    str r11, [r3]
    
    ldr r3, =a_Abs /* a_Abs mem location (0x974) */
    str r11, [r3]
    
    ldr r3, =b_Abs /* b_Abs mem location (0x978) */
    str r11, [r3]
    
    ldr r3, =init_Product /* init_Product mem location (0x97C) */
    str r11, [r3]
    
    ldr r3, =final_Product /* final_Product mem location (0x980) */
    str r11, [r3]
    
    /* write r0 to the mem location of a_Multiplicand */
    ldr r3, =a_Multiplicand
    str r0, [r3]
    
    /* write r1 to the mem location of b_Multiplier */
    ldr r3, =b_Multiplier
    str r1, [r3]
    
    
    /* Check if either r0 or r1 exceeds the valid range for a signed 16bit number */
    ldr r3, =0x7FFF
    cmp r0, r3
    bgt rng_Error_check /* take this path when the values are too big */
    cmp r1, r3
    bgt rng_Error_check /* take this path when the values are too big */
 
    
in_rng:
    /* Store the sign bits of a_Sign and b_Sign */    
    movs r2, r0 /* move the cand into a temp register to be worked on, and set the flags */
    /* move the sign bit to the LSB */
    lsr r2, r2, #31 /* shift the MSB 31bits to the right, this puts the sign bit in the LSB */
    ldr r4, =a_Sign /* a_Sign mem location (0x968) */
    str r2, [r4] 
    
    /* r2 will be the register that holds the 'b' value */    
    movs r3, r1 /* move the plier into r2 to be worked on and set the flags */
    lsr r3, r3, #31 /* shift the MSB 31bits to the right, this puts the sign bit in the LSB */ 
    ldr r4, =b_Sign /* b_Sign mem location (0x96C) */
    str r3, [r4]
    
    /* if the result of the addition is 1, then the product will be negative */
    /* if the result of the addition is 2 or 0, then the product will be positive */
    add r5, r2, r3 /* add the two sign bits and store them in r5 */
    
    /* Determin if the product will be negative or positive */
    mov r2, #1 /* write 1 to r2 */
    cmp r5, r2 /* compare the sum of the signs to r2 */
    beq product_Is_Neg /* take this path when the product is negative */
    bne product_Is_Pos /* take this path when the product is positive */
    
    
/* the final product is negative */
product_Is_Neg:
    mov r2, #1 /* write 1 to r2 */
    ldr r3, =prod_Is_Neg /* write the mem address of prod_Is_Neg to r3 */
    str r2, [r3] /* store 1 in the mem address of prod_Is_Neg */
    b skip_Product_Is_Pos /* jump over the positive case */
    
    
/* the final product is positive */
product_Is_Pos:    
    mov r2, #0 /* write 0 to r2 */
    ldr r3, =prod_Is_Neg /* write the mem address of prod_Is_Neg to r3 */
    str r2, [r3] /* store 0 in the mem address of prod_Is_Neg */
    
    
/* this block is for getting the Abs value of the cand and plier */
skip_Product_Is_Pos:
    /* first determine if the value is negative */
    ldr r2, =a_Sign /* a_Sign mem location (0x968) */
    ldr r3, [r2] /* write the value at mem location of a_Sign to r3 */
    mov r4, #1 /* write 1 to r4 */
    cmp r3, r4 /* compare a_Sign with r4 */
    beq do_a_Abs_Value /* if they are equal the cand is negative and take the abs value */
    /* the cand was positive so just store it as is */
    ldr r2, =a_Abs 
    str r0, [r2]
    
    
check_b_Abs_Value:
    ldr r2, =b_Sign
    ldr r3, [r2]
    mov r4, #1
    cmp r3, r4
    beq do_b_Abs_Value
    ldr r2, =b_Abs
    str r1, [r2]
    mov r6, #32 /* offset for shifting */
    mov r8, #1
    /* move the abs value of the cand and plier, before the loop so they aren't effected */
    ldr r2, =a_Abs /* write the mem address of a_Abs to r2 */
    ldr r3, [r2] /* write the value of a_Abs to r3, r3 is the abs value cand */
    ldr r2, =b_Abs /* write the mem address of b_Abs to r2 */
    ldr r4, [r2] /* write the value of b_Abs to r4, r4 is the abs value of plier */
    b shift_add
        
    
/* the cand is negative so do the Abs value*/
do_a_Abs_Value:
    mvn r3, r0 /* take the 1's complement */
    add r3, #1 /* add 1 to the 1's complement */
    ldr r2, =a_Abs /*  */
    str r3, [r2]
    b check_b_Abs_Value
    
    
do_b_Abs_Value:
    mvn r3, r1 /* take the 1's complement */
    add r3, #1 /* add 1 to the 1's complement */
    ldr r2, =b_Abs /*  */
    str r3, [r2]
    mov r6, #32 /* offset for shifting */
    mov r8, #1
    /* move the abs value of the cand and plier, before the loop so they aren't effected */
    ldr r2, =a_Abs /* write the mem address of a_Abs to r2 */
    ldr r3, [r2] /* write the value of a_Abs to r3, r3 is the abs value cand */
    ldr r2, =b_Abs /* write the mem address of b_Abs to r2 */
    ldr r4, [r2] /* write the value of b_Abs to r4, r4 is the abs value of plier */

    
/* do the shift and add algorithm */    
shift_add:
    /* check if the plier is zero, if it is return the pruduct and exit */
    mov r5, #0 /* write 0 to r5 */
    cmp r4, r5 /* compare the plier in r4 with r5 */
    beq zero_plier
    /* the plier is not zero */
    /* check the LSB */
    /* if the LSB is 1, add the cand to the init_product */
    mov r6, r4 /* move the abs plier to another register to be worked on */
    rors r6, r6, r8 /* rotate the LSB to the MSB and set the flags */
    add r8, #1
    bne add_cand /* if the LSB was 1 then the sign bit will now be negative */
    
/* the LSB was not 1 so we have to shift the bits */
shift_bits:
    lsl r3, r3, #1 /* shift the cand bits 1 to the left */
    lsr r4, r4, #1 /* shift the plier bits 1 to the right */
    b shift_add
    
/* add the cand to the init_product */    
add_cand:
    ldr r2, =init_Product /* get the mem address of the init_product */
    ldr r7, [r2] /* write the value of init_product to r7 */
    add r7, r7, r3 /* add the init_product to the cand and store that result in r7 */
    str r7, [r2] /* store the init_product to the mem location of init_product */
    b shift_bits
    
    
    
    
/* the plier was zero, so no  */
zero_plier:
    ldr r2, =final_Product
    ldr r0, [r2]
    b done
    
    
rng_Error_check:
    /* write 1 to the mem location of rng_Error to signify that the value was out of range */
    ldr r3, =rng_Error /* rng_error mem location (0x964) */
    mov r4, 1
    str r4, [r3]
    /* write 0 to r0 because no multiplication happened */
    mov r0, 0
    b done

    
    

    
    
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmMult return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




