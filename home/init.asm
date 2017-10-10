void SoftReset(){
	StopAllSounds();
	GBPalWhiteOut();
	DelayFrames(32);
	// fallthrough
	Init();
}

void Init(){
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

	disableInterrupt();

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

	ClearVram();

	ld hl, $ff80
	ld bc, $ffff - $ff80
	FillMemory(hl, bc, a);

	ClearSprites();

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

	// move the window off-screen
	*rWY = *hWY = 144;
	*rWX = 7;

	*hSerialConnectionStatus = CONNECTION_NOT_ESTABLISHED

	ClearBgMap(vBGMap0 / 0x100);
	ClearBgMap(vBGMap1 / 0x100);

	*rLCDC = rLCDC_DEFAULT;
	*hSoftReset = 16;
	StopAllSounds();

	enableInterrupt();
  
  // SuperGameBoy Feature 
	predef LoadSGB

	ld a, BANK(SFX_Shooting_Star)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a

	H_AUTOBGTRANSFERDEST[1] = 0x9C;
	*H_AUTOBGTRANSFERDEST = 0;
	*wUpdateSpritesEnabled = 0xFF;

	predef PlayIntro

	DisableLCD();
	ClearVram();
	GBPalNormal();
	ClearSprites();
	*rLCDC = rLCDC_DEFAULT;

	jp SetDefaultNamesBeforeTitlescreen
}

void ClearVram(){
	ld hl, $8000
	ld bc, $2000
	xor a
	FillMemory(hl, bc, a);
}


void StopAllSounds(){
	ld a, BANK(Audio1_UpdateMusic)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	xor a
	ld [wAudioFadeOutControl], a
	ld [wNewSoundID], a
	ld [wLastMusicSoundID], a
	dec a
	jp PlaySound
}
