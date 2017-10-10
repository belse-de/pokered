SoftReset::
	call StopAllSounds
	call GBPalWhiteOut
	ld c, 32
	call DelayFrames
	// fallthrough

Init::
//  Program init.

const uint8_t rLCDC_DEFAULT = 0b11100011;
// * LCD enabled
// * Window tile map at $9C00
// * Window display enabled
// * BG and window tile data at $8800
// * BG tile map at $9800
// * 8x8 OBJ size
// * OBJ display enabled
// * BG display enabled

	di

	a = 0;
	*rIF = 0;
	*rIE = 0;
	*rSCX = 0;
	*rSCY = 0;
	*rSB = 0;
	*rSC = 0;
	*rWX = 0;
	*rWY = 0;
	*rTMA = 0;
  *rTAC = 0;
	*rBGP = 0;
	*rOBP0 = 0;
	*rOBP1 = 0;

	*rLCDC = rLCDC_ENABLE_MASK;
	DisableLCD();

	sp = wStack;

	ld hl, $c000 // start of WRAM
	ld bc, $2000 // size of WRAM
.loop
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop

	ClearVram()

	ld hl, $ff80
	ld bc, $ffff - $ff80
	call FillMemory

	ClearSprites()

	ld a, Bank(WriteDMACodeToHRAM)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call WriteDMACodeToHRAM

	*hTilesetType = 0;
	*rSTAT = 0;
	*hSCX = 0;
	*hSCY = 0;
	*rIF = 0;
	*rIE = 1 << VBLANK + 1 << TIMER + 1 << SERIAL

	ld a, 144 // move the window off-screen
	ld [hWY], a
	ld [rWY], a
	ld a, 7
	ld [rWX], a

	*hSerialConnectionStatus = CONNECTION_NOT_ESTABLISHED

	ld h, vBGMap0 / $100
	call ClearBgMap
	ld h, vBGMap1 / $100
	call ClearBgMap

	ld a, rLCDC_DEFAULT
	ld [rLCDC], a
	ld a, 16
	ld [hSoftReset], a
	call StopAllSounds

	ei

	predef LoadSGB

	ld a, BANK(SFX_Shooting_Star)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, $9c
	ld [H_AUTOBGTRANSFERDEST + 1], a
	xor a
	ld [H_AUTOBGTRANSFERDEST], a
	dec a
	ld [wUpdateSpritesEnabled], a

	predef PlayIntro

	call DisableLCD
	call ClearVram
	call GBPalNormal
	call ClearSprites
	ld a, rLCDC_DEFAULT
	ld [rLCDC], a

	jp SetDefaultNamesBeforeTitlescreen

ClearVram:
	ld hl, $8000
	ld bc, $2000
	xor a
	jp FillMemory


StopAllSounds::
	ld a, BANK(Audio1_UpdateMusic)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	xor a
	ld [wAudioFadeOutControl], a
	ld [wNewSoundID], a
	ld [wLastMusicSoundID], a
	dec a
	jp PlaySound
