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

  uint8_t* wramStart = 0xc000; // start of WRAM
  uint16_t wramSize  = 0x2000; // size of WRAM
  for(;wramSize>0;wramSize--){
    *wramStart++ = 0;
  }

	ClearVram();

	FillMemory(0xff80, 0xffff - 0xff80, 0);

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
	FillMemory(0x8000, 0x2000, 0);
}


void StopAllSounds(){
	ld a, BANK(Audio1_UpdateMusic)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a

	*wAudioFadeOutControl = 0;
	*wNewSoundID = 0;
	*wLastMusicSoundID = 0;
	dec a
	jp PlaySound
}
