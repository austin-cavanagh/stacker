.global main
.global configurePins
.global startAnimation
.global playGame
.global turnOffLeds
.global endAnimation

@ Import blinkLed C function
.extern blinkLed

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

@ Executable code section
.align 4
.section .text

@ Function handles program logic
main:
    @ Push return address in the link register to the stack
    push {lr}

    @ @ Configure gpio pins used for the game
    bl configurePins

    @ Display start animation until button is pressed
    bl startAnimation

    @ Play the game
    bl playGame

    @ Display end animation after completing the game
    @ r0 - blinkCount
    @ r1 - blinkDuration
    mov r0, #10
    mov r1, #250
    bl endAnimation

    @ Return to the calling enviornment
    mov r0, #0                      @ Move the value of 0 into r0 to indicate success
    pop {lr}                        @ Pop return address off stack and store in the link register
    bx lr                           @ Branch to the return address in the link register


@ Function handles core game logic
playGame:
    @ Push return address in the link register onto the stack
    push {lr}
    
    @ Save variables in registers
    mov r4, #0                    @ Move value of 0 into r4 for current LED

    @ Loop until curLed equals NUM_LEDS
playGameWhileLoop:
    cmp r4, #NUM_LEDS			    @ Compare current LED in r4 with NUM_LEDS
    bge playGameEnd                 @ Branch to playGameEnd

    @ Blink current LED and get success or failure from button press
    ldr r0, =ledPins                @ Load address of ledPins into r0
    add r0, r0, r4, lsl #2          @ Add address of ledPins[i] into r0 
    ldr r0, [r0]                    @ Load value of ledPins[i] into r0
    mov r1, #500                    @ Move blink duration of 500 into r1
    bl blinkLed                     @ Call blinkLed function

    @ Determine if press was a success or failure
    cmp r0, #0                      @ Compare if button press was failure
    beq playGameFailure             @ If failure branch to playGameFailure
    add r4, r4, #1                  @ Increment current LED by 1 for success
    b playGameWhileLoop             @ Branch to playGameWhileLoop to continue

playGameFailure:
    mov r4, #0                      @ Move 0 into r4 to set current LED to 0
    bl turnOffLeds                  @ Branch to turnOffLeds function
    b playGameWhileLoop             @ Branch to playGameWhileLoop to continue

    @ Exit the function
playGameEnd:
    @ Branch back to the function call for valid inputs
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


@ Function handles the end annimation after the game ends
@ r0 - blinkCount
@ r1 - blinkDuration
endAnimation:
    @ Push return address in the link register onto the stack
    push {lr}

    @ Save variables in registers
    mov r4, #0                      @ Move value of 0 into r4 for i = 0
    mov r5, r0                      @ Move value of blinkCount in r0 into r5
    mov r6, r1                      @ Move value of blinkDuration in r1 into r6

    @ Run animation based on blink count argument variable
endAnimationLoop:
    cmp r4, r5			            @ Compare i in r4 with blinkCount in r5
	bge endAnimationEnd             @ Branch to endAnimationEnd when loop ends

    @ Turn on blue LEDs
    mov r0, #BLUE_1                 @ Move value of BLUE_1 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #BLUE_2                 @ Move value of BLUE_2 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #BLUE_3                 @ Move value of BLUE_3 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #BLUE_4                 @ Move value of BLUE_4 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin

    @ Delay based on blinkDuration
    mov r0, r6                      @ Move blinkDuration in r6 into r0
    bl delay                        @ Branch to delay function

    @ Turn off blue LEDs
    mov r0, #BLUE_1                 @ Move value of BLUE_1 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #BLUE_2                 @ Move value of BLUE_2 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #BLUE_3                 @ Move value of BLUE_3 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #BLUE_4                 @ Move value of BLUE_4 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin

    @ Turn on red LEDs
    mov r0, #RED_1                  @ Move value of RED_1 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #RED_2                  @ Move value of RED_2 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #RED_3                  @ Move value of RED_3 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #RED_4                  @ Move value of RED_4 into r0
    mov r1, #HIGH                   @ Move value of HIGH into r1
    bl digitalWrite                 @ Write to gpio pin

    @ Delay based on blinkDuration
    mov r0, r6                      @ Move blinkDuration in r6 into r0
    bl delay                        @ Branch to delay function

    @ Turn off red LEDs
    mov r0, #RED_1                  @ Move value of RED_1 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #RED_2                  @ Move value of RED_2 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #RED_3                  @ Move value of RED_3 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin
    mov r0, #RED_4                  @ Move value of RED_4 into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin

    @ Increment i by 1 and continue loop
    add r4, r4, #1                  @ Increment i by 1 and store in r4    
    b endAnimationLoop              @ Branch to endAnimationLoop to continue loop

 @ Exit the function
endAnimationEnd:
    @ Branch back to the function call for valid inputs
    pop {lr}                        @ Pop return address off stack and store in the link register
    bx lr                           @ Branch to the return address in the link register


@ Function turns off all LEDs
turnOffLeds:
    @ Push return address in the link register onto the stack
    push {r4, lr}

    @ Save variables in registers
    mov r4, #0                      @ Move value of 0 into r4 for i = 0

    @ Turn on all LEDs
turnOffLedsForLoop:
    cmp r4, #NUM_LEDS			    @ Compare i in r4 with NUM_LEDS
    bge turnOffLedsEnd              @ Branch to turnOffLedsEnd

    ldr r0, =ledPins                @ Load address of ledPins into r0
    add r0, r0, r4, lsl #2          @ Add address of ledPins[i] into r0 
    ldr r0, [r0]                    @ Load value of ledPins[i] into r0
    mov r1, #LOW                    @ Move value of LOW into r1
    bl digitalWrite                 @ Write to gpio pin

    @ Increment i by 1 and continue loop
    add r4, r4, #1                  @ Increment i by 1 and store in r4    
    b turnOffLedsForLoop            @ Branch to turnOffLedsForLoop to continue loop

    @ Exit the function
turnOffLedsEnd:
    @ Branch back to the function call for valid inputs
    pop {r4, lr}                    @ Pop return address off stack and store in the link register
    bx lr                           @ Branch to the return address in the link register