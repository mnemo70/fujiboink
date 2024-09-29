**********************************************************
* FujiBoink ... for Amiga
*
* 2024 by MnemoTroN / Spreadpoint
*
* Based on the 1986 Atari ST version published in
* START by Michael Park / Xanth Computing
*
* Reference:
* https://www.atarimagazines.com/startv1n2/Fujiboink.html
**********************************************************
* Uses AmigaKlang for sound sample synthesis.
* With thanks to Virgill for the preset!
* Uses ZX0 for animation data compression.
**********************************************************

_LVOForbid		equ	-132
_LVOPermit		equ	-138
_LVOAllocMem		equ	-198
_LVOFreeMem		equ	-210
_LVOOpenLibrary		equ	-408
_LVOCloseLibrary	equ	-414

copinit			equ	38		;graphics.library constant

MEMF_CHIP		equ	2		;AllocMem constant
MEMF_CLEAR		equ	$10000		;AllocMem constant

DisplayLineBytes	equ	44
DisplayHeight		equ	220		;Display height with safe buffer
FujiWidth		equ	18		;Width of Fuji in bytes
FujiHeight		equ	92		;Height of Fuji animation frame
BlitOffset		equ	6		;Offset to x-center of Fuji in bytes

;Sound defs
SampleBounceLength	equ	$2000		;from exemusic.asm
BouncePeriod		equ	160
BounceVolume		equ	$40

;Memory area sizes
AnimLengthUnpacked	equ	FujiWidth*FujiHeight*3*32
BitplaneSize		equ	DisplayLineBytes*DisplayHeight
DisplaySize		equ	BitplaneSize*4
SaveBufferSize		equ	(FujiWidth+2)*FujiHeight*3
ChipMemSize		equ	2*DisplaySize + 2*SaveBufferSize + AnimLengthUnpacked + SampleBounceLength

;Definitions for frame counting at program start
;The frame counter starts at Frame_StartNumber and counts down to zero.
;Then the Fuji drops and normal bouncing begins.
Frame_StartNumber	equ	360
Frame_FadeInStart	equ	275
Frame_FadeInDelay	equ	5
Frame_ShowFuji		equ	200
Frame_FadeOutStart	equ	50
Frame_FadeOutDelay	equ	5

FadeTableEntrySize	equ	20

WaitBlit:	macro
	btst	#6,2(a4)
wb\@:	btst	#6,2(a4)
	bne.s	wb\@
	endm

;Paula audio channel structure
	rsreset
sndptr:		rs.l	1
sndlen:		rs.w	1	;initial length
sndlenrep:	rs.w	1	;length for repeat
sndper:		rs.w	1
sndvol:		rs.w	1
snd_size:	rs.B	0

;All program variables
	rsreset
SysBase:	rs.l	1
IntuiBase:	rs.l	1
ScreenPtr:	rs.l	1
DMAStore:	rs.w	1
IntStore:	rs.w	1

background1:	rs.l	1
background2:	rs.l	1
backstore1:	rs.l	1
backstore2:	rs.l	1
Images:		rs.l	1
SampleBounce:	rs.l	1	;sample buffer

ptr1:		rs.l	1	;Ptr to screen bitplanes
ptr2:		rs.l	1
sptr1:		rs.l	1	;Ptr to save buffer
sptr2:		rs.l	1
oldptr1:	rs.l	1	;Ptr to background
oldptr2:	rs.l	1
copptr1:	rs.l	1	;Ptr to Copper list
copptr2:	rs.l	1

RainbowIndex:	rs.w	1	;Direct index into word-sized rainbow color table. Dec by 2.
ColorBack:	rs.w	1	;Color of Fuji backside
MoveMode:	rs.b	1
MoveFlag:	rs.b	1
SpinFlag:	rs.b	1
SideFlag:	rs.b	1	;0: Front (blue), $FF: Back (Rainbow)
KeyCode:	rs.b	1
StepFlag:	rs.b	1
StartDelay:	rs.w	1
XPos:		rs.w	1
YPos:		rs.w	1
YCount:		rs.w	1
YDirection:	rs.b	1
		rs.b	1
dmacon_mask:	rs.w	1
snddata:	rs.b	4*snd_size
data_sizeof:	rs.b	0

	section	main,code

	bra.s	Startup

	dc.b	"$VER: FujiBoink! Amiga by MnemoTroN/Spreadpoint (2024-07-02)",0
	even

Startup:
	lea	data_area(pc),a5
	move.l	4.w,a6
	move.l	a6,SysBase(a5)

	move.l	#ChipMemSize,d0
	move.l	#MEMF_CHIP|MEMF_CLEAR,d1
	jsr	_LVOAllocMem(a6)
	move.l	d0,background1(a5)
	bne.s	ChipMemOk
	moveq	#10,d0
	rts

ChipMemOk:
	movem.l	a5-a6,-(sp)
	bsr	START
	movem.l	(sp)+,a5-a6

	move.l	background1(a5),d0
	beq.s	DontFreeChip
	move.l	d0,a1
	move.l	#ChipMemSize,d0
	jsr	_LVOFreeMem(a6)
DontFreeChip:

	moveq	#0,d0
	rts

;StingRay's startup.i will return to the OS for us
	include	"startup.i"

;MAIN is called by startup.i
MAIN:
;Turn disk drives off
	lea	$dff000,a4
	moveq	#0,d0
	move.w	d0,$180(a4)			;COLOR00 to black
	lea	$bfd100,a0
	move.b	#%11111101,(a0)
	moveq	#2,d0
	bsr	WaitLines
	move.b	#%10000111,(a0)			;All drives

	lea	data_area(pc),a5
	bsr	SetupMemory

;Decrunch the Fuji image frames
	lea	animdata(pc),a0			;packed source
	move.l	Images(a5),a1			;dest
	bsr	zx0_decompress

	lea	data_area(pc),a5
	move.l	SysBase(a5),a6
	jsr	_LVOForbid(a6)

	bsr	CalcAudio			;run AmigaKlang generator
	bsr	DrawBackground
	bsr	InsertTitlePic
	bsr	Boink

	move.l	SysBase(a5),a6
	jsr	_LVOPermit(a6)
	rts

SetupMemory:
	move.l	background1(a5),d0
	add.l	#DisplaySize,d0
	move.l	d0,background2(a5)

	add.l	#DisplaySize,d0
	move.l	d0,Images(a5)

	add.l	#AnimLengthUnpacked,d0
	move.l	d0,backstore1(a5)

	add.l	#SaveBufferSize,d0
	move.l	d0,backstore2(a5)

	add.l	#SaveBufferSize,d0
	move.l	d0,SampleBounce(a5)
	rts

Boink:
	lea	$dff000,a4
	moveq	#0,d0
	move.w	d0,$180(a4)
	move.l	d0,$140(a4)

	move.w	d0,RainbowIndex(a5)
	bsr	InitPositions

	move.l	background1(a5),ptr1(a5)
	move.l	background2(a5),ptr2(a5)
	move.l	backstore1(a5),sptr1(a5)
	move.l	backstore2(a5),sptr2(a5)
	move.l	#CopperList1,copptr1(a5)
	move.l	#CopperList2,copptr2(a5)
	bsr	CreateColorCopper		;Prepare rainbow Copper list
	bsr	SetupCopper			;Set bitplane ptrs
	bsr	SwitchPlanes

	moveq	#4,d0
	move.l	copptr1(a5),a1
	bsr	SetTitleColors
	move.l	copptr2(a5),a1
	bsr	SetTitleColors

	move.l	#$2981f1c1,$8e(a4)		;DIWSTRT/DIWSTOP
	move.l	#$003800d0,$92(a4)		;DDFSTRT/DDFSTOP
	move.l	#$42000000,$100(a4)		;BPLCON0/BPLCON1
	move.l	#$00040004,$108(a4)		;BPL1MOD/BPL2MOD
	move.w	d0,$88(a4)			;COPJMP1 (value is random)
	move.w	#$83c0,$96(a4)			;DMACON
MainLoop:
	move.l	4(a4),d0
	and.l	#$1ff00,d0			;Ignore horizontal beam pos
	cmp.l	#$500,d0			;VPOS=5
	bne.s	MainLoop

	bsr	SetSideFlag

	cmp.b	#1,StepFlag(a5)
	beq	.skipclear

	cmp.w	#Frame_ShowFuji,StartDelay(a5)
	bgt.s	.skipfuji

	bsr	RestoreBackground
	bsr	StoreBackground
	bsr	BlitFuji

.skipfuji:
;when to clear the title image
	cmp.w	#Frame_FadeOutStart-4*Frame_FadeOutDelay,StartDelay(a5)
	bne.s	.skipclear
;Clear the ad
	bsr	RemoveTitlePic
	bsr	SetFarSideColor
.skipclear:
;	bsr	SetSideFlag
	bsr	HandleColors

	cmp.b	#1,StepFlag(a5)
	beq	SkipMovement

	tst.w	StartDelay(a5)
	beq.s	.DoSpinMove
	subq.w	#1,StartDelay(a5)
	bne.s	.SkipSpinMove
.DoSpinMove:

	btst	#2,$16(a4)		;no spin when RMB is pressed
	beq.s	.SkipSpinMove
	bsr	MoveFuji
.SkipSpinMove:

SkipMovement:
	and.b	#1,StepFlag(a5)

	bsr	HandleKeyboard
	move.b	KeyCode(a5),d0
	cmp.b	#$50,d0
	bne.s	.skipwait
.waitkey:
	bsr	HandleKeyboard
	cmp.b	#$50+$80,d0
	bne.s	.waitkey
.skipwait:
	move.b	KeyCode(a5),d0
	cmp.b	#$80+$45,d0			;Esc key up
	beq.s	ExitMain

	clr.b	KeyCode(a5)

;Switch bitplanes and also Copper lists
	cmp.b	#3,StepFlag(a5)
	beq.s	.skipswitch
	bsr	SwitchPlanes
.skipswitch:

	bsr	ProcessAudio			;play samples if needed

	btst	#6,$bfe001
	bne	MainLoop

.syncmouse:
	btst	#6,$bfe001
	beq.s	.syncmouse

ExitMain:
	rts

HandleKeyboard:
	btst	#3,$bfed01
	beq.s	.NoKey
	move.b	$bfec01,d0
	not.b	d0
	ror.b	#1,d0
	move.b	d0,KeyCode(a5)

;Handle the keyboard handshake. Wait 3 scanlines.
	or.b	#$40,$bfee01

	moveq	#2,d1
.waitscan:
	move.b	6(a4),d0
.sameline:
	cmp.b	6(a4),d0
	beq.s	.sameline
	dbf	d1,.waitscan

	and.b	#$bf,$bfee01
.NoKey:
	rts

;Sets the side (solid color or rainbow side) depending on image frame number
SetSideFlag:
	move.w	XPos(a5),d0
	and.w	#$1f,d0
	cmp.b	#9,d0
	bne.s	.noswitch
	not.b	SideFlag(a5)
.noswitch:
	rts

MoveFuji:
	moveq	#0,d0			;Indicate no side bounce sound
	btst	#0,MoveFlag(a5)
	beq.s	move_ok

	btst	#1,MoveFlag(a5)
	beq.s	MoveRight
	subq.w	#1,XPos(a5)
	cmp.w	#0,XPos(a5)
	bpl.s	move_ok
	move.w	#0,XPos(a5)
	eor.b	#2,SpinFlag(a5)
	eor.b	#2,MoveFlag(a5)
	moveq	#3,d0				;Indicate bounce left side, channel 3
	bra.s	move_ok
MoveRight:
	addq.w	#1,XPos(a5)
	cmp.w	#114,XPos(a5)
	blt.s	move_ok
	move.w	#114,XPos(a5)
	eor.b	#2,MoveFlag(a5)
	eor.b	#2,SpinFlag(a5)
	moveq	#2,d0				;Indicate bounce right side, channel 2
move_ok:
	tst.b	d0
	beq.s	NoSideBounce

	bsr	PlayBounce

NoSideBounce:
	tst.b	YDirection(a5)
	bne.s	YDecr
	addq.w	#1,YCount(a5)
	cmp.w	#40,YCount(a5)
	bne.s	Yok

	not.b	YDirection(a5)

	moveq	#0,d0				;Play sound on two channels for stereo center
	bsr	PlayBounce
	moveq	#1,d0
	bsr	PlayBounce

	btst	#0,MoveFlag(a5)
	bne.s	Yok
	move.b	#3,MoveFlag(a5)
	move.b	#3,SpinFlag(a5)
	bra.s	Yok
YDecr:
	subq.w	#1,YCount(a5)
	bne.s	Yok
	not.b	YDirection(a5)
Yok:
	move.w	YCount(a5),d0
	move.w	d0,d1
	mulu	d1,d0					;y*y
	mulu	#110,d0
	divu	#1600,d0
	add.w	#13,d0
	move.w	d0,YPos(a5)
	rts

InitPositions:
	moveq	#0,d0
	move.w	#Frame_StartNumber,StartDelay(a5)
	move.b	d0,SpinFlag(a5)
	move.w	d0,YCount(a5)
	move.b	#2,MoveFlag(a5)
	move.b	#$ff,SideFlag(a5)
	move.w	#57,XPos(a5)
	move.w	#13,YPos(a5)
	rts

SwitchPlanes:
	move.l	sptr2(a5),d0
	move.l	sptr1(a5),sptr2(a5)
	move.l	d0,sptr1(a5)

	move.l	oldptr2(a5),d0
	move.l	oldptr1(a5),oldptr2(a5)
	move.l	d0,oldptr1(a5)

	move.l	ptr2(a5),d0
	move.l	ptr1(a5),ptr2(a5)
	move.l	d0,ptr1(a5)

	move.l	copptr1(a5),d0
	move.l	copptr2(a5),copptr1(a5)
	move.l	d0,copptr2(a5)
;Load Copper list for the next frame
	move.l	d0,$80(a4)			;COP1LCH/COP1LCL
	rts

RestoreBackground:
	move.l	oldptr1(a5),d0
	beq.s	restore_skip
	clr.l	oldptr1(a5)
	move.l	sptr1(a5),d1
	WaitBlit
	move.l	#DisplayLineBytes-FujiWidth-2,$64(a4)	;BLTAMOD/BLTDMOD
	move.l	#$09f00000,$40(a4)			;BLTCON0/BLTCON1
	move.l	#$ffffffff,$44(a4)			;BLTAFWM/BLTALWM
	moveq	#2,d2
restore_loop:
	WaitBlit
	move.l	d0,$54(a4)
	move.l	d1,$50(a4)
	move.w	#FujiHeight<<6+(FujiWidth/2)+1,$58(a4)	;92 lines/10 words
	add.l	#BitplaneSize,d0
	add.l	#(FujiWidth+2)*FujiHeight,d1
	dbf	d2,restore_loop
restore_skip:
	rts

StoreBackground:
	moveq	#0,d0
	move.w	YPos(a5),d0
	add.w	#DisplayHeight,d0			;skip first bitplane
	mulu	#DisplayLineBytes,d0
	move.w	XPos(a5),d1
	lsr.w	#5,d1
	lsl.w	#2,d1
	bclr	#0,d1
	add.w	d1,d0
	add.l	ptr1(a5),d0
	and.l	#$fffffffe,d0
	subq.l	#BlitOffset,d0
	move.l	d0,oldptr1(a5)
	move.l	sptr1(a5),d1
	WaitBlit
	move.l	#(DisplayLineBytes-FujiWidth-2)<<16,$64(a4)	;BLTAMOD/BLTDMOD
	move.l	#$09f00000,$40(a4)				;BLTCON0/BLTCON1
	move.l	#$ffffffff,$44(a4)				;BLTAFWM/BLTALWM
	moveq	#2,d2
store_loop:
	WaitBlit
	move.l	d1,$54(a4)
	move.l	d0,$50(a4)
	move.w	#FujiHeight<<6+(FujiWidth/2)+1,$58(a4)	;Height 92, Width 10 words
	add.l	#BitplaneSize,d0
	add.l	#(FujiWidth+2)*FujiHeight,d1
	dbf	d2,store_loop
	rts

BlitFuji:
	move.w	YPos(a5),d0
	add.w	#DisplayHeight,d0			;skip first bitplane
	mulu	#DisplayLineBytes,d0
	moveq	#0,d1
	move.w	XPos(a5),d1
	lsr.w	#2,d1					;was: lsr.w #5
	and.w	#$fff8,d1				;was: lsl.w #3
	add.l	d1,d0
	add.l	ptr1(a5),d0
	and.l	#$fffffffe,d0

	moveq	#0,d1					;Add left offset
	move.w	XPos(a5),d1
	and.w	#$1f,d1
	add.w	d1,d1
	lea	FujiLeft(pc),a0
	move.w	(a0,d1),d1
	add.w	d1,d1
	add.l	d1,d0

	move.w	XPos(a5),d1
	and.w	#$1f,d1					;XPos & $1F = image number
	mulu	#FujiWidth*FujiHeight*3,d1		;bytes per fuji image
	add.l	Images(a5),d1
	WaitBlit
	move.l	#-2<<16+(DisplayLineBytes-FujiWidth-2),$64(a4)	;BLTAMOD/BLTDMOD
	move.l	#$09f00000,$40(a4)			;BLTCON0/1
	move.l	#$ffff0000,$44(a4)			;BLTAFWM/BLTALWM
	move.l	d0,oldptr1(a5)				;for restoring data
	moveq	#2,d7
bf_loop:
	WaitBlit
	move.l	d0,$54(a4)				;BLTDPTx Bitplane (D)
	move.l	d1,$50(a4)				;BLTAPTx Fuji (A)
	move.w	#FujiHeight<<6+(FujiWidth/2)+1,$58(a4)	;BLTSIZE 92 lines/10 words
	add.l	#DisplayLineBytes*DisplayHeight,d0	;Increase display ptr by bytes per plane
	add.l	#FujiWidth*FujiHeight,d1		;Increase image ptr by bytes per plane
	dbf	d7,bf_loop
	rts

;Handler for setting colors of Fuji sides and logo. Also cycles rainbow.
HandleColors:
	tst.w	StartDelay(a5)
	beq.s	.SkipTitleColors
	bsr	HandleTitleColors

.SkipTitleColors:
;Skip setting Fuji front/back colors during the title. Sides are not visible.
	tst.w	StartDelay(a5)
	bne.s	.skipsidecolor

;Set side colors for image index
	move.l	copptr1(a5),a0
	lea	barcolors,a1
	move.w	XPos(a5),d0
	and.w	#$1f,d0
	add.w	d0,d0
	add.w	d0,a1
	move.w	(a1),copper_barside_color(a0)
	move.w	(a1),copper_barside_color+4(a0)

; Copy the side shading colors to the Copper list
	lea	fujicolors,a1
	move.w	XPos(a5),d0
	and.w	#$1f,d0
	mulu	#72*2,d0		;72 lines*1 word
	add.w	d0,a1

	move.l	copptr1(a5),a0
	add.w	#copper_rainbow+$e,a0	;plus offset to COLOR06

	move.w	YPos(a5),d0
	moveq	#$14,d2			;$14 bytes per Copper "line"
	mulu	d2,d0
	add.w	d0,a0
	move.l	a0,a2
	addq.w	#4,a0			;offset to COLOR07
	moveq	#71,d1
.ShadesLoop:
	move.w	(a1),(a0)
	move.w	(a1)+,(a2)
	add.w	d2,a0
	add.w	d2,a2
	dbf	d1,.ShadesLoop
.skipsidecolor:

	tst.b	SideFlag(a5)
	bne	ShowRainbow

; Get the desired front color from the table
	lea	fujicolors,a0
	move.w	XPos(a5),d0
	and.w	#$1f,d0
	add.w	#16,d0
	and.w	#$1f,d0
	add.w	d0,d0
	move.w	2(a0,d0),d2

; Calc offset in copper to top of Fuji and set the color in all lines
	move.l	copptr1(a5),a0
	add.w	#copper_rainbow,a0
	add.w	#6,a0
	move.w	YPos(a5),d0
	mulu	#$14,d0
	add.w	d0,a0
	move.l	a0,a1
	addq.w	#4,a1
	move.w	#71,d1
	moveq	#$14,d0
FillBlue:
	move.w	d2,(a0)
	move.w	d2,(a1)
	add.w	d0,a0
	add.w	d0,a1
	dbf	d1,FillBlue
	rts

ShowRainbow:
	move.w	RainbowIndex(a5),d0
	subq.w	#2,d0
	bpl.s	.notstart
	move.w	#RainbowTableLength-2,d0
.notstart:
	move.w	d0,RainbowIndex(a5)
	and.w	#$fffe,d0

	lea	rainbowcolors(pc),a0
	add.w	d0,a0

	move.w	YPos(a5),d0
	mulu	#$14,d0
	move.l	copptr1(a5),a1
	add.w	#copper_rainbow,a1
	addq.w	#6,a1
	add.w	d0,a1			; Offset in Copper list to Y position of Fuji
	move.w	#71,d1			; lines of rainbow to use
.rb_loop:
	move.w	(a0)+,d0
	bpl.s	.ok
	lea	rainbowcolors(pc),a0
	move.w	(a0)+,d0
.ok:
	move.w	d0,(a1)			;line A
	move.w	d0,4(a1)
	add.w	#$14,a1
	dbf	d1,.rb_loop
	rts

;Do the fade-in / fade-out at the beginning
;Calculates the color entry index from the frame countdown
;Fade-in starts at Frame_FadeInStart, takes 4*Frame_FadeInDelay frames
;Fade-out starts at Frame_FadeOutStart, takes 4*Frame_FadeOutDelay frames
;4 = entries in fade color table
HandleTitleColors:
	move.w	StartDelay(a5),d0
	cmp.w	#Frame_FadeInStart,d0
	bge.s	.NotInFadeIn
	cmp.w	#Frame_FadeInStart-4*Frame_FadeInDelay,d0
	blt.s	.NotInFadeIn
;do fade in
	sub.w	#Frame_FadeInStart-4*Frame_FadeInDelay,d0
	ext.l	d0
	divu.w	#Frame_FadeInDelay,d0			;count from 3 to 0 every x frames

	move.l	copptr1(a5),a1
	bsr	SetTitleColors
	move.l	copptr2(a5),a1
	bsr	SetTitleColors

	rts

.NotInFadeIn:
	cmp.w	#Frame_FadeOutStart,d0
	bgt.s	.NotInFadeOut
	cmp.w	#Frame_FadeOutStart-4*Frame_FadeOutDelay,d0
	ble.s	.NotInFadeOut
;do fade out
	sub.w	#Frame_FadeOutStart-4*Frame_FadeOutDelay,d0
	moveq	#4*Frame_FadeOutDelay,d1
	sub.w	d0,d1
	ext.l	d1
	divu.w	#Frame_FadeInDelay,d1			;count from 1 to 4 every x frames
	addq.w	#1,d1
	move.w	d1,d0
	move.l	copptr1(a5),a1
	bsr	SetTitleColors
	move.l	copptr2(a5),a1
	bsr	SetTitleColors
.NotInFadeOut:
	rts

;Set the Fuji's inner (far) side color for rotation mode after the startup delay
SetFarSideColor:
	move.l	copptr1(a5),a0
	move.w	#shade10,copper_farside_color(a0)
	move.w	#shade10,copper_farside_color+4(a0)

	move.l	copptr2(a5),a0
	move.w	#shade10,copper_farside_color(a0)
	move.w	#shade10,copper_farside_color+4(a0)
	rts

;a1=Copper list base
;d0=index 0..<entries in fade table>
SetTitleColors:
	move.l	d0,d5
	move.l	a1,a3				;for second loop

	mulu	#FadeTableEntrySize,d0		;calc offset into color table
	lea	titlefadecolors(pc),a0
	add.l	d0,a0
	move.w	(a0)+,d6			;get COLOR06
	move.w	(a0)+,d7			;get COLOR07

	add.w	#copper_rainbow+$e,a1		;offset to COLOR06
	move.l	a1,a2
	add.w	#4,a2				;COLOR07
	move.w	#199,d0
	moveq	#$14,d1
.copperloop:
	move.w	d6,(a1)
	move.w	d7,(a2)
	add.l	d1,a1
	add.l	d1,a2
	dbf	d0,.copperloop

	add.w	#copper_barside_color,a3
	moveq	#7,d0				;the remaining 8 colors
.listloop:
	move.w	(a0)+,(a3)
	addq.w	#4,a3
	dbf	d0,.listloop

	move.l	d5,d0
	rts

CreateColorCopper:
	lea	CopperList1,a0
	add.w	#copper_rainbow,a0
	lea	CopperList2,a1
	add.w	#copper_rainbow,a1
	move.l	#$2909fffe,d0			;+$00 Wait VPOS
	move.l	#$0188000f,d1			;+$04 Rainbow to COLOR04
	move.l	#$018a000f,d2			;+$08 Rainbow to COLOR05
	move.l	#$018c000f,d3			;+$0C Side color to COLOR06
	move.l	#$018e000f,d4			;+$10 Side color to COLOR07
	move.l	#$01000000,d6			;increment for vpos
	move.w	#199,d7
.loop:
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	move.l	d2,(a0)+
	move.l	d3,(a0)+
	move.l	d4,(a0)+

	move.l	d0,(a1)+
	move.l	d1,(a1)+
	move.l	d2,(a1)+
	move.l	d3,(a1)+
	move.l	d4,(a1)+

	add.l	d6,d0				;increase VPOS
	dbf	d7,.loop
	rts

;Draw the background checkerboard in both screens
DrawBackground:
	move.l	background1(a5),a0
	bsr	DrawGrid
	move.l	background2(a5),a0
	bsr	DrawGrid
	rts

InsertTitlePic:
	move.l	background1(a5),a0
	bsr	CopyTitlePic
	move.l	background2(a5),a0
	bsr	CopyTitlePic
	rts

RemoveTitlePic:
	move.l	background1(a5),a0
	bsr	ClearTitlePic
	move.l	background2(a5),a0
	bsr	ClearTitlePic
	rts

;Duplicate the copper list for double buffering and initialize the
;bitplane pointers in them.
;Copper list 1 is copied to list 2 so we don't need to have two
;identical copies in the source code.

SetupCopper:
	move.l	copptr1(a5),a0
	move.l	copptr2(a5),a1
	move.w	#CopperLength/4-1,d0
.copy:
	move.l	(a0)+,(a1)+
	dbf	d0,.copy

;Setup bitplane pointers in Copper list 1
	move.l	ptr1(a5),d0
	move.l	copptr1(a5),a0
	add.w	#copper_bplptr,a0
	moveq	#3,d1					;set ptrs of 4 bitplanes
.loop1:
	move.w	d0,4(a0)
	swap	d0
	move.w	d0,(a0)
	swap	d0
	add.l	#DisplayLineBytes*DisplayHeight,d0	;44 bytes*220 lines
	addq.w	#8,a0
	dbf	d1,.loop1

;Setup bitplane pointers in Copper list 2
	move.l	ptr2(a5),d0
	move.l	copptr2(a5),a0
	add.w	#copper_bplptr,a0
	moveq	#3,d1					;set ptrs of 4 bitplanes
.loop2:
	move.w	d0,4(a0)
	swap	d0
	move.w	d0,(a0)
	swap	d0
	add.l	#DisplayLineBytes*DisplayHeight,d0	;44 bytes*220 lines
	addq.w	#8,a0
	dbf	d1,.loop2
	rts

;Play a sample
;d0 - channel 0-3
PlayBounce:
	move.l	SampleBounce(a5),a0
	move.w	#SampleBounceLength/2,d1
	move.w	#BouncePeriod,d2
	moveq	#BounceVolume,d3
	moveq	#1,d4
	bsr.s	PlaySample
	rts

;a0 - sample start
;d0 - channel 0-3
;d1 - length in words
;d2 - period
;d3 - volume
;d4 - length for repeat

PlaySample:
	moveq	#0,d5
	bset	d0,d5					;bit for DMACON
	or.w	d5,dmacon_mask(a5)

;store provided data for later
	lea	snddata(a5),a1
	mulu	#snd_size,d0
	add.w	d0,a1
	move.l	a0,sndptr(a1)				
	move.w	d1,sndlen(a1)			
	move.w	d2,sndper(a1)
	move.w	d3,sndvol(a1)
	move.w	d4,sndlenrep(a1)
	rts

;Set all audio registers to play/re-trigger samples when needed
ProcessAudio:
	move.w	dmacon_mask(a5),d2
	bne.s	.doprocess				;check for set bits
	rts
.doprocess:
	move.w	d2,$96(a4)				;stop DMAs
	or.w	#$8200,d2				;set DMA enable bits

	lea	snddata(a5),a0
	lea	$a0(a4),a1
	moveq	#3,d0
chanloop:
	move.l	sndptr(a0),d1
	beq.s	.noptr
	move.l	d1,(a1)					;AUDxLCH/AUDxLCL
	move.w	sndlen(a0),4(a1)			;AUDxLEN
	move.w	sndper(a0),6(a1)			;AUDxPER
	move.w	sndvol(a0),8(a1)			;AUDxVOL
	clr.l	sndptr(a0)				;clear ptr, mark as processed
.noptr:
	add.w	#snd_size,a0
	add.w	#$10,a1
	dbf	d0,chanloop

	moveq	#5,d0
	bsr.s	WaitLines

	move.w	d2,$96(a4)				;set DMACON (enable DMA)

	moveq	#5,d0
	bsr.s	WaitLines

;now process the length for sample repeat, if applicable
	lea	snddata+sndlenrep(a5),a0		;optimize access without more offsets
	lea	$a0+4(a4),a1
	moveq	#3,d0
lenloop:
	move.w	(a0),d1
	beq.s	.norep
	move.w	d1,(a1)
	clr.w	(a0)					;clear lenrep, mark as processed
.norep:
	add.w	#snd_size,a0
	add.w	#$10,a1
	dbf	d0,lenloop

	clr.w	dmacon_mask(a5)				;processed sound
	rts

;d0 = lines to wait
;trashes d7
WaitLines:
	move.b	6(a4),d7
.sameline:
	cmp.b	6(a4),d7				;Busy wait
	beq.s	.sameline
	dbf	d0,WaitLines
	rts

CalcAudio:
	movem.l	a4/a5,-(sp)
	move.l	SampleBounce(a5),a0
	sub.l	a1,a1
	sub.l	a2,a2
	bsr	AK_Generate
	movem.l	(sp)+,a4/a5
	rts

DrawGrid:
	add.w	#25*DisplayLineBytes+4,a0		;draw in 1st bitplane and skip 25 lines at top
	moveq	#2,d1
	moveq	#8,d3
.checker1:
	moveq	#24,d0
	moveq	#-1,d2
.checker2:
	move.l	d2,(a0)
	add.w	d3,a0
	move.l	d2,(a0)
	add.w	d3,a0
	move.l	d2,(a0)
	add.w	d3,a0
	move.l	d2,(a0)
	add.w	#8+12,a0				;skip 8 bytes at the sides plus 4 bytes for overscan module
	dbf	d0,.checker2

	addq.l	#4,a0					;move checkerboard row to the right

	moveq	#24,d0
.checker3:
	move.l	d2,(a0)
	add.w	d3,a0
	move.l	d2,(a0)
	add.w	d3,a0
	move.l	d2,(a0)
	add.w	d3,a0
	move.l	d2,(a0)
	add.w	#8+12,a0				;skip 8 bytes at the sides plus 4 bytes for overscan module
	dbf	d0,.checker3

	subq.l	#4,a0					;move checkerboard row to the left
	dbf	d1,.checker1
	rts

;Copy the title picture
CopyTitlePic:
	lea	titlepic,a1
	add.w	#105*DisplayLineBytes+10,a0		;105 lines down on bitplane
	moveq	#3,d3
	moveq	#3,d3					;Copy 4 bitplanes
.planeloop:
	move.l	a0,a3
	moveq	#84,d0
.lineloop:
	moveq	#9,d1
.rowloop:
	move.w	(a1)+,(a3)+				;copy one line
	dbf	d1,.rowloop
	add.w	#DisplayLineBytes-20,a3			;skip Amiga bitplane overscan
	dbf	d0,.lineloop
	add.w	#DisplayHeight*DisplayLineBytes,a0	;next bitplane in destination
	dbf	d3,.planeloop
	rts

;Only clear bitplanes 1+2 of the title pic, leaving
;bitplane 0 intact.
ClearTitlePic:
	add.w	#(DisplayHeight+105)*DisplayLineBytes+10,a0	;105 lines down on 2nd bitplane
	moveq	#0,d4
	moveq	#2,d3					;Clear 2 bitplanes
.planeloop:
	move.l	a0,a1
	moveq	#84,d0					;84 lines
.lineloop:
	moveq	#9,d1					;16 bytes
.rowloop:
	move.w	d4,(a1)+
	dbf	d1,.rowloop
	add.w	#DisplayLineBytes-20,a1			;offset to next line
	dbf	d0,.lineloop
	add.w	#DisplayHeight*DisplayLineBytes,a0	;next bitplane
	dbf	d3,.planeloop
	rts

; AmigaKlang generator
; <3 Virgill
	include	"exemusic.asm"

;ZX0 decompressor
	include	"unzx0_68000.S"

	even
data_area:	ds.b	data_sizeof

	even

FujiLeft:
	dc.w	0,0,0,1,1,1,2,2
	dc.w	3,3,3,3,2,2,2,2
	dc.w	2,2,2,2,2,2,2,2
	dc.w	2,2,2,2,3,3,3,3

;color table to fade title screen to red and white...
titlefadecolors:
	dc.w	$eee,$ecc,$0ac,$eaa,$e00,$e00,$e80,$e80,$00a,$00a
	dc.w	$eee,$eaa,$4ac,$e8a,$e44,$e00,$ea4,$e60,$44a,$408
	dc.w	$eee,$e88,$8cc,$e68,$e88,$e00,$ec8,$e40,$88c,$806
	dc.w	$eee,$e44,$cce,$e44,$ecc,$e00,$eec,$e20,$cce,$c04
	dc.w	$eee,$e00,$eee,$e00,$eee,$e00,$eee,$e00,$eee,$e00

	include	"BoinkColors.i"
RainbowTableLength equ *-rainbowcolors
	dc.w	$ffff

titlepic:
	incbin	"data/titlepic.raw"

;Include compressed animation data.
animdata:
	incbin	"data/fujiplanes.raw.zx0"
animdatasize equ *-animdata

	section	chipdata,data_c

;Two copper lists are used for double buffering.
;Copper list 2 will be duplicated in runtime.
CopperList1:
	dc.w	$2709,$fffe
	dc.w	$00e0
copper_bplptr		equ	*-CopperList1
	dc.w	$0000
	dc.w	$00e2,$0000
	dc.w	$00e4,$0000
	dc.w	$00e6,$0000
	dc.w	$00e8,$0000
	dc.w	$00ea,$0000
	dc.w	$00ec,$0000
	dc.w	$00ee,$0000

	dc.w	$0180,$0EEE			;background
	dc.w	$0182,$0E00			;grid
	dc.w	$0184,$0888			;Fuji shadow on background
	dc.w	$0186,$0800			;Fuji shadow on grid
	dc.w	$0190
copper_barside_color	equ	*-CopperList1
	dc.w	$0FF0
	dc.w	$0192,$0F0F
	dc.w	$0194
copper_farside_color	equ	*-CopperList1
	dc.w	$0226
	dc.w	$0196,$0226
	dc.w	$0198,$0F0F
	dc.w	$019A,$0F0F
	dc.w	$019C,$0F0F
	dc.w	$019E,$0F0F

;200 lines of instructions to set Rainbow colors
copper_rainbow		equ	*-CopperList1
	ds.l	200*5

	dc.w	$ffff,$fffe
CopperLength	equ	*-CopperList1

CopperList2:
	ds.l	CopperLength/4
