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
    
    ldr r3, =rng_Error
    str r11, [r3]
    
    ldr r3, =a_Sign
    str r11, [r3]
    
    ldr r3, =b_Sign
    str r11, [r3]
    
    ldr r3, =prod_Is_Neg
    str r11, [r3]
    
    ldr r3, =a_Abs
    str r11, [r3]
    
    ldr r3, =b_Abs
    str r11, [r3]
    
    ldr r3, =init_Product
    str r11, [r3]
    
    ldr r3, =final_Product
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
    bgt rng_Error_check
    
    rng_Error_check:
    /* write 1 to the mem location of rng_Error to signify that the value was out of range */
    ldr r3, =rng_Error
    mov r4, 1
    str r4, [r3]
    /* write 0 to r0 because no multiplication happened */
    mov r0, 0
    
    

    
    
    
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
           




