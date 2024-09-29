;----------------------------------------------------------------------------
;
; Generated with Aklang2Asm V1.1, by Dan/Lemon. 2021-2022.
;
; Based on Alcatraz Amigaklang rendering core. (c) Jochen 'Virgill' Feldkötter 2020.
;
; What's new in V1.1?
; - Instance offsets fixed in ADSR operator
; - Incorrect shift direction fixed in OnePoleFilter operator
; - Loop Generator now correctly interleaved with instrument generation
; - Fine progress includes loop generation, and new AK_FINE_PROGRESS_LEN added
; - Reverb large buffer instance offsets were wrong, causing potential buffer overrun
;
; Call 'AK_Generate' with the following registers set:
; a0 = Sample Buffer Start Address
; a1 = 0 Bytes Temporary Work Buffer Address (can be freed after sample rendering complete)
; a2 = External Samples Address (need not be in chip memory, and can be freed after sample rendering complete)
; a3 = Rendering Progress Address (2 modes available... see below)
;
; AK_FINE_PROGRESS equ 0 = rendering progress as a byte (current instrument number)
; AK_FINE_PROGRESS equ 1 = rendering progress as a long (current sample byte)
;
;----------------------------------------------------------------------------

AK_USE_PROGRESS			equ 0
AK_FINE_PROGRESS		equ 0
AK_FINE_PROGRESS_LEN	equ 8192
AK_SMP_LEN				equ 8192
AK_EXT_SMP_LEN			equ 0

AK_Generate:

				lea		AK_Vars(pc),a5

				ifne	AK_USE_PROGRESS
					ifeq	AK_FINE_PROGRESS
						move.b	#-1,(a3)
					else
						move.l	#0,(a3)
					endif
				endif

				; Create sample & external sample base addresses
				lea		AK_SmpLen(a5),a6
				lea		AK_SmpAddr(a5),a4
				move.l	a0,d0
				moveq	#31-1,d7
.SmpAdrLoop		move.l	d0,(a4)+
				add.l	(a6)+,d0
				dbra	d7,.SmpAdrLoop
				move.l	a2,d0
				moveq	#8-1,d7
.ExtSmpAdrLoop	move.l	d0,(a4)+
				add.l	(a6)+,d0
				dbra	d7,.ExtSmpAdrLoop

;----------------------------------------------------------------------------
; Instrument 1 - Mnemotron_sfx_C-3
;----------------------------------------------------------------------------

				moveq	#0,d0
				bsr		AK_ResetVars
				moveq	#0,d7
				ifne	AK_USE_PROGRESS
					ifeq	AK_FINE_PROGRESS
						addq.b	#1,(a3)
					endif
				endif
.Inst1Loop
				; v1 = osc_noise(128)
				move.l	AK_NoiseSeeds+0(a5),d4
				move.l	AK_NoiseSeeds+4(a5),d5
				eor.l	d5,d4
				move.l	d4,AK_NoiseSeeds+0(a5)
				add.l	d5,AK_NoiseSeeds+8(a5)
				add.l	d4,AK_NoiseSeeds+4(a5)
				move.w	AK_NoiseSeeds+10(a5),d0

				; v1 = sh(1, v1, 3)
				sub.w	#1,AK_OpInstance+0(a5)
				bge.s	.SHNoStore_1_2
				move.w	d0,AK_OpInstance+2(a5)
				move.w	#2,AK_OpInstance+0(a5)
.SHNoStore_1_2
				move.w	AK_OpInstance+2(a5),d0

				; v2 = osc_pulse(2, 128, 128, 64)
				add.w	#128,AK_OpInstance+4(a5)
				cmp.w	#((64-63)<<9),AK_OpInstance+4(a5)
				slt		d1
				ext.w	d1
				eor.w	#$7fff,d1

				; v2 = add(v2, 32767)
				add.w	#32767,d1
				bvc.s	.AddNoClamp_1_4
				spl		d1
				ext.w	d1
				eor.w	#$7fff,d1
.AddNoClamp_1_4

				; v1 = mul(v1, v2)
				muls	d1,d0
				add.l	d0,d0
				swap	d0

				; v2 = envd(5, 15, 0, 128)
				move.l	AK_EnvDValue+0(a5),d5
				move.l	d5,d1
				swap	d1
				sub.l	#289024,d5
				bgt.s   .EnvDNoSustain_1_6
				moveq	#0,d5
.EnvDNoSustain_1_6
				move.l	d5,AK_EnvDValue+0(a5)

				; v1 = mul(v1, v2)
				muls	d1,d0
				add.l	d0,d0
				swap	d0

				; v1 = mul(v1, v2)
				muls	d1,d0
				add.l	d0,d0
				swap	d0

				; v1 = onepole_flt(8, v1, 64, 0)
				move.w	AK_OpInstance+6(a5),d5
				move.w	d5,d6
				ext.l	d6
				asr.w	#7,d5
				asl.w	#6,d5
				ext.l	d5
				sub.l	d5,d6
				move.w	d0,d5
				asr.w	#7,d5
				asl.w	#6,d5
				ext.l	d5
				add.l	d6,d5
				cmp.l	#32767,d5
				ble.s	.NoClampMaxOPF_1_9
				move.w	#32767,d5
				bra.s	.NoClampMinOPF_1_9
.NoClampMaxOPF_1_9
				cmp.l	#-32768,d5
				bge.s	.NoClampMinOPF_1_9
				move.w	#-32768,d5
.NoClampMinOPF_1_9
				move.w	d5,AK_OpInstance+6(a5)
				move.w	d5,d0

				asr.w	#8,d0
				move.b	d0,(a0)+
				ifne	AK_USE_PROGRESS
					ifne	AK_FINE_PROGRESS
						addq.l	#1,(a3)
					endif
				endif
				addq.l	#1,d7
				cmp.l	AK_SmpLen+0(a5),d7
				blt		.Inst1Loop


;----------------------------------------------------------------------------

				; Clear first 2 bytes of each sample
				lea		AK_SmpAddr(a5),a6
				moveq	#0,d0
				moveq	#31-1,d7
.SmpClrLoop		move.l	(a6)+,a4
				move.b	d0,(a4)+
				move.b	d0,(a4)+
				dbra	d7,.SmpClrLoop

				rts

;----------------------------------------------------------------------------

AK_ResetVars:
				moveq   #0,d1
				moveq   #0,d2
				moveq   #0,d3
				moveq   #0,d0
				lea		AK_OpInstance(a5),a6
				move.l	d0,(a6)+
				move.l	d0,(a6)+
				move.l  #32767<<16,(a6)+
				rts

;----------------------------------------------------------------------------

				rsreset
AK_LPF			rs.w	1
AK_HPF			rs.w	1
AK_BPF			rs.w	1
				rsreset
AK_CHORD1		rs.l	1
AK_CHORD2		rs.l	1
AK_CHORD3		rs.l	1
				rsreset
AK_SmpLen		rs.l	31
AK_ExtSmpLen	rs.l	8
AK_NoiseSeeds	rs.l	3
AK_SmpAddr		rs.l	31
AK_ExtSmpAddr	rs.l	8
AK_OpInstance	rs.w    4
AK_EnvDValue	rs.l	1
AK_VarSize		rs.w	0

AK_Vars:
				dc.l	$00002000		; Instrument 1 Length 
				dc.l	$00000000		; Instrument 2 Length 
				dc.l	$00000000		; Instrument 3 Length 
				dc.l	$00000000		; Instrument 4 Length 
				dc.l	$00000000		; Instrument 5 Length 
				dc.l	$00000000		; Instrument 6 Length 
				dc.l	$00000000		; Instrument 7 Length 
				dc.l	$00000000		; Instrument 8 Length 
				dc.l	$00000000		; Instrument 9 Length 
				dc.l	$00000000		; Instrument 10 Length 
				dc.l	$00000000		; Instrument 11 Length 
				dc.l	$00000000		; Instrument 12 Length 
				dc.l	$00000000		; Instrument 13 Length 
				dc.l	$00000000		; Instrument 14 Length 
				dc.l	$00000000		; Instrument 15 Length 
				dc.l	$00000000		; Instrument 16 Length 
				dc.l	$00000000		; Instrument 17 Length 
				dc.l	$00000000		; Instrument 18 Length 
				dc.l	$00000000		; Instrument 19 Length 
				dc.l	$00000000		; Instrument 20 Length 
				dc.l	$00000000		; Instrument 21 Length 
				dc.l	$00000000		; Instrument 22 Length 
				dc.l	$00000000		; Instrument 23 Length 
				dc.l	$00000000		; Instrument 24 Length 
				dc.l	$00000000		; Instrument 25 Length 
				dc.l	$00000000		; Instrument 26 Length 
				dc.l	$00000000		; Instrument 27 Length 
				dc.l	$00000000		; Instrument 28 Length 
				dc.l	$00000000		; Instrument 29 Length 
				dc.l	$00000000		; Instrument 30 Length 
				dc.l	$00000000		; Instrument 31 Length 
				dc.l	$00000000		; External Sample 1 Length 
				dc.l	$00000000		; External Sample 2 Length 
				dc.l	$00000000		; External Sample 3 Length 
				dc.l	$00000000		; External Sample 4 Length 
				dc.l	$00000000		; External Sample 5 Length 
				dc.l	$00000000		; External Sample 6 Length 
				dc.l	$00000000		; External Sample 7 Length 
				dc.l	$00000000		; External Sample 8 Length 
				dc.l	$67452301		; AK_NoiseSeed1
				dc.l	$efcdab89		; AK_NoiseSeed2
				dc.l	$00000000		; AK_NoiseSeed3
				ds.b	AK_VarSize-AK_SmpAddr

;----------------------------------------------------------------------------
