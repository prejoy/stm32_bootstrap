  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb


.global Boot_Handler
.global Boot_Vector
.extern Reset_Handler

/* define the initial code , relocate the isr,text,or so on */
  .section .text.Boot_Handler
  .type Boot_Handler, %function
Boot_Handler:
	mov r1,#0
	ldr r0,=_sflashcode
	ldr r2,=_sramisr_vector
	ldr r3,=_eflashcode
	sub r3,r3,r0

	/* copy from flash to ram , the exec code must be aligned */
LoopCopyIsrVector:
	ldr r4,[r0,r1]
	str r4,[r2,r1]
	add r1,r1,#4
	cmp r3,r1
	bne LoopCopyIsrVector
	ldr pc,=Reset_Handler

    .word _sramisr_vector
    .word _sflashcode
    .word _eflashcode
	.size Boot_Handler, .-Boot_Handler


/* initial vector ,must be in flash ,mcu absolutely start at [0x08000004] */
  .section .bootstrap,"a",%progbits
  .type Boot_Vector, %object
  .size Boot_Vector, .-Boot_Vector

Boot_Vector:
  .word _estack
  .word Boot_Handler

