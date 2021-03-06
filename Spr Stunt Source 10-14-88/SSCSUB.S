;@A D	 *4>HR\+p
; Z-1________ -0

	.subttl "SSCSUB.S:  Subroutines and Calls"
; Z-1________ -0

waitvb:		;Wait for start of Vertical Blank, 1/120 to 1/60 sec. delay
		lda MSTAT 	;[SSCEQU]
		rol
		bcs waitvb	;vblank on, but unknown time remaining
.1:		lda MSTAT
		rol
		bcc .1		;vblank off, wait until it starts then return
        rts 
; Z-1________ -0

ramzero:		;Store COUNT zeros in block starting at POINT.
	lda #0
	ldx #0 
pokit: sta (POINT,X)
	   inc POINT		;[SSCEQU] pg0
	   bne hiok
	   inc POINT+1		
hiok:  dec COUNT		;[SSCEQU] pg0
	   bne pokit
	   dec COUNT+1
	   bpl pokit		;ok for <$8000 bytes
	   rts
; Z-1________ -0

Random:		;Pseudorandom Sequence Generator, or "Poly-Counter"
	lda ShiftReg+1		;[SSCEQU]
	and #%00001000		;tap at stage 13
	sta Feedback		;
	lda ShiftReg+3
	and #%00000010		;tap at stage 31
	ora Feedback
	sta Feedback		;feedback taps determine sequence length
	bne .0	;NAND both inputs low = 0 out
	clc		;carry will rotate into the shift register
	bcc .4	;always
.0: cmp #%00001010
	bne .1
	clc		;NAND both inputs high = 0 out
	bcc .4	;always
.1: sec		;NAND for either high = 1 out
.4: ror ShiftReg
	ror ShiftReg+1
	ror ShiftReg+2
	ror ShiftReg+3
;tap for output
	lda ShiftReg
	and #%00000110		; 6 and 7
	sta RandomNumber
	lda ShiftReg+1
	and #%00101000		; 11 and 13
	ora RandomNumber
	sta RandomNumber
	lda ShiftReg+2
	and #%10010000		;17 and 20
	ora RandomNumber
	sta RandomNumber
	lda ShiftReg+3
	and #%01000001		;26 and 32
	ora RandomNumber
	sta RandomNumber	;Outputs RandomNumber and accumulator
	rts
; The nominal repeat rate for the above number series is 2,147,483,647 numbers.
; Always use realtime inputs whenever possible to increase randomness by
; seeding ShiftReg from WhirliGig when a realtime input occurs.



; Z-1________ -0

* Read Console Switches, Joy Stick and Buttons
direc:
;snooze:
right:
left:
down:
up:     rts
fire:
        lda  INPT0
        and  #$80
        bne  pushed
        rts
pushed:
        jsr  waitvb
        put  #0,BKGRND
        put  #$4A,DPPH
	 	RTS
; .end
; Z-1________ -0

                                                                                                                                                                                                                                             