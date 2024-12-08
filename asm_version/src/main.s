.global main
.global configurePins
.global startAnimation

@ Define constants
.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ RED_1, 18
.equ BLUE_1, 23
.equ RED_2, 24
.equ BLUE_2, 25
.equ RED_3, 12
.equ BLUE_3, 16
.equ RED_4, 20
.equ BLUE_4, 21
.equ NUM_LEDS, 8
.equ PIN_BUTTON, 4

@ Read only data section
.align 4
.section .rodata

ledPins:
    .word RED_1
    .word BLUE_1
    .word RED_2
    .word BLUE_2
    .word RED_3
    .word BLUE_3
    .word RED_4
    .word BLUE_4

JanStr: .asciz "January\n"


@ Executable code section
.align 4
.section .text

msg_loop:
    .ascii "LED loop iteration: %d\n\0"

@ @ Print something to make sure it is running
@ ldr r0, =JanStr   @ format string
@ bl printf

@ Function handles program logic
main:
    @ Push return address in the link register to the stack
    push {lr}

    @ Configure gpio pins used for the game
    bl configurePins

    @ Display start animation until button is pressed
    bl startAnimation

    @ Return to the calling enviornment
    pop {lr}                        @ Pop return address off stack and store in the link register
    bx lr                           @ Branch to the return address in the link register







@ Function handles the start annimation before the button is pressed to start the game
startAnimation:
    @ Push return address in the link register onto the stack
    push {lr}
    
    @ Save variables in registers
    mov r5, #LOW                    @ Move value of LOW into r5 for button state
    mov r6, #40                     @ Move value of 40 into r6 for delay time

    @ Loop through the animation until the button is pressed
startAnimationWhileLoop:

    @ Light LEDs from start to end
    mov r4, #0                      @ Move value of 0 into r4 for i = 0
startToEndForLoop:
    cmp r4, #NUM_LEDS			    @ Compare i in r4 with NUM_LEDS
    bge endToStartLoopIndex         @ Branch to endToStartLoopIndex

    ldr r0, =ledPins                @ Load address of ledPins into r0
    add r0, r0, r4, lsl #2          @ Add address of ledPins[i] into r0 
    ldr r0, [r0]                    @ Load value of ledPins[i] into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin

    mov r0, r6                      @ Move delay time in r6 into r0
    bl delay                        @ Branch to delay function

    ldr r0, =ledPins                @ Load address of ledPins into r0
    add r0, r0, r4, lsl #2          @ Add address of ledPins[i] into r0 
    ldr r0, [r0]                    @ Load value of ledPins[i] into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin

    mov r0, r6                      @ Move delay time in r6 into r0
    bl delay                        @ Branch to delay function

    @ Exit function to start game if button is pressed
    mov r0, #PIN_BUTTON             @ Move value of PIN_BUTTON into r0
    bl digitalRead                  @ Read button state
    cmp r0, #HIGH                   @ Compare if button state is HIGH
    beq startAnimationEnd           @ Branch to startAnimationEnd

    add r4, r4, #1                  @ Increment i by 1 and store in r4    
    b startToEndForLoop             @ Branch to configurePinsForLoop to continue loop 

    @ Light LEDs from end to start
endToStartLoopIndex:
    mov r4, #NUM_LEDS               @ Move value of NUM_LEDS into r4
    sub r4, r4, #2                  @ Move value of NUM_LEDS - 2 into r4 for i

endToStartForLoop:
    cmp r4, #0			            @ Compare i in r4 with 0
    ble startAnimationWhileLoop     @ Branch to startAnimationWhileLoop

    ldr r0, =ledPins                @ Load address of ledPins into r0
    add r0, r0, r4, lsl #2          @ Add address of ledPins[i] into r0 
    ldr r0, [r0]                    @ Load value of ledPins[i] into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin

    mov r0, r6                      @ Move delay time in r6 into r0
    bl delay                        @ Branch to delay function

    ldr r0, =ledPins                @ Load address of ledPins into r0
    add r0, r0, r4, lsl #2          @ Add address of ledPins[i] into r0 
    ldr r0, [r0]                    @ Load value of ledPins[i] into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin

    mov r0, r6                      @ Move delay time in r6 into r0
    bl delay                        @ Branch to delay function

    @ Exit function to start game if button is pressed
    mov r0, #PIN_BUTTON             @ Move value of PIN_BUTTON into r0
    bl digitalRead                  @ Read button state
    cmp r0, #HIGH                   @ Compare if button state is HIGH
    beq startAnimationEnd           @ Branch to startAnimationEnd

    sub r4, r4, #1                  @ Decrement i by 1 and store in r4    
    b endToStartForLoop             @ Branch to configurePinsForLoop to continue loop

    @ Exit the function
startAnimationEnd:
    @ Branch back to the function call for valid inputs
    pop {lr}                        @ Pop return address off stack and store in the link register
    bx lr                           @ Branch to the return address in the link register


@ Function handles the start annimation before the button is pressed to start the game
configurePins:
    @ Push return address in the link register onto the stack
    push {lr}
    
    @ Initialize gpio with wiringPi setup
    bl wiringPiSetupGpio

    @ Save variables in registers
    mov r4, #0                      @ Move value of 0 into r4 for i = 0

    @ Set the button pin as an input
    mov r0, #PIN_BUTTON             @ Move value of PIN_BUTTON into r0
    mov r1, #INPUT                  @ Move value of INPUT into r1
    bl pinMode

    @ Set each led pin as an output
configurePinsForLoop:                 
    cmp r4, #NUM_LEDS			    @ Compare i in r4 with NUM_LEDS
    bge configurePinsEnd            @ Branch to configurePinsEnd

    ldr r0, =ledPins                @ Load address of ledPins into r0
    add r0, r0, r4, lsl #2          @ Add address of ledPins[i] into r0 
    ldr r0, [r0]
    mov r1, #OUTPUT                 @ Move value of OUTPUT into r1
    bl pinMode

    @ Increment i by 1 and continue loop
    add r4, r4, #1                  @ Increment i by 1 and store in r4    
    b configurePinsForLoop          @ Branch to configurePinsForLoop to continue loop

    @ Exit the function
configurePinsEnd:
    @ Branch back to the function call for valid inputs
    pop {lr}                        @ Pop return address off stack and store in the link register
    bx lr                           @ Branch to the return address in the link register