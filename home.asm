
// The rst vectors are unused.
SECTION "rst 00", ROM0 [$00]
	rst $38
SECTION "rst 08", ROM0 [$08]
	rst $38
SECTION "rst 10", ROM0 [$10]
	rst $38
SECTION "rst 18", ROM0 [$18]
	rst $38
SECTION "rst 20", ROM0 [$20]
	rst $38
SECTION "rst 28", ROM0 [$28]
	rst $38
SECTION "rst 30", ROM0 [$30]
	rst $38
SECTION "rst 38", ROM0 [$38]
	rst $38

// Hardware interrupts
SECTION "vblank", ROM0 [$40]
	jp VBlank
SECTION "hblank", ROM0 [$48]
	rst $38
SECTION "timer",  ROM0 [$50]
	jp Timer
SECTION "serial", ROM0 [$58]
	jp Serial
SECTION "joypad", ROM0 [$60]
	reti


SECTION "Home", ROM0

void DisableLCD(){
}

void EnableLCD(){
}

void ClearSprites(){
  const uint8_t wOAMBuffer_size = 40 * 4;
  for(uint8_t i=0; i<wOAMBuffer_size; i++) wOAMBuffer[i] = 0;
}

void HideSprites(){
  const uint8_t wOAMBuffer_size = 40 * 4;
  for(uint8_t i=0; i<wOAMBuffer_size; i+=4) wOAMBuffer[i] = 160;
}

#include "home/copy.asm"

SECTION "Main", ROM0

void Start(){
	// check if we are running on GBC
	Init();
}

#include "home/joypad.asm"
#include "data/map_header_pointers.asm"
#include "home/overworld.asm"

void CheckForUserInterruption()
// Return carry if Up+Select+B, Start or A are pressed in c frames.
// Used only in the intro and title screen.
	call DelayFrame

	push bc
	call JoypadLowSensitivity
	pop bc

	ld a, [hJoyHeld]
	cp D_UP + SELECT + B_BUTTON
	jr z, .input

	ld a, [hJoy5]
	and START | A_BUTTON
	jr nz, .input

	dec c
	jr nz, CheckForUserInterruption

	and a
	ret

.input
	scf
	ret

// function to load position data for destination warp when switching maps
// INPUT:
// a = ID of destination warp within destination map
LoadDestinationWarpPosition::
	ld b,a
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[wPredefParentBank]
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ld a,b
	add a
	add a
	ld c,a
	ld b,0
	add hl,bc
	ld bc,4
	ld de,wCurrentTileBlockMapViewPointer
	call CopyData
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret


DrawHPBar::
// Draw an HP bar d tiles long, and fill it to e pixels.
// If c is nonzero, show at least a sliver regardless.
// The right end of the bar changes with [wHPBarType].

	push hl
	push de
	push bc

	// Left
	ld a, $71 // "HP:"
	ld [hli], a
	ld a, $62
	ld [hli], a

	push hl

	// Middle
	ld a, $63 // empty
.draw
	ld [hli],a
	dec d
	jr nz, .draw

	// Right
	ld a,[wHPBarType]
	dec a
	ld a, $6d // status screen and battle
	jr z, .ok
	dec a // pokemon menu
.ok
	ld [hl],a

	pop hl

	ld a, e
	and a
	jr nz, .fill

	// If c is nonzero, draw a pixel anyway.
	ld a, c
	and a
	jr z, .done
	ld e, 1

.fill
	ld a, e
	sub 8
	jr c, .partial
	ld e, a
	ld a, $6b // full
	ld [hli], a
	ld a, e
	and a
	jr z, .done
	jr .fill

.partial
	// Fill remaining pixels at the end if necessary.
	ld a, $63 // empty
	add e
	ld [hl], a
.done
	pop bc
	pop de
	pop hl
	ret


// loads pokemon data from one of multiple sources to wLoadedMon
// loads base stats to wMonHeader
// INPUT:
// [wWhichPokemon] = index of pokemon within party/box
// [wMonDataLocation] = source
// 00: player's party
// 01: enemy's party
// 02: current box
// 03: daycare
// OUTPUT:
// [wcf91] = pokemon ID
// wLoadedMon = base address of pokemon data
// wMonHeader = base address of base stats
LoadMonData::
	jpab LoadMonData_

OverwritewMoves::
// Write c to [wMoves + b]. Unused.
	ld hl, wMoves
	ld e, b
	ld d, 0
	add hl, de
	ld a, c
	ld [hl], a
	ret

LoadFlippedFrontSpriteByMonIndex::
	ld a, 1
	ld [wSpriteFlipped], a

LoadFrontSpriteByMonIndex::
	push hl
	ld a, [wd11e]
	push af
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
	ld hl, wd11e
	ld a, [hl]
	pop bc
	ld [hl], b
	and a
	pop hl
	jr z, .invalidDexNumber // dex #0 invalid
	cp NUM_POKEMON + 1
	jr c, .validDexNumber   // dex >#151 invalid
.invalidDexNumber
	ld a, RHYDON // $1
	ld [wcf91], a
	ret
.validDexNumber
	push hl
	ld de, vFrontPic
	call LoadMonFrontSprite
	pop hl
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, Bank(CopyUncompressedPicToHL)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	xor a
	ld [hStartTileID], a
	call CopyUncompressedPicToHL
	xor a
	ld [wSpriteFlipped], a
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret


PlayCry::
// Play monster a's cry.
	call GetCryData
	PlaySound(a);
	jp WaitForSoundToFinish

GetCryData::
// Load cry data for monster a.
	dec a
	ld c, a
	ld b, 0
	ld hl, CryData
	add hl, bc
	add hl, bc
	add hl, bc

	ld a, BANK(CryData)
	call BankswitchHome
	ld a, [hli]
	ld b, a // cry id
	ld a, [hli]
	ld [wFrequencyModifier], a
	ld a, [hl]
	ld [wTempoModifier], a
	call BankswitchBack

	// Cry headers have 3 channels,
	// and start from index $14,
	// so add 3 times the cry id.
	ld a, b
	ld c, $14
	rlca // * 2
	add b
	add c
	ret

DisplayPartyMenu::
	ld a,[hTilesetType]
	push af
	xor a
	ld [hTilesetType],a
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	call PartyMenuInit
	call DrawPartyMenu
	jp HandlePartyMenuInput

GoBackToPartyMenu::
	ld a,[hTilesetType]
	push af
	xor a
	ld [hTilesetType],a
	call PartyMenuInit
	call RedrawPartyMenu
	jp HandlePartyMenuInput

PartyMenuInit::
	ld a, 1 // hardcoded bank
	call BankswitchHome
	call LoadHpBarAndStatusTilePatterns
	ld hl, wd730
	set 6, [hl] // turn off letter printing delay
	xor a // PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld [wMenuWatchMovingOutOfBounds], a
	ld hl, wTopMenuItemY
	inc a
	ld [hli], a // top menu item Y
	xor a
	ld [hli], a // top menu item X
	ld a, [wPartyAndBillsPCSavedMenuItem]
	push af
	ld [hli], a // current menu item ID
	inc hl
	ld a, [wPartyCount]
	and a // are there more than 0 pokemon in the party?
	jr z, .storeMaxMenuItemID
	dec a
// if party is not empty, the max menu item ID is ([wPartyCount] - 1)
// otherwise, it is 0
.storeMaxMenuItemID
	ld [hli], a // max menu item ID
	ld a, [wForcePlayerToChooseMon]
	and a
	ld a, A_BUTTON | B_BUTTON
	jr z, .next
	xor a
	ld [wForcePlayerToChooseMon], a
	inc a // a = A_BUTTON
.next
	ld [hli], a // menu watched keys
	pop af
	ld [hl], a // old menu item ID
	ret

HandlePartyMenuInput::
	ld a,1
	ld [wMenuWrappingEnabled],a
	ld a,$40
	ld [wPartyMenuAnimMonEnabled],a
	call HandleMenuInput_
	call PlaceUnfilledArrowMenuCursor
	ld b,a
	xor a
	ld [wPartyMenuAnimMonEnabled],a
	ld a,[wCurrentMenuItem]
	ld [wPartyAndBillsPCSavedMenuItem],a
	ld hl,wd730
	res 6,[hl] // turn on letter printing delay
	ld a,[wMenuItemToSwap]
	and a
	jp nz,.swappingPokemon
	pop af
	ld [hTilesetType],a
	bit 1,b
	jr nz,.noPokemonChosen
	ld a,[wPartyCount]
	and a
	jr z,.noPokemonChosen
	ld a,[wCurrentMenuItem]
	ld [wWhichPokemon],a
	ld hl,wPartySpecies
	ld b,0
	ld c,a
	add hl,bc
	ld a,[hl]
	ld [wcf91],a
	ld [wBattleMonSpecies2],a
	call BankswitchBack
	and a
	ret
.noPokemonChosen
	call BankswitchBack
	scf
	ret
.swappingPokemon
	bit 1,b // was the B button pressed?
	jr z,.handleSwap // if not, handle swapping the pokemon
.cancelSwap // if the B button was pressed
	callba ErasePartyMenuCursors
	xor a
	ld [wMenuItemToSwap],a
	ld [wPartyMenuTypeOrMessageID],a
	call RedrawPartyMenu
	jr HandlePartyMenuInput
.handleSwap
	ld a,[wCurrentMenuItem]
	ld [wWhichPokemon],a
	callba SwitchPartyMon
	jr HandlePartyMenuInput

DrawPartyMenu::
	ld hl, DrawPartyMenu_
	jr DrawPartyMenuCommon

RedrawPartyMenu::
	ld hl, RedrawPartyMenu_

DrawPartyMenuCommon::
	ld b, BANK(RedrawPartyMenu_)
	jp Bankswitch

// prints a pokemon's status condition
// INPUT:
// de = address of status condition
// hl = destination address
PrintStatusCondition::
	push de
	dec de
	dec de // de = address of current HP
	ld a,[de]
	ld b,a
	dec de
	ld a,[de]
	or b // is the pokemon's HP zero?
	pop de
	jr nz,PrintStatusConditionNotFainted
// if the pokemon's HP is 0, print "FNT"
	ld a,"F"
	ld [hli],a
	ld a,"N"
	ld [hli],a
	ld [hl],"T"
	and a
	ret

PrintStatusConditionNotFainted:
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,BANK(PrintStatusAilment)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call PrintStatusAilment // print status condition
	pop bc
	ld a,b
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// function to print pokemon level, leaving off the ":L" if the level is at least 100
// INPUT:
// hl = destination address
// [wLoadedMonLevel] = level
PrintLevel::
	ld a,$6e // ":L" tile ID
	ld [hli],a
	ld c,2 // number of digits
	ld a,[wLoadedMonLevel] // level
	cp 100
	jr c,PrintLevelCommon
// if level at least 100, write over the ":L" tile
	dec hl
	inc c // increment number of digits to 3
	jr PrintLevelCommon

// prints the level without leaving off ":L" regardless of level
// INPUT:
// hl = destination address
// [wLoadedMonLevel] = level
PrintLevelFull::
	ld a,$6e // ":L" tile ID
	ld [hli],a
	ld c,3 // number of digits
	ld a,[wLoadedMonLevel] // level

PrintLevelCommon::
	ld [wd11e],a
	ld de,wd11e
	ld b,LEFT_ALIGN | 1 // 1 byte
	jp PrintNumber

GetwMoves::
// Unused. Returns the move at index a from wMoves in a
	ld hl,wMoves
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hl]
	ret

// copies the base stat data of a pokemon to wMonHeader
// INPUT:
// [wd0b5] = pokemon ID
GetMonHeader::
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,BANK(BaseStats)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	push bc
	push de
	push hl
	ld a,[wd11e]
	push af
	ld a,[wd0b5]
	ld [wd11e],a
	ld de,FossilKabutopsPic
	ld b,$66 // size of Kabutops fossil and Ghost sprites
	cp FOSSIL_KABUTOPS // Kabutops fossil
	jr z,.specialID
	ld de,GhostPic
	cp MON_GHOST // Ghost
	jr z,.specialID
	ld de,FossilAerodactylPic
	ld b,$77 // size of Aerodactyl fossil sprite
	cp FOSSIL_AERODACTYL // Aerodactyl fossil
	jr z,.specialID
	cp a,MEW
	jr z,.mew
	predef IndexToPokedex   // convert pokemon ID in [wd11e] to pokedex number
	ld a,[wd11e]
	dec a
	ld bc, MonBaseStatsEnd - MonBaseStats
	ld hl,BaseStats
	call AddNTimes
	ld de,wMonHeader
	ld bc, MonBaseStatsEnd - MonBaseStats
	call CopyData
	jr .done
.specialID
	ld hl,wMonHSpriteDim
	ld [hl],b // write sprite dimensions
	inc hl
	ld [hl],e // write front sprite pointer
	inc hl
	ld [hl],d
	jr .done
.mew
	ld hl,MewBaseStats
	ld de,wMonHeader
	ld bc,MonBaseStatsEnd - MonBaseStats
	ld a,BANK(MewBaseStats)
	call FarCopyData
.done
	ld a,[wd0b5]
	ld [wMonHIndex],a
	pop af
	ld [wd11e],a
	pop hl
	pop de
	pop bc
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// copy party pokemon's name to wcd6d
GetPartyMonName2::
	ld a,[wWhichPokemon] // index within party
	ld hl,wPartyMonNicks

// this is called more often
GetPartyMonName::
	push hl
	push bc
	call SkipFixedLengthTextEntries // add NAME_LENGTH to hl, a times
	ld de,wcd6d
	push de
	ld bc,NAME_LENGTH
	call CopyData
	pop de
	pop bc
	pop hl
	ret

// function to print a BCD (Binary-coded decimal) number
// de = address of BCD number
// hl = destination address
// c = flags and length
// bit 7: if set, do not print leading zeroes
//        if unset, print leading zeroes
// bit 6: if set, left-align the string (do not pad empty digits with spaces)
//        if unset, right-align the string
// bit 5: if set, print currency symbol at the beginning of the string
//        if unset, do not print the currency symbol
// bits 0-4: length of BCD number in bytes
// Note that bits 5 and 7 are modified during execution. The above reflects
// their meaning at the beginning of the functions's execution.
PrintBCDNumber::
	ld b,c // save flags in b
	res 7,c
	res 6,c
	res 5,c // c now holds the length
	bit 5,b
	jr z,.loop
	bit 7,b
	jr nz,.loop
	ld [hl],"¥"
	inc hl
.loop
	ld a,[de]
	swap a
	call PrintBCDDigit // print upper digit
	ld a,[de]
	call PrintBCDDigit // print lower digit
	inc de
	dec c
	jr nz,.loop
	bit 7,b // were any non-zero digits printed?
	jr z,.done // if so, we are done
.numberEqualsZero // if every digit of the BCD number is zero
	bit 6,b // left or right alignment?
	jr nz,.skipRightAlignmentAdjustment
	dec hl // if the string is right-aligned, it needs to be moved back one space
.skipRightAlignmentAdjustment
	bit 5,b
	jr z,.skipCurrencySymbol
	ld [hl],"¥"
	inc hl
.skipCurrencySymbol
	ld [hl],"0"
	call PrintLetterDelay
	inc hl
.done
	ret

PrintBCDDigit::
	and $f
	and a
	jr z,.zeroDigit
.nonzeroDigit
	bit 7,b // have any non-space characters been printed?
	jr z,.outputDigit
// if bit 7 is set, then no numbers have been printed yet
	bit 5,b // print the currency symbol?
	jr z,.skipCurrencySymbol
	ld [hl],"¥"
	inc hl
	res 5,b
.skipCurrencySymbol
	res 7,b // unset 7 to indicate that a nonzero digit has been reached
.outputDigit
	add "0"
	ld [hli],a
	jp PrintLetterDelay
.zeroDigit
	bit 7,b // either printing leading zeroes or already reached a nonzero digit?
	jr z,.outputDigit // if so, print a zero digit
	bit 6,b // left or right alignment?
	ret nz
	inc hl // if right-aligned, "print" a space by advancing the pointer
	ret

// uncompresses the front or back sprite of the specified mon
// assumes the corresponding mon header is already loaded
// hl contains offset to sprite pointer ($b for front or $d for back)
UncompressMonSprite::
	ld bc,wMonHeader
	add hl,bc
	ld a,[hli]
	ld [wSpriteInputPtr],a    // fetch sprite input pointer
	ld a,[hl]
	ld [wSpriteInputPtr+1],a
// define (by index number) the bank that a pokemon's image is in
// index = Mew, bank 1
// index = Kabutops fossil, bank $B
// index < $1F, bank 9
// $1F ≤ index < $4A, bank $A
// $4A ≤ index < $74, bank $B
// $74 ≤ index < $99, bank $C
// $99 ≤ index,       bank $D
	ld a,[wcf91] // XXX name for this ram location
	ld b,a
	cp MEW
	ld a,BANK(MewPicFront)
	jr z,.GotBank
	ld a,b
	cp FOSSIL_KABUTOPS
	ld a,BANK(FossilKabutopsPic)
	jr z,.GotBank
	ld a,b
	cp TANGELA + 1
	ld a,BANK(TangelaPicFront)
	jr c,.GotBank
	ld a,b
	cp MOLTRES + 1
	ld a,BANK(MoltresPicFront)
	jr c,.GotBank
	ld a,b
	cp BEEDRILL + 2
	ld a,BANK(BeedrillPicFront)
	jr c,.GotBank
	ld a,b
	cp STARMIE + 1
	ld a,BANK(StarmiePicFront)
	jr c,.GotBank
	ld a,BANK(VictreebelPicFront)
.GotBank
	jp UncompressSpriteData

// de: destination location
LoadMonFrontSprite::
	push de
	ld hl, wMonHFrontSprite - wMonHeader
	call UncompressMonSprite
	ld hl, wMonHSpriteDim
	ld a, [hli]
	ld c, a
	pop de
	// fall through

// postprocesses uncompressed sprite chunks to a 2bpp sprite and loads it into video ram
// calculates alignment parameters to place both sprite chunks in the center of the 7*7 tile sprite buffers
// de: destination location
// a,c:  sprite dimensions (in tiles of 8x8 each)
LoadUncompressedSpriteData::
	push de
	and $f
	ld [H_SPRITEWIDTH], a // each byte contains 8 pixels (in 1bpp), so tiles=bytes for width
	ld b, a
	ld a, $7
	sub b      // 7-w
	inc a      // 8-w
	srl a      // (8-w)/2     // horizontal center (in tiles, rounded up)
	ld b, a
	add a
	add a
	add a
	sub b      // 7*((8-w)/2) // skip for horizontal center (in tiles)
	ld [H_SPRITEOFFSET], a
	ld a, c
	swap a
	and $f
	ld b, a
	add a
	add a
	add a     // 8*tiles is height in bytes
	ld [H_SPRITEHEIGHT], a
	ld a, $7
	sub b      // 7-h         // skip for vertical center (in tiles, relative to current column)
	ld b, a
	ld a, [H_SPRITEOFFSET]
	add b     // 7*((8-w)/2) + 7-h // combined overall offset (in tiles)
	add a
	add a
	add a     // 8*(7*((8-w)/2) + 7-h) // combined overall offset (in bytes)
	ld [H_SPRITEOFFSET], a
	xor a
	ld [$4000], a
	ld hl, sSpriteBuffer0
	call ZeroSpriteBuffer   // zero buffer 0
	ld de, sSpriteBuffer1
	ld hl, sSpriteBuffer0
	call AlignSpriteDataCentered    // copy and align buffer 1 to 0 (containing the MSB of the 2bpp sprite)
	ld hl, sSpriteBuffer1
	call ZeroSpriteBuffer   // zero buffer 1
	ld de, sSpriteBuffer2
	ld hl, sSpriteBuffer1
	call AlignSpriteDataCentered    // copy and align buffer 2 to 1 (containing the LSB of the 2bpp sprite)
	pop de
	jp InterlaceMergeSpriteBuffers

// copies and aligns the sprite data properly inside the sprite buffer
// sprite buffers are 7*7 tiles in size, the loaded sprite is centered within this area
AlignSpriteDataCentered::
	ld a, [H_SPRITEOFFSET]
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [H_SPRITEWIDTH]
.columnLoop
	push af
	push hl
	ld a, [H_SPRITEHEIGHT]
	ld c, a
.columnInnerLoop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .columnInnerLoop
	pop hl
	ld bc, 7*8    // 7 tiles
	add hl, bc    // advance one full column
	pop af
	dec a
	jr nz, .columnLoop
	ret

// fills the sprite buffer (pointed to in hl) with zeros
ZeroSpriteBuffer::
	ld bc, SPRITEBUFFERSIZE
.nextByteLoop
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .nextByteLoop
	ret

// combines the (7*7 tiles, 1bpp) sprite chunks in buffer 0 and 1 into a 2bpp sprite located in buffer 1 through 2
// in the resulting sprite, the rows of the two source sprites are interlaced
// de: output address
InterlaceMergeSpriteBuffers::
	xor a
	ld [$4000], a
	push de
	ld hl, sSpriteBuffer2 + (SPRITEBUFFERSIZE - 1) // destination: end of buffer 2
	ld de, sSpriteBuffer1 + (SPRITEBUFFERSIZE - 1) // source 2: end of buffer 1
	ld bc, sSpriteBuffer0 + (SPRITEBUFFERSIZE - 1) // source 1: end of buffer 0
	ld a, SPRITEBUFFERSIZE/2 // $c4
	ld [H_SPRITEINTERLACECOUNTER], a
.interlaceLoop
	ld a, [de]
	dec de
	ld [hld], a   // write byte of source 2
	ld a, [bc]
	dec bc
	ld [hld], a   // write byte of source 1
	ld a, [de]
	dec de
	ld [hld], a   // write byte of source 2
	ld a, [bc]
	dec bc
	ld [hld], a   // write byte of source 1
	ld a, [H_SPRITEINTERLACECOUNTER]
	dec a
	ld [H_SPRITEINTERLACECOUNTER], a
	jr nz, .interlaceLoop
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped
	ld bc, 2*SPRITEBUFFERSIZE
	ld hl, sSpriteBuffer1
.swapLoop
	swap [hl]    // if flipped swap nybbles in all bytes
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .swapLoop
.notFlipped
	pop hl
	ld de, sSpriteBuffer1
	ld c, (2*SPRITEBUFFERSIZE)/16 // $31, number of 16 byte chunks to be copied
	ld a, [H_LOADEDROMBANK]
	ld b, a
	jp CopyVideoData


#include "data/collision.asm"
#include "home/copy2.asm"
#include "home/text.asm"
#include "home/vcopy.asm"
#include "home/init.asm"
#include "home/vblank.asm"
#include "home/fade.asm"
#include "home/serial.asm"
#include "home/timer.asm"
#include "home/audio.asm"


UpdateSprites::
	ld a, [wUpdateSpritesEnabled]
	dec a
	ret nz
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, Bank(_UpdateSprites)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call _UpdateSprites
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

#include "data/mart_inventories.asm"

TextScriptEndingChar::
	db "@"
TextScriptEnd::
	ld hl,TextScriptEndingChar
	ret

ExclamationText::
	TX_FAR _ExclamationText
	db "@"

GroundRoseText::
	TX_FAR _GroundRoseText
	db "@"

BoulderText::
	TX_FAR _BoulderText
	db "@"

MartSignText::
	TX_FAR _MartSignText
	db "@"

PokeCenterSignText::
	TX_FAR _PokeCenterSignText
	db "@"

PickUpItemText::
	TX_ASM
	predef PickUpItem
	jp TextScriptEnd


#include "home/pic.asm"


ResetPlayerSpriteData::
	ld hl, wSpriteStateData1
	call ResetPlayerSpriteData_ClearSpriteData
	ld hl, wSpriteStateData2
	call ResetPlayerSpriteData_ClearSpriteData
	ld a, $1
	ld [wSpriteStateData1], a
	ld [wSpriteStateData2 + $0e], a
	ld hl, wSpriteStateData1 + 4
	ld [hl], $3c     // set Y screen pos
	inc hl
	inc hl
	ld [hl], $40     // set X screen pos
	ret

// overwrites sprite data with zeroes
ResetPlayerSpriteData_ClearSpriteData::
	ld bc, $10
	xor a
	FillMemory(hl, bc, a);

FadeOutAudio::
	ld a, [wAudioFadeOutControl]
	and a // currently fading out audio?
	jr nz, .fadingOut
	ld a, [wd72c]
	bit 1, a
	ret nz
	ld a, $77
	ld [rNR50], a
	ret
.fadingOut
	ld a, [wAudioFadeOutCounter]
	and a
	jr z, .counterReachedZero
	dec a
	ld [wAudioFadeOutCounter], a
	ret
.counterReachedZero
	ld a, [wAudioFadeOutCounterReloadValue]
	ld [wAudioFadeOutCounter], a
	ld a, [rNR50]
	and a // has the volume reached 0?
	jr z, .fadeOutComplete
	ld b, a
	and $f
	dec a
	ld c, a
	ld a, b
	and $f0
	swap a
	dec a
	swap a
	or c
	ld [rNR50], a
	ret
.fadeOutComplete
	ld a, [wAudioFadeOutControl]
	ld b, a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, $ff
	ld [wNewSoundID], a
	PlaySound(a);
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, b
	ld [wNewSoundID], a
	PlaySound(a);

// this function is used to display sign messages, sprite dialog, etc.
// INPUT: [hSpriteIndexOrTextID] = sprite ID or text ID
DisplayTextID::
	ld a,[H_LOADEDROMBANK]
	push af
	callba DisplayTextIDInit // initialization
	ld hl,wTextPredefFlag
	bit 0,[hl]
	res 0,[hl]
	jr nz,.skipSwitchToMapBank
	ld a,[wCurMap]
	call SwitchToMapRomBank
.skipSwitchToMapBank
	ld a,30 // half a second
	ld [H_FRAMECOUNTER],a // used as joypad poll timer
	ld hl,wMapTextPtr
	ld a,[hli]
	ld h,[hl]
	ld l,a // hl = map text pointer
	ld d,$00
	ld a,[hSpriteIndexOrTextID] // text ID
	ld [wSpriteIndex],a
	and a
	jp z,DisplayStartMenu
	cp TEXT_SAFARI_GAME_OVER
	jp z,DisplaySafariGameOverText
	cp TEXT_MON_FAINTED
	jp z,DisplayPokemonFaintedText
	cp TEXT_BLACKED_OUT
	jp z,DisplayPlayerBlackedOutText
	cp TEXT_REPEL_WORE_OFF
	jp z,DisplayRepelWoreOffText
	ld a,[wNumSprites]
	ld e,a
	ld a,[hSpriteIndexOrTextID] // sprite ID
	cp e
	jr z,.spriteHandling
	jr nc,.skipSpriteHandling
.spriteHandling
// get the text ID of the sprite
	push hl
	push de
	push bc
	callba UpdateSpriteFacingOffsetAndDelayMovement // update the graphics of the sprite the player is talking to (to face the right direction)
	pop bc
	pop de
	ld hl,wMapSpriteData // NPC text entries
	ld a,[hSpriteIndexOrTextID]
	dec a
	add a
	add l
	ld l,a
	jr nc,.noCarry
	inc h
.noCarry
	inc hl
	ld a,[hl] // a = text ID of the sprite
	pop hl
.skipSpriteHandling
// look up the address of the text in the map's text entries
	dec a
	ld e,a
	sla e
	add hl,de
	ld a,[hli]
	ld h,[hl]
	ld l,a // hl = address of the text
	ld a,[hl] // a = first byte of text
// check first byte of text for special cases
	cp $fe   // Pokemart NPC
	jp z,DisplayPokemartDialogue
	cp $ff   // Pokemon Center NPC
	jp z,DisplayPokemonCenterDialogue
	cp $fc   // Item Storage PC
	jp z,FuncTX_ItemStoragePC
	cp $fd   // Bill's PC
	jp z,FuncTX_BillsPC
	cp $f9   // Pokemon Center PC
	jp z,FuncTX_PokemonCenterPC
	cp $f5   // Vending Machine
	jr nz,.notVendingMachine
	callba VendingMachineMenu // jump banks to vending machine routine
	jr AfterDisplayingTextID
.notVendingMachine
	cp $f7   // prize menu
	jp z, FuncTX_GameCornerPrizeMenu
	cp $f6   // cable connection NPC in Pokemon Center
	jr nz,.notSpecialCase
	callab CableClubNPC
	jr AfterDisplayingTextID
.notSpecialCase
	call PrintText_NoCreatingTextBox // display the text
	ld a,[wDoNotWaitForButtonPressAfterDisplayingText]
	and a
	jr nz,HoldTextDisplayOpen

AfterDisplayingTextID::
	ld a,[wEnteringCableClub]
	and a
	jr nz,HoldTextDisplayOpen
	call WaitForTextScrollButtonPress // wait for a button press after displaying all the text

// loop to hold the dialogue box open as long as the player keeps holding down the A button
HoldTextDisplayOpen::
	call Joypad
	ld a,[hJoyHeld]
	bit 0,a // is the A button being pressed?
	jr nz,HoldTextDisplayOpen

CloseTextDisplay::
	ld a,[wCurMap]
	call SwitchToMapRomBank
	ld a,$90
	ld [hWY],a // move the window off the screen
	call DelayFrame
	call LoadGBPal
	xor a
	ld [H_AUTOBGTRANSFERENABLED],a // disable continuous WRAM to VRAM transfer each V-blank
// loop to make sprites face the directions they originally faced before the dialogue
	ld hl,wSpriteStateData2 + $19
	ld c,$0f
	ld de,$0010
.restoreSpriteFacingDirectionLoop
	ld a,[hl]
	dec h
	ld [hl],a
	inc h
	add hl,de
	dec c
	jr nz,.restoreSpriteFacingDirectionLoop
	ld a,BANK(InitMapSprites)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call InitMapSprites // reload sprite tile pattern data (since it was partially overwritten by text tile patterns)
	ld hl,wFontLoaded
	res 0,[hl]
	ld a,[wd732]
	bit 3,a // used fly warp
	call z,LoadPlayerSpriteGraphics
	call LoadCurrentMapView
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	jp UpdateSprites

DisplayPokemartDialogue::
	push hl
	ld hl,PokemartGreetingText
	call PrintText
	pop hl
	inc hl
	call LoadItemList
	ld a,PRICEDITEMLISTMENU
	ld [wListMenuID],a
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,Bank(DisplayPokemartDialogue_)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call DisplayPokemartDialogue_
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	jp AfterDisplayingTextID

PokemartGreetingText::
	TX_FAR _PokemartGreetingText
	db "@"

LoadItemList::
	ld a,1
	ld [wUpdateSpritesEnabled],a
	ld a,h
	ld [wItemListPointer],a
	ld a,l
	ld [wItemListPointer + 1],a
	ld de,wItemList
.loop
	ld a,[hli]
	ld [de],a
	inc de
	cp $ff
	jr nz,.loop
	ret

DisplayPokemonCenterDialogue::
// zeroing these doesn't appear to serve any purpose
	xor a
	ld [$ff8b],a
	ld [$ff8c],a
	ld [$ff8d],a

	inc hl
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,Bank(DisplayPokemonCenterDialogue_)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call DisplayPokemonCenterDialogue_
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	jp AfterDisplayingTextID

DisplaySafariGameOverText::
	callab PrintSafariGameOverText
	jp AfterDisplayingTextID

DisplayPokemonFaintedText::
	ld hl,PokemonFaintedText
	call PrintText
	jp AfterDisplayingTextID

PokemonFaintedText::
	TX_FAR _PokemonFaintedText
	db "@"

DisplayPlayerBlackedOutText::
	ld hl,PlayerBlackedOutText
	call PrintText
	ld a,[wd732]
	res 5,a // reset forced to use bike bit
	ld [wd732],a
	jp HoldTextDisplayOpen

PlayerBlackedOutText::
	TX_FAR _PlayerBlackedOutText
	db "@"

DisplayRepelWoreOffText::
	ld hl,RepelWoreOffText
	call PrintText
	jp AfterDisplayingTextID

RepelWoreOffText::
	TX_FAR _RepelWoreOffText
	db "@"

#include "engine/menu/start_menu.asm"

// function to count how many bits are set in a string of bytes
// INPUT:
// hl = address of string of bytes
// b = length of string of bytes
// OUTPUT:
// [wNumSetBits] = number of set bits
CountSetBits::
	ld c,0
.loop
	ld a,[hli]
	ld e,a
	ld d,8
.innerLoop // count how many bits are set in the current byte
	srl e
	ld a,0
	adc c
	ld c,a
	dec d
	jr nz,.innerLoop
	dec b
	jr nz,.loop
	ld a,c
	ld [wNumSetBits],a
	ret

// subtracts the amount the player paid from their money
// sets carry flag if there is enough money and unsets carry flag if not
SubtractAmountPaidFromMoney::
	jpba SubtractAmountPaidFromMoney_

// adds the amount the player sold to their money
AddAmountSoldToMoney::
	ld de,wPlayerMoney + 2
	ld hl,$ffa1 // total price of items
	ld c,3 // length of money in bytes
	predef AddBCDPredef // add total price to money
	ld a,MONEY_BOX
	ld [wTextBoxID],a
	call DisplayTextBoxID // redraw money text box
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	jp WaitForSoundToFinish

// function to remove an item (in varying quantities) from the player's bag or PC box
// INPUT:
// HL = address of inventory (either wNumBagItems or wNumBoxItems)
// [wWhichPokemon] = index (within the inventory) of the item to remove
// [wItemQuantity] = quantity to remove
RemoveItemFromInventory::
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,BANK(RemoveItemFromInventory_)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call RemoveItemFromInventory_
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// function to add an item (in varying quantities) to the player's bag or PC box
// INPUT:
// HL = address of inventory (either wNumBagItems or wNumBoxItems)
// [wcf91] = item ID
// [wItemQuantity] = item quantity
// sets carry flag if successful, unsets carry flag if unsuccessful
AddItemToInventory::
	push bc
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,BANK(AddItemToInventory_)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call AddItemToInventory_
	pop bc
	ld a,b
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	pop bc
	ret

// INPUT:
// [wListMenuID] = list menu ID
// [wListPointer] = address of the list (2 bytes)
DisplayListMenuID::
	xor a
	ld [H_AUTOBGTRANSFERENABLED],a // disable auto-transfer
	ld a,1
	ld [hJoy7],a // joypad state update flag
	ld a,[wBattleType]
	and a // is it the Old Man battle?
	jr nz,.specialBattleType
	ld a,$01 // hardcoded bank
	jr .bankswitch
.specialBattleType // Old Man battle
	ld a, BANK(DisplayBattleMenu)
.bankswitch
	call BankswitchHome
	ld hl,wd730
	set 6,[hl] // turn off letter printing delay
	xor a
	ld [wMenuItemToSwap],a // 0 means no item is currently being swapped
	ld [wListCount],a
	ld a,[wListPointer]
	ld l,a
	ld a,[wListPointer + 1]
	ld h,a // hl = address of the list
	ld a,[hl] // the first byte is the number of entries in the list
	ld [wListCount],a
	ld a,LIST_MENU_BOX
	ld [wTextBoxID],a
	call DisplayTextBoxID // draw the menu text box
	call UpdateSprites // disable sprites behind the text box
// the code up to .skipMovingSprites appears to be useless
	coord hl, 4, 2 // coordinates of upper left corner of menu text box
	lb de, 9, 14 // height and width of menu text box
	ld a,[wListMenuID]
	and a // is it a PC pokemon list?
	jr nz,.skipMovingSprites
	call UpdateSprites
.skipMovingSprites
	ld a,1 // max menu item ID is 1 if the list has less than 2 entries
	ld [wMenuWatchMovingOutOfBounds],a
	ld a,[wListCount]
	cp 2 // does the list have less than 2 entries?
	jr c,.setMenuVariables
	ld a,2 // max menu item ID is 2 if the list has at least 2 entries
.setMenuVariables
	ld [wMaxMenuItem],a
	ld a,4
	ld [wTopMenuItemY],a
	ld a,5
	ld [wTopMenuItemX],a
	ld a,A_BUTTON | B_BUTTON | SELECT
	ld [wMenuWatchedKeys],a
	ld c,10
	call DelayFrames

DisplayListMenuIDLoop::
	xor a
	ld [H_AUTOBGTRANSFERENABLED],a // disable transfer
	call PrintListMenuEntries
	ld a,1
	ld [H_AUTOBGTRANSFERENABLED],a // enable transfer
	call Delay3
	ld a,[wBattleType]
	and a // is it the Old Man battle?
	jr z,.notOldManBattle
.oldManBattle
	ld a,"▶"
	Coorda 5, 4 // place menu cursor in front of first menu entry
	ld c,80
	call DelayFrames
	xor a
	ld [wCurrentMenuItem],a
	coord hl, 5, 4
	ld a,l
	ld [wMenuCursorLocation],a
	ld a,h
	ld [wMenuCursorLocation + 1],a
	jr .buttonAPressed
.notOldManBattle
	call LoadGBPal
	call HandleMenuInput
	push af
	call PlaceMenuCursor
	pop af
	bit 0,a // was the A button pressed?
	jp z,.checkOtherKeys
.buttonAPressed
	ld a,[wCurrentMenuItem]
	call PlaceUnfilledArrowMenuCursor

// pointless because both values are overwritten before they are read
	ld a,$01
	ld [wMenuExitMethod],a
	ld [wChosenMenuItem],a

	xor a
	ld [wMenuWatchMovingOutOfBounds],a
	ld a,[wCurrentMenuItem]
	ld c,a
	ld a,[wListScrollOffset]
	add c
	ld c,a
	ld a,[wListCount]
	and a // is the list empty?
	jp z,ExitListMenu // if so, exit the menu
	dec a
	cp c // did the player select Cancel?
	jp c,ExitListMenu // if so, exit the menu
	ld a,c
	ld [wWhichPokemon],a
	ld a,[wListMenuID]
	cp ITEMLISTMENU
	jr nz,.skipMultiplying
// if it's an item menu
	sla c // item entries are 2 bytes long, so multiply by 2
.skipMultiplying
	ld a,[wListPointer]
	ld l,a
	ld a,[wListPointer + 1]
	ld h,a
	inc hl // hl = beginning of list entries
	ld b,0
	add hl,bc
	ld a,[hl]
	ld [wcf91],a
	ld a,[wListMenuID]
	and a // is it a PC pokemon list?
	jr z,.pokemonList
	push hl
	call GetItemPrice
	pop hl
	ld a,[wListMenuID]
	cp ITEMLISTMENU
	jr nz,.skipGettingQuantity
// if it's an item menu
	inc hl
	ld a,[hl] // a = item quantity
	ld [wMaxItemQuantity],a
.skipGettingQuantity
	ld a,[wcf91]
	ld [wd0b5],a
	ld a,BANK(ItemNames)
	ld [wPredefBank],a
	call GetName
	jr .storeChosenEntry
.pokemonList
	ld hl,wPartyCount
	ld a,[wListPointer]
	cp l // is it a list of party pokemon or box pokemon?
	ld hl,wPartyMonNicks
	jr z,.getPokemonName
	ld hl, wBoxMonNicks // box pokemon names
.getPokemonName
	ld a,[wWhichPokemon]
	call GetPartyMonName
.storeChosenEntry // store the menu entry that the player chose and return
	ld de,wcd6d
	call CopyStringToCF4B // copy name to wcf4b
	ld a,CHOSE_MENU_ITEM
	ld [wMenuExitMethod],a
	ld a,[wCurrentMenuItem]
	ld [wChosenMenuItem],a
	xor a
	ld [hJoy7],a // joypad state update flag
	ld hl,wd730
	res 6,[hl] // turn on letter printing delay
	jp BankswitchBack
.checkOtherKeys // check B, SELECT, Up, and Down keys
	bit 1,a // was the B button pressed?
	jp nz,ExitListMenu // if so, exit the menu
	bit 2,a // was the select button pressed?
	jp nz,HandleItemListSwapping // if so, allow the player to swap menu entries
	ld b,a
	bit 7,b // was Down pressed?
	ld hl,wListScrollOffset
	jr z,.upPressed
.downPressed
	ld a,[hl]
	add 3
	ld b,a
	ld a,[wListCount]
	cp b // will going down scroll past the Cancel button?
	jp c,DisplayListMenuIDLoop
	inc [hl] // if not, go down
	jp DisplayListMenuIDLoop
.upPressed
	ld a,[hl]
	and a
	jp z,DisplayListMenuIDLoop
	dec [hl]
	jp DisplayListMenuIDLoop

DisplayChooseQuantityMenu::
// text box dimensions/coordinates for just quantity
	coord hl, 15, 9
	ld b,1 // height
	ld c,3 // width
	ld a,[wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz,.drawTextBox
// text box dimensions/coordinates for quantity and price
	coord hl, 7, 9
	ld b,1  // height
	ld c,11 // width
.drawTextBox
	call TextBoxBorder
	coord hl, 16, 10
	ld a,[wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz,.printInitialQuantity
	coord hl, 8, 10
.printInitialQuantity
	ld de,InitialQuantityText
	call PlaceString
	xor a
	ld [wItemQuantity],a // initialize current quantity to 0
	jp .incrementQuantity
.waitForKeyPressLoop
	call JoypadLowSensitivity
	ld a,[hJoyPressed] // newly pressed buttons
	bit 0,a // was the A button pressed?
	jp nz,.buttonAPressed
	bit 1,a // was the B button pressed?
	jp nz,.buttonBPressed
	bit 6,a // was Up pressed?
	jr nz,.incrementQuantity
	bit 7,a // was Down pressed?
	jr nz,.decrementQuantity
	jr .waitForKeyPressLoop
.incrementQuantity
	ld a,[wMaxItemQuantity]
	inc a
	ld b,a
	ld hl,wItemQuantity // current quantity
	inc [hl]
	ld a,[hl]
	cp b
	jr nz,.handleNewQuantity
// wrap to 1 if the player goes above the max quantity
	ld a,1
	ld [hl],a
	jr .handleNewQuantity
.decrementQuantity
	ld hl,wItemQuantity // current quantity
	dec [hl]
	jr nz,.handleNewQuantity
// wrap to the max quantity if the player goes below 1
	ld a,[wMaxItemQuantity]
	ld [hl],a
.handleNewQuantity
	coord hl, 17, 10
	ld a,[wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz,.printQuantity
.printPrice
	ld c,$03
	ld a,[wItemQuantity]
	ld b,a
	ld hl,hMoney // total price
// initialize total price to 0
	xor a
	ld [hli],a
	ld [hli],a
	ld [hl],a
.addLoop // loop to multiply the individual price by the quantity to get the total price
	ld de,hMoney + 2
	ld hl,hItemPrice + 2
	push bc
	predef AddBCDPredef // add the individual price to the current sum
	pop bc
	dec b
	jr nz,.addLoop
	ld a,[hHalveItemPrices]
	and a // should the price be halved (for selling items)?
	jr z,.skipHalvingPrice
	xor a
	ld [hDivideBCDDivisor],a
	ld [hDivideBCDDivisor + 1],a
	ld a,$02
	ld [hDivideBCDDivisor + 2],a
	predef DivideBCDPredef3 // halves the price
// store the halved price
	ld a,[hDivideBCDQuotient]
	ld [hMoney],a
	ld a,[hDivideBCDQuotient + 1]
	ld [hMoney + 1],a
	ld a,[hDivideBCDQuotient + 2]
	ld [hMoney + 2],a
.skipHalvingPrice
	coord hl, 12, 10
	ld de,SpacesBetweenQuantityAndPriceText
	call PlaceString
	ld de,hMoney // total price
	ld c,$a3
	call PrintBCDNumber
	coord hl, 9, 10
.printQuantity
	ld de,wItemQuantity // current quantity
	lb bc, LEADING_ZEROES | 1, 2 // 1 byte, 2 digits
	call PrintNumber
	jp .waitForKeyPressLoop
.buttonAPressed // the player chose to make the transaction
	xor a
	ld [wMenuItemToSwap],a // 0 means no item is currently being swapped
	ret
.buttonBPressed // the player chose to cancel the transaction
	xor a
	ld [wMenuItemToSwap],a // 0 means no item is currently being swapped
	ld a,$ff
	ret

InitialQuantityText::
	db "×01@"

SpacesBetweenQuantityAndPriceText::
	db "      @"

ExitListMenu::
	ld a,[wCurrentMenuItem]
	ld [wChosenMenuItem],a
	ld a,CANCELLED_MENU
	ld [wMenuExitMethod],a
	ld [wMenuWatchMovingOutOfBounds],a
	xor a
	ld [hJoy7],a
	ld hl,wd730
	res 6,[hl]
	call BankswitchBack
	xor a
	ld [wMenuItemToSwap],a // 0 means no item is currently being swapped
	scf
	ret

PrintListMenuEntries::
	coord hl, 5, 3
	ld b,9
	ld c,14
	call ClearScreenArea
	ld a,[wListPointer]
	ld e,a
	ld a,[wListPointer + 1]
	ld d,a
	inc de // de = beginning of list entries
	ld a,[wListScrollOffset]
	ld c,a
	ld a,[wListMenuID]
	cp ITEMLISTMENU
	ld a,c
	jr nz,.skipMultiplying
// if it's an item menu
// item entries are 2 bytes long, so multiply by 2
	sla a
	sla c
.skipMultiplying
	add e
	ld e,a
	jr nc,.noCarry
	inc d
.noCarry
	coord hl, 6, 4 // coordinates of first list entry name
	ld b,4 // print 4 names
.loop
	ld a,b
	ld [wWhichPokemon],a
	ld a,[de]
	ld [wd11e],a
	cp $ff
	jp z,.printCancelMenuItem
	push bc
	push de
	push hl
	push hl
	push de
	ld a,[wListMenuID]
	and a
	jr z,.pokemonPCMenu
	cp MOVESLISTMENU
	jr z,.movesMenu
.itemMenu
	call GetItemName
	jr .placeNameString
.pokemonPCMenu
	push hl
	ld hl,wPartyCount
	ld a,[wListPointer]
	cp l // is it a list of party pokemon or box pokemon?
	ld hl,wPartyMonNicks
	jr z,.getPokemonName
	ld hl, wBoxMonNicks // box pokemon names
.getPokemonName
	ld a,[wWhichPokemon]
	ld b,a
	ld a,4
	sub b
	ld b,a
	ld a,[wListScrollOffset]
	add b
	call GetPartyMonName
	pop hl
	jr .placeNameString
.movesMenu
	call GetMoveName
.placeNameString
	call PlaceString
	pop de
	pop hl
	ld a,[wPrintItemPrices]
	and a // should prices be printed?
	jr z,.skipPrintingItemPrice
.printItemPrice
	push hl
	ld a,[de]
	ld de,ItemPrices
	ld [wcf91],a
	call GetItemPrice // get price
	pop hl
	ld bc, SCREEN_WIDTH + 5 // 1 row down and 5 columns right
	add hl,bc
	ld c,$a3 // no leading zeroes, right-aligned, print currency symbol, 3 bytes
	call PrintBCDNumber
.skipPrintingItemPrice
	ld a,[wListMenuID]
	and a
	jr nz,.skipPrintingPokemonLevel
.printPokemonLevel
	ld a,[wd11e]
	push af
	push hl
	ld hl,wPartyCount
	ld a,[wListPointer]
	cp l // is it a list of party pokemon or box pokemon?
	ld a,PLAYER_PARTY_DATA
	jr z,.next
	ld a,BOX_DATA
.next
	ld [wMonDataLocation],a
	ld hl,wWhichPokemon
	ld a,[hl]
	ld b,a
	ld a,$04
	sub b
	ld b,a
	ld a,[wListScrollOffset]
	add b
	ld [hl],a
	call LoadMonData
	ld a,[wMonDataLocation]
	and a // is it a list of party pokemon or box pokemon?
	jr z,.skipCopyingLevel
.copyLevel
	ld a,[wLoadedMonBoxLevel]
	ld [wLoadedMonLevel],a
.skipCopyingLevel
	pop hl
	ld bc,$001c
	add hl,bc
	call PrintLevel
	pop af
	ld [wd11e],a
.skipPrintingPokemonLevel
	pop hl
	pop de
	inc de
	ld a,[wListMenuID]
	cp ITEMLISTMENU
	jr nz,.nextListEntry
.printItemQuantity
	ld a,[wd11e]
	ld [wcf91],a
	call IsKeyItem // check if item is unsellable
	ld a,[wIsKeyItem]
	and a // is the item unsellable?
	jr nz,.skipPrintingItemQuantity // if so, don't print the quantity
	push hl
	ld bc, SCREEN_WIDTH + 8 // 1 row down and 8 columns right
	add hl,bc
	ld a,"×"
	ld [hli],a
	ld a,[wd11e]
	push af
	ld a,[de]
	ld [wMaxItemQuantity],a
	push de
	ld de,wd11e
	ld [de],a
	lb bc, 1, 2
	call PrintNumber
	pop de
	pop af
	ld [wd11e],a
	pop hl
.skipPrintingItemQuantity
	inc de
	pop bc
	inc c
	push bc
	inc c
	ld a,[wMenuItemToSwap] // ID of item chosen for swapping (counts from 1)
	and a // is an item being swapped?
	jr z,.nextListEntry
	sla a
	cp c // is it this item?
	jr nz,.nextListEntry
	dec hl
	ld a,$ec // unfilled right arrow menu cursor to indicate an item being swapped
	ld [hli],a
.nextListEntry
	ld bc,2 * SCREEN_WIDTH // 2 rows
	add hl,bc
	pop bc
	inc c
	dec b
	jp nz,.loop
	ld bc,-8
	add hl,bc
	ld a,"▼"
	ld [hl],a
	ret
.printCancelMenuItem
	ld de,ListMenuCancelText
	jp PlaceString

ListMenuCancelText::
	db "CANCEL@"

GetMonName::
	push hl
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,BANK(MonsterNames)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ld a,[wd11e]
	dec a
	ld hl,MonsterNames
	ld c,10
	ld b,0
	call AddNTimes
	ld de,wcd6d
	push de
	ld bc,10
	call CopyData
	ld hl,wcd6d + 10
	ld [hl], "@"
	pop de
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	pop hl
	ret

GetItemName::
// given an item ID at [wd11e], store the name of the item into a string
//     starting at wcd6d
	push hl
	push bc
	ld a,[wd11e]
	cp HM_01 // is this a TM/HM?
	jr nc,.Machine

	ld [wd0b5],a
	ld a,ITEM_NAME
	ld [wNameListType],a
	ld a,BANK(ItemNames)
	ld [wPredefBank],a
	call GetName
	jr .Finish

.Machine
	call GetMachineName
.Finish
	ld de,wcd6d // pointer to where item name is stored in RAM
	pop bc
	pop hl
	ret

GetMachineName::
// copies the name of the TM/HM in [wd11e] to wcd6d
	push hl
	push de
	push bc
	ld a,[wd11e]
	push af
	cp TM_01 // is this a TM? [not HM]
	jr nc,.WriteTM
// if HM, then write "HM" and add 5 to the item ID, so we can reuse the
// TM printing code
	add 5
	ld [wd11e],a
	ld hl,HiddenPrefix // points to "HM"
	ld bc,2
	jr .WriteMachinePrefix
.WriteTM
	ld hl,TechnicalPrefix // points to "TM"
	ld bc,2
.WriteMachinePrefix
	ld de,wcd6d
	call CopyData

// now get the machine number and convert it to text
	ld a,[wd11e]
	sub TM_01 - 1
	ld b, "0"
.FirstDigit
	sub 10
	jr c,.SecondDigit
	inc b
	jr .FirstDigit
.SecondDigit
	add 10
	push af
	ld a,b
	ld [de],a
	inc de
	pop af
	ld b, "0"
	add b
	ld [de],a
	inc de
	ld a,"@"
	ld [de],a
	pop af
	ld [wd11e],a
	pop bc
	pop de
	pop hl
	ret

TechnicalPrefix::
	db "TM"
HiddenPrefix::
	db "HM"

// sets carry if item is HM, clears carry if item is not HM
// Input: a = item ID
IsItemHM::
	cp HM_01
	jr c,.notHM
	cp TM_01
	ret
.notHM
	and a
	ret

// sets carry if move is an HM, clears carry if move is not an HM
// Input: a = move ID
IsMoveHM::
	ld hl,HMMoves
	ld de,1
	jp IsInArray

HMMoves::
	db CUT,FLY,SURF,STRENGTH,FLASH
	db $ff // terminator

GetMoveName::
	push hl
	ld a,MOVE_NAME
	ld [wNameListType],a
	ld a,[wd11e]
	ld [wd0b5],a
	ld a,BANK(MoveNames)
	ld [wPredefBank],a
	call GetName
	ld de,wcd6d // pointer to where move name is stored in RAM
	pop hl
	ret

// reloads text box tile patterns, current map view, and tileset tile patterns
ReloadMapData::
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[wCurMap]
	call SwitchToMapRomBank
	DisableLCD()
	call LoadTextBoxTilePatterns
	call LoadCurrentMapView
	call LoadTilesetTilePatternData
	EnableLCD()
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// reloads tileset tile patterns
ReloadTilesetTilePatterns::
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[wCurMap]
	call SwitchToMapRomBank
	DisableLCD()
	call LoadTilesetTilePatternData
	EnableLCD()
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// shows the town map and lets the player choose a destination to fly to
ChooseFlyDestination::
	ld hl,wd72e
	res 4,[hl]
	jpba LoadTownMap_Fly

// causes the text box to close without waiting for a button press after displaying text
DisableWaitingAfterTextDisplay::
	ld a,$01
	ld [wDoNotWaitForButtonPressAfterDisplayingText],a
	ret

// uses an item
// UseItem is used with dummy items to perform certain other functions as well
// INPUT:
// [wcf91] = item ID
// OUTPUT:
// [wActionResultOrTookBattleTurn] = success
// 00: unsuccessful
// 01: successful
// 02: not able to be used right now, no extra menu displayed (only certain items use this)
UseItem::
	jpba UseItem_

// confirms the item toss and then tosses the item
// INPUT:
// hl = address of inventory (either wNumBagItems or wNumBoxItems)
// [wcf91] = item ID
// [wWhichPokemon] = index of item within inventory
// [wItemQuantity] = quantity to toss
// OUTPUT:
// clears carry flag if the item is tossed, sets carry flag if not
TossItem::
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,BANK(TossItem_)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call TossItem_
	pop de
	ld a,d
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// checks if an item is a key item
// INPUT:
// [wcf91] = item ID
// OUTPUT:
// [wIsKeyItem] = result
// 00: item is not key item
// 01: item is key item
IsKeyItem::
	push hl
	push de
	push bc
	callba IsKeyItem_
	pop bc
	pop de
	pop hl
	ret

// function to draw various text boxes
// INPUT:
// [wTextBoxID] = text box ID
// b, c = y, x cursor position (TWO_OPTION_MENU only)
DisplayTextBoxID::
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,BANK(DisplayTextBoxID_)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call DisplayTextBoxID_
	pop bc
	ld a,b
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// not zero if an NPC movement script is running, the player character is
// automatically stepping down from a door, or joypad states are being simulated
IsPlayerCharacterBeingControlledByGame::
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wd736]
	bit 1, a // currently stepping down from door bit
	ret nz
	ld a, [wd730]
	and $80
	ret

RunNPCMovementScript::
	ld hl, wd736
	bit 0, [hl]
	res 0, [hl]
	jr nz, .playerStepOutFromDoor
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret z
	dec a
	add a
	ld d, 0
	ld e, a
	ld hl, .NPCMovementScriptPointerTables
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wNPCMovementScriptBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld a, [wNPCMovementScriptFunctionNum]
	call CallFunctionInTable
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

.NPCMovementScriptPointerTables
	dw PalletMovementScriptPointerTable
	dw PewterMuseumGuyMovementScriptPointerTable
	dw PewterGymGuyMovementScriptPointerTable
.playerStepOutFromDoor
	jpba PlayerStepOutFromDoor

EndNPCMovementScript::
	jpba _EndNPCMovementScript

EmptyFunc2::
	ret

// stores hl in [wTrainerHeaderPtr]
StoreTrainerHeaderPointer::
	ld a, h
	ld [wTrainerHeaderPtr], a
	ld a, l
	ld [wTrainerHeaderPtr+1], a
	ret

// executes the current map script from the function pointer array provided in hl.
// a: map script index to execute (unless overridden by [wd733] bit 4)
ExecuteCurMapScriptInTable::
	push af
	push de
	call StoreTrainerHeaderPointer
	pop hl
	pop af
	push hl
	ld hl, wFlags_D733
	bit 4, [hl]
	res 4, [hl]
	jr z, .useProvidedIndex   // test if map script index was overridden manually
	ld a, [wCurMapScript]
.useProvidedIndex
	pop hl
	ld [wCurMapScript], a
	call CallFunctionInTable
	ld a, [wCurMapScript]
	ret

LoadGymLeaderAndCityName::
	push de
	ld de, wGymCityName
	ld bc, $11
	call CopyData   // load city name
	pop hl
	ld de, wGymLeaderName
	ld bc, NAME_LENGTH
	jp CopyData     // load gym leader name

// reads specific information from trainer header (pointed to at wTrainerHeaderPtr)
// a: offset in header data
//    0 -> flag's bit (into wTrainerHeaderFlagBit)
//    2 -> flag's byte ptr (into hl)
//    4 -> before battle text (into hl)
//    6 -> after battle text (into hl)
//    8 -> end battle text (into hl)
ReadTrainerHeaderInfo::
	push de
	push af
	ld d, $0
	ld e, a
	ld hl, wTrainerHeaderPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	add hl, de
	pop af
	and a
	jr nz, .nonZeroOffset
	ld a, [hl]
	ld [wTrainerHeaderFlagBit], a  // store flag's bit
	jr .done
.nonZeroOffset
	cp $2
	jr z, .readPointer // read flag's byte ptr
	cp $4
	jr z, .readPointer // read before battle text
	cp $6
	jr z, .readPointer // read after battle text
	cp $8
	jr z, .readPointer // read end battle text
	cp $a
	jr nz, .done
	ld a, [hli]        // read end battle text (2) but override the result afterwards (XXX why, bug?)
	ld d, [hl]
	ld e, a
	jr .done
.readPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
.done
	pop de
	ret

TrainerFlagAction::
	predef_jump FlagActionPredef

TalkToTrainer::
	call StoreTrainerHeaderPointer
	xor a
	call ReadTrainerHeaderInfo     // read flag's bit
	ld a, $2
	call ReadTrainerHeaderInfo     // read flag's byte ptr
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_TEST
	call TrainerFlagAction      // read trainer's flag
	ld a, c
	and a
	jr z, .trainerNotYetFought     // test trainer's flag
	ld a, $6
	call ReadTrainerHeaderInfo     // print after battle text
	jp PrintText
.trainerNotYetFought
	ld a, $4
	call ReadTrainerHeaderInfo     // print before battle text
	call PrintText
	ld a, $a
	call ReadTrainerHeaderInfo     // (?) does nothing apparently (maybe bug in ReadTrainerHeaderInfo)
	push de
	ld a, $8
	call ReadTrainerHeaderInfo     // read end battle text
	pop de
	call SaveEndBattleTextPointers
	ld hl, wFlags_D733
	set 4, [hl]                    // activate map script index override (index is set below)
	ld hl, wFlags_0xcd60
	bit 0, [hl]                    // test if player is already engaging the trainer (because the trainer saw the player)
	ret nz
// if the player talked to the trainer of his own volition
	call EngageMapTrainer
	ld hl, wCurMapScript
	inc [hl]      // increment map script index before StartTrainerBattle increments it again (next script function is usually EndTrainerBattle)
	jp StartTrainerBattle

// checks if any trainers are seeing the player and wanting to fight
CheckFightingMapTrainers::
	call CheckForEngagingTrainers
	ld a, [wSpriteIndex]
	cp $ff
	jr nz, .trainerEngaging
	xor a
	ld [wSpriteIndex], a
	ld [wTrainerHeaderFlagBit], a
	ret
.trainerEngaging
	ld hl, wFlags_D733
	set 3, [hl]
	ld [wEmotionBubbleSpriteIndex], a
	xor a // EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	xor a
	ld [hJoyHeld], a
	call TrainerWalkUpToPlayer_Bank0
	ld hl, wCurMapScript
	inc [hl]      // increment map script index (next script function is usually DisplayEnemyTrainerTextAndStartBattle)
	ret

// display the before battle text after the enemy trainer has walked up to the player's sprite
DisplayEnemyTrainerTextAndStartBattle::
	ld a, [wd730]
	and $1
	ret nz // return if the enemy trainer hasn't finished walking to the player's sprite
	ld [wJoyIgnore], a
	ld a, [wSpriteIndex]
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	// fall through

StartTrainerBattle::
	xor a
	ld [wJoyIgnore], a
	call InitBattleEnemyParameters
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, wd72e
	set 1, [hl]
	ld hl, wCurMapScript
	inc [hl]        // increment map script index (next script function is usually EndTrainerBattle)
	ret

EndTrainerBattle::
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	set 6, [hl]
	ld hl, wd72d
	res 7, [hl]
	ld hl, wFlags_0xcd60
	res 0, [hl]                  // player is no longer engaged by any trainer
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetButtonPressedAndMapScript
	ld a, $2
	call ReadTrainerHeaderInfo
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_SET
	call TrainerFlagAction   // flag trainer as fought
	ld a, [wEnemyMonOrTrainerClass]
	cp 200
	jr nc, .skipRemoveSprite    // test if trainer was fought (in that case skip removing the corresponding sprite)
	ld hl, wMissableObjectList
	ld de, $2
	ld a, [wSpriteIndex]
	call IsInArray              // search for sprite ID
	inc hl
	ld a, [hl]
	ld [wMissableObjectIndex], a               // load corresponding missable object index and remove it
	predef HideObject
.skipRemoveSprite
	ld hl, wd730
	bit 4, [hl]
	res 4, [hl]
	ret nz

ResetButtonPressedAndMapScript::
	xor a
	ld [wJoyIgnore], a
	ld [hJoyHeld], a
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ld [wCurMapScript], a               // reset battle status
	ret

// calls TrainerWalkUpToPlayer
TrainerWalkUpToPlayer_Bank0::
	jpba TrainerWalkUpToPlayer

// sets opponent type and mon set/lvl based on the engaging trainer data
InitBattleEnemyParameters::
	ld a, [wEngagedTrainerClass]
	ld [wCurOpponent], a
	ld [wEnemyMonOrTrainerClass], a
	cp 200
	ld a, [wEngagedTrainerSet]
	jr c, .noTrainer
	ld [wTrainerNo], a
	ret
.noTrainer
	ld [wCurEnemyLVL], a
	ret

GetSpritePosition1::
	ld hl, _GetSpritePosition1
	jr SpritePositionBankswitch

GetSpritePosition2::
	ld hl, _GetSpritePosition2
	jr SpritePositionBankswitch

SetSpritePosition1::
	ld hl, _SetSpritePosition1
	jr SpritePositionBankswitch

SetSpritePosition2::
	ld hl, _SetSpritePosition2
SpritePositionBankswitch::
	ld b, BANK(_GetSpritePosition1) // BANK(_GetSpritePosition2), BANK(_SetSpritePosition1), BANK(_SetSpritePosition2)
	jp Bankswitch // indirect jump to one of the four functions

CheckForEngagingTrainers::
	xor a
	call ReadTrainerHeaderInfo       // read trainer flag's bit (unused)
	ld d, h                          // store trainer header address in de
	ld e, l
.trainerLoop
	call StoreTrainerHeaderPointer   // set trainer header pointer to current trainer
	ld a, [de]
	ld [wSpriteIndex], a                     // store trainer flag's bit
	ld [wTrainerHeaderFlagBit], a
	cp $ff
	ret z
	ld a, $2
	call ReadTrainerHeaderInfo       // read trainer flag's byte ptr
	ld b, FLAG_TEST
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	call TrainerFlagAction        // read trainer flag
	ld a, c
	and a // has the trainer already been defeated?
	jr nz, .continue
	push hl
	push de
	push hl
	xor a
	call ReadTrainerHeaderInfo       // get trainer header pointer
	inc hl
	ld a, [hl]                       // read trainer engage distance
	pop hl
	ld [wTrainerEngageDistance], a
	ld a, [wSpriteIndex]
	swap a
	ld [wTrainerSpriteOffset], a
	predef TrainerEngage
	pop de
	pop hl
	ld a, [wTrainerSpriteOffset]
	and a
	ret nz        // break if the trainer is engaging
.continue
	ld hl, $c
	add hl, de
	ld d, h
	ld e, l
	jr .trainerLoop

// hl = text if the player wins
// de = text if the player loses
SaveEndBattleTextPointers::
	ld a, [H_LOADEDROMBANK]
	ld [wEndBattleTextRomBank], a
	ld a, h
	ld [wEndBattleWinTextPointer], a
	ld a, l
	ld [wEndBattleWinTextPointer + 1], a
	ld a, d
	ld [wEndBattleLoseTextPointer], a
	ld a, e
	ld [wEndBattleLoseTextPointer + 1], a
	ret

// loads data of some trainer on the current map and plays pre-battle music
// [wSpriteIndex]: sprite ID of trainer who is engaged
EngageMapTrainer::
	ld hl, wMapSpriteExtraData
	ld d, $0
	ld a, [wSpriteIndex]
	dec a
	add a
	ld e, a
	add hl, de     // seek to engaged trainer data
	ld a, [hli]    // load trainer class
	ld [wEngagedTrainerClass], a
	ld a, [hl]     // load trainer mon set
	ld [wEngagedTrainerSet], a
	jp PlayTrainerMusic

PrintEndBattleText::
	push hl
	ld hl, wd72d
	bit 7, [hl]
	res 7, [hl]
	pop hl
	ret z
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wEndBattleTextRomBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	push hl
	callba SaveTrainerName
	ld hl, TrainerEndBattleText
	call PrintText
	pop hl
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	callba FreezeEnemyTrainerSprite
	jp WaitForSoundToFinish

GetSavedEndBattleTextPointer::
	ld a, [wBattleResult]
	and a
// won battle
	jr nz, .lostBattle
	ld a, [wEndBattleWinTextPointer]
	ld h, a
	ld a, [wEndBattleWinTextPointer + 1]
	ld l, a
	ret
.lostBattle
	ld a, [wEndBattleLoseTextPointer]
	ld h, a
	ld a, [wEndBattleLoseTextPointer + 1]
	ld l, a
	ret

TrainerEndBattleText::
	TX_FAR _TrainerNameText
	TX_ASM
	call GetSavedEndBattleTextPointer
	call TextCommandProcessor
	jp TextScriptEnd

// only engage withe trainer if the player is not already
// engaged with another trainer
// XXX unused?
CheckIfAlreadyEngaged::
	ld a, [wFlags_0xcd60]
	bit 0, a
	ret nz
	call EngageMapTrainer
	xor a
	ret

PlayTrainerMusic::
	ld a, [wEngagedTrainerClass]
	cp OPP_SONY1
	ret z
	cp OPP_SONY2
	ret z
	cp OPP_SONY3
	ret z
	ld a, [wGymLeaderNo]
	and a
	ret nz
	xor a
	ld [wAudioFadeOutControl], a
	ld a, $ff
	PlaySound(a);
	ld a, BANK(Music_MeetEvilTrainer)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, [wEngagedTrainerClass]
	ld b, a
	ld hl, EvilTrainerList
.evilTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, .noEvilTrainer
	cp b
	jr nz, .evilTrainerListLoop
	ld a, MUSIC_MEET_EVIL_TRAINER
	jr .PlaySound
.noEvilTrainer
	ld hl, FemaleTrainerList
.femaleTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, .maleTrainer
	cp b
	jr nz, .femaleTrainerListLoop
	ld a, MUSIC_MEET_FEMALE_TRAINER
	jr .PlaySound
.maleTrainer
	ld a, MUSIC_MEET_MALE_TRAINER
.PlaySound
	ld [wNewSoundID], a
	PlaySound(a);

#include "data/trainer_types.asm"

// checks if the player's coordinates match an arrow movement tile's coordinates
// and if so, decodes the RLE movement data
// b = player Y
// c = player X
DecodeArrowMovementRLE::
	ld a, [hli]
	cp $ff
	ret z // no match in the list
	cp b
	jr nz, .nextArrowMovementTileEntry1
	ld a, [hli]
	cp c
	jr nz, .nextArrowMovementTileEntry2
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	ret
.nextArrowMovementTileEntry1
	inc hl
.nextArrowMovementTileEntry2
	inc hl
	inc hl
	jr DecodeArrowMovementRLE

FuncTX_ItemStoragePC::
	call SaveScreenTilesToBuffer2
	ld b, BANK(PlayerPC)
	ld hl, PlayerPC
	jr bankswitchAndContinue

FuncTX_BillsPC::
	call SaveScreenTilesToBuffer2
	ld b, BANK(BillsPC_)
	ld hl, BillsPC_
	jr bankswitchAndContinue

FuncTX_GameCornerPrizeMenu::
// XXX find a better name for this function
// special_F7
	ld b,BANK(CeladonPrizeMenu)
	ld hl,CeladonPrizeMenu
bankswitchAndContinue::
	call Bankswitch
	jp HoldTextDisplayOpen        // continue to main text-engine function

FuncTX_PokemonCenterPC::
	ld b, BANK(ActivatePC)
	ld hl, ActivatePC
	jr bankswitchAndContinue

StartSimulatingJoypadStates::
	xor a
	ld [wOverrideSimulatedJoypadStatesMask], a
	ld [wSpriteStateData2 + $06], a // player's sprite movement byte 1
	ld hl, wd730
	set 7, [hl]
	ret

IsItemInBag::
// given an item_id in b
// set zero flag if item isn't in player's bag
// else reset zero flag
// related to Pokémon Tower and ghosts
	predef GetQuantityOfItemInBag
	ld a,b
	and a
	ret

DisplayPokedex::
	ld [wd11e], a
	jpba _DisplayPokedex

SetSpriteFacingDirectionAndDelay::
	call SetSpriteFacingDirection
	ld c, 6
	jp DelayFrames

SetSpriteFacingDirection::
	ld a, $9
	ld [H_SPRITEDATAOFFSET], a
	call GetPointerWithinSpriteStateData1
	ld a, [hSpriteFacingDirection]
	ld [hl], a
	ret

SetSpriteImageIndexAfterSettingFacingDirection::
	ld de, -7
	add hl, de
	ld [hl], a
	ret

// tests if the player's coordinates are in a specified array
// INPUT:
// hl = address of array
// OUTPUT:
// [wCoordIndex] = if there is match, the matching array index
// sets carry if the coordinates are in the array, clears carry if not
ArePlayerCoordsInArray::
	ld a,[wYCoord]
	ld b,a
	ld a,[wXCoord]
	ld c,a
	// fallthrough

CheckCoords::
	xor a
	ld [wCoordIndex],a
.loop
	ld a,[hli]
	cp $ff // reached terminator?
	jr z,.notInArray
	push hl
	ld hl,wCoordIndex
	inc [hl]
	pop hl
.compareYCoord
	cp b
	jr z,.compareXCoord
	inc hl
	jr .loop
.compareXCoord
	ld a,[hli]
	cp c
	jr nz,.loop
.inArray
	scf
	ret
.notInArray
	and a
	ret

// tests if a boulder's coordinates are in a specified array
// INPUT:
// hl = address of array
// [H_SPRITEINDEX] = index of boulder sprite
// OUTPUT:
// [wCoordIndex] = if there is match, the matching array index
// sets carry if the coordinates are in the array, clears carry if not
CheckBoulderCoords::
	push hl
	ld hl, wSpriteStateData2 + $04
	ld a, [H_SPRITEINDEX]
	swap a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hli]
	sub $4 // because sprite coordinates are offset by 4
	ld b, a
	ld a, [hl]
	sub $4 // because sprite coordinates are offset by 4
	ld c, a
	pop hl
	jp CheckCoords

GetPointerWithinSpriteStateData1::
	ld h, $c1
	jr _GetPointerWithinSpriteStateData

GetPointerWithinSpriteStateData2::
	ld h, $c2

_GetPointerWithinSpriteStateData:
	ld a, [H_SPRITEDATAOFFSET]
	ld b, a
	ld a, [H_SPRITEINDEX]
	swap a
	add b
	ld l, a
	ret

// decodes a $ff-terminated RLEncoded list
// each entry is a pair of bytes <byte value> <repetitions>
// the final $ff will be replicated in the output list and a contains the number of bytes written
// de: input list
// hl: output list
DecodeRLEList::
	xor a
	ld [wRLEByteCount], a     // count written bytes here
.listLoop
	ld a, [de]
	cp $ff
	jr z, .endOfList
	ld [hRLEByteValue], a // store byte value to be written
	inc de
	ld a, [de]
	ld b, $0
	ld c, a                      // number of bytes to be written
	ld a, [wRLEByteCount]
	add c
	ld [wRLEByteCount], a     // update total number of written bytes
	ld a, [hRLEByteValue]
	FillMemory(hl, bc, a);              // write a c-times to output
	inc de
	jr .listLoop
.endOfList
	ld a, $ff
	ld [hl], a                   // write final $ff
	ld a, [wRLEByteCount]
	inc a                        // include sentinel in counting
	ret

// sets movement byte 1 for sprite [H_SPRITEINDEX] to $FE and byte 2 to [hSpriteMovementByte2]
SetSpriteMovementBytesToFE::
	push hl
	call GetSpriteMovementByte1Pointer
	ld [hl], $fe
	call GetSpriteMovementByte2Pointer
	ld a, [hSpriteMovementByte2]
	ld [hl], a
	pop hl
	ret

// sets both movement bytes for sprite [H_SPRITEINDEX] to $FF
SetSpriteMovementBytesToFF::
	push hl
	call GetSpriteMovementByte1Pointer
	ld [hl],$FF
	call GetSpriteMovementByte2Pointer
	ld [hl],$FF // prevent person from walking?
	pop hl
	ret

// returns the sprite movement byte 1 pointer for sprite [H_SPRITEINDEX] in hl
GetSpriteMovementByte1Pointer::
	ld h,$C2
	ld a,[H_SPRITEINDEX]
	swap a
	add 6
	ld l,a
	ret

// returns the sprite movement byte 2 pointer for sprite [H_SPRITEINDEX] in hl
GetSpriteMovementByte2Pointer::
	push de
	ld hl,wMapSpriteData
	ld a,[H_SPRITEINDEX]
	dec a
	add a
	ld d,0
	ld e,a
	add hl,de
	pop de
	ret

GetTrainerInformation::
	call GetTrainerName
	ld a, [wLinkState]
	and a
	jr nz, .linkBattle
	ld a, Bank(TrainerPicAndMoneyPointers)
	call BankswitchHome
	ld a, [wTrainerClass]
	dec a
	ld hl, TrainerPicAndMoneyPointers
	ld bc, $5
	call AddNTimes
	ld de, wTrainerPicPointer
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, wTrainerBaseMoney
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	jp BankswitchBack
.linkBattle
	ld hl, wTrainerPicPointer
	ld de, RedPicFront
	ld [hl], e
	inc hl
	ld [hl], d
	ret

GetTrainerName::
	jpba GetTrainerName_

HasEnoughMoney::
// Check if the player has at least as much
// money as the 3-byte BCD value at hMoney.
	ld de, wPlayerMoney
	ld hl, hMoney
	ld c, 3
	jp StringCmp

HasEnoughCoins::
// Check if the player has at least as many
// coins as the 2-byte BCD value at hCoins.
	ld de, wPlayerCoins
	ld hl, hCoins
	ld c, 2
	jp StringCmp


BankswitchHome::
// switches to bank # in a
// Only use this when in the home bank!
	ld [wBankswitchHomeTemp],a
	ld a,[H_LOADEDROMBANK]
	ld [wBankswitchHomeSavedROMBank],a
	ld a,[wBankswitchHomeTemp]
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

BankswitchBack::
// returns from BankswitchHome
	ld a,[wBankswitchHomeSavedROMBank]
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

Bankswitch::
// self-contained bankswitch, use this when not in the home bank
// switches to the bank in b
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,b
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ld bc,.Return
	push bc
	jp hl
.Return
	pop bc
	ld a,b
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

// displays yes/no choice
// yes -> set carry
YesNoChoice::
	call SaveScreenTilesToBuffer1
	call InitYesNoTextBoxParameters
	jr DisplayYesNoChoice

Func_35f4::
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call InitYesNoTextBoxParameters
	jp DisplayTextBoxID

InitYesNoTextBoxParameters::
	xor a // YES_NO_MENU
	ld [wTwoOptionMenuID], a
	coord hl, 14, 7
	ld bc, $80f
	ret

YesNoChoicePokeCenter::
	call SaveScreenTilesToBuffer1
	ld a, HEAL_CANCEL_MENU
	ld [wTwoOptionMenuID], a
	coord hl, 11, 6
	lb bc, 8, 12
	jr DisplayYesNoChoice

WideYesNoChoice:: // unused
	call SaveScreenTilesToBuffer1
	ld a, WIDE_YES_NO_MENU
	ld [wTwoOptionMenuID], a
	coord hl, 12, 7
	lb bc, 8, 13

DisplayYesNoChoice::
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	jp LoadScreenTilesFromBuffer1

// calculates the difference |a-b|, setting carry flag if a<b
CalcDifference::
	sub b
	ret nc
	cpl
	add $1
	scf
	ret

MoveSprite::
// move the sprite [H_SPRITEINDEX] with the movement pointed to by de
// actually only copies the movement data to wNPCMovementDirections for later
	call SetSpriteMovementBytesToFF
MoveSprite_::
	push hl
	push bc
	call GetSpriteMovementByte1Pointer
	xor a
	ld [hl],a
	ld hl,wNPCMovementDirections
	ld c,0

.loop
	ld a,[de]
	ld [hli],a
	inc de
	inc c
	cp $FF // have we reached the end of the movement data?
	jr nz,.loop

	ld a,c
	ld [wNPCNumScriptedSteps],a // number of steps taken

	pop bc
	ld hl,wd730
	set 0,[hl]
	pop hl
	xor a
	ld [wOverrideSimulatedJoypadStatesMask],a
	ld [wSimulatedJoypadStatesEnd],a
	dec a
	ld [wJoyIgnore],a
	ld [wWastedByteCD3A],a
	ret

// divides [hDividend2] by [hDivisor2] and stores the quotient in [hQuotient2]
DivideBytes::
	push hl
	ld hl, hQuotient2
	xor a
	ld [hld], a
	ld a, [hld]
	and a
	jr z, .done
	ld a, [hli]
.loop
	sub [hl]
	jr c, .done
	inc hl
	inc [hl]
	dec hl
	jr .loop
.done
	pop hl
	ret


LoadFontTilePatterns::
	ld a, [rLCDC]
	bit 7, a // is the LCD enabled?
	jr nz, .on
.off
	ld hl, FontGraphics
	ld de, vFont
	ld bc, FontGraphicsEnd - FontGraphics
	ld a, BANK(FontGraphics)
	jp FarCopyDataDouble // if LCD is off, transfer all at once
.on
	ld de, FontGraphics
	ld hl, vFont
	lb bc, BANK(FontGraphics), (FontGraphicsEnd - FontGraphics) / $8
	jp CopyVideoDataDouble // if LCD is on, transfer during V-blank

LoadTextBoxTilePatterns::
	ld a, [rLCDC]
	bit 7, a // is the LCD enabled?
	jr nz, .on
.off
	ld hl, TextBoxGraphics
	ld de, vChars2 + $600
	ld bc, TextBoxGraphicsEnd - TextBoxGraphics
	ld a, BANK(TextBoxGraphics)
	jp FarCopyData2 // if LCD is off, transfer all at once
.on
	ld de, TextBoxGraphics
	ld hl, vChars2 + $600
	lb bc, BANK(TextBoxGraphics), (TextBoxGraphicsEnd - TextBoxGraphics) / $10
	jp CopyVideoData // if LCD is on, transfer during V-blank

LoadHpBarAndStatusTilePatterns::
	ld a, [rLCDC]
	bit 7, a // is the LCD enabled?
	jr nz, .on
.off
	ld hl, HpBarAndStatusGraphics
	ld de, vChars2 + $620
	ld bc, HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics
	ld a, BANK(HpBarAndStatusGraphics)
	jp FarCopyData2 // if LCD is off, transfer all at once
.on
	ld de, HpBarAndStatusGraphics
	ld hl, vChars2 + $620
	lb bc, BANK(HpBarAndStatusGraphics), (HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics) / $10
	jp CopyVideoData // if LCD is on, transfer during V-blank


void FillMemory(uint8_t* hl, uint16_t bc, uint8_t a){
// Fill bc bytes at hl with a.
	push de
	ld d, a
.loop
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop de
	ret
}

UncompressSpriteFromDE::
// Decompress pic at a:de.
	ld hl, wSpriteInputPtr
	ld [hl], e
	inc hl
	ld [hl], d
	jp UncompressSpriteData

SaveScreenTilesToBuffer2::
	coord hl, 0, 0
	ld de, wTileMapBackup2
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyData
	ret

LoadScreenTilesFromBuffer2::
	call LoadScreenTilesFromBuffer2DisableBGTransfer
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

// loads screen tiles stored in wTileMapBackup2 but leaves H_AUTOBGTRANSFERENABLED disabled
LoadScreenTilesFromBuffer2DisableBGTransfer::
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wTileMapBackup2
	coord de, 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyData
	ret

SaveScreenTilesToBuffer1::
	coord hl, 0, 0
	ld de, wTileMapBackup
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp CopyData

LoadScreenTilesFromBuffer1::
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wTileMapBackup
	coord de, 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyData
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

DelayFrames::
// wait c frames
	call DelayFrame
	dec c
	jr nz,DelayFrames
	ret

PlaySoundWaitForCurrent::
	push af
	call WaitForSoundToFinish
	pop af
	PlaySound(a);

// Wait for sound to finish playing
WaitForSoundToFinish::
	ld a, [wLowHealthAlarm]
	and $80
	ret nz
	push hl
.waitLoop
	ld hl, wChannelSoundIDs + Ch4
	xor a
	or [hl]
	inc hl
	or [hl]
	inc hl
	inc hl
	or [hl]
	jr nz, .waitLoop
	pop hl
	ret

NamePointers::
	dw MonsterNames
	dw MoveNames
	dw UnusedNames
	dw ItemNames
	dw wPartyMonOT // player's OT names list
	dw wEnemyMonOT // enemy's OT names list
	dw TrainerNames

GetName::
// arguments:
// [wd0b5] = which name
// [wNameListType] = which list
// [wPredefBank] = bank of list
// 
// returns pointer to name in de
	ld a,[wd0b5]
	ld [wd11e],a

	// TM names are separate from item names.
	// BUG: This applies to all names instead of just items.
	cp HM_01
	jp nc, GetMachineName

	ld a,[H_LOADEDROMBANK]
	push af
	push hl
	push bc
	push de
	ld a,[wNameListType]    // List3759_entrySelector
	dec a
	jr nz,.otherEntries
	// 1 = MON_NAMES
	call GetMonName
	ld hl,NAME_LENGTH
	add hl,de
	ld e,l
	ld d,h
	jr .gotPtr
.otherEntries
	// 2-7 = OTHER ENTRIES
	ld a,[wPredefBank]
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ld a,[wNameListType]    // VariousNames' entryID
	dec a
	add a
	ld d,0
	ld e,a
	jr nc,.skip
	inc d
.skip
	ld hl,NamePointers
	add hl,de
	ld a,[hli]
	ld [$ff96],a
	ld a,[hl]
	ld [$ff95],a
	ld a,[$ff95]
	ld h,a
	ld a,[$ff96]
	ld l,a
	ld a,[wd0b5]
	ld b,a
	ld c,0
.nextName
	ld d,h
	ld e,l
.nextChar
	ld a,[hli]
	cp "@"
	jr nz,.nextChar
	inc c           // entry counter
	ld a,b          // wanted entry
	cp c
	jr nz,.nextName
	ld h,d
	ld l,e
	ld de,wcd6d
	ld bc,$0014
	call CopyData
.gotPtr
	ld a,e
	ld [wUnusedCF8D],a
	ld a,d
	ld [wUnusedCF8D + 1],a
	pop de
	pop bc
	pop hl
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	ret

GetItemPrice::
// Stores item's price as BCD at hItemPrice (3 bytes)
// Input: [wcf91] = item id
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wListMenuID]
	cp MOVESLISTMENU
	ld a, BANK(ItemPrices)
	jr nz, .ok
	ld a, $f // hardcoded Bank
.ok
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld hl, wItemPrices
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wcf91] // a contains item id
	cp HM_01
	jr nc, .getTMPrice
	ld bc, $3
.loop
	add hl, bc
	dec a
	jr nz, .loop
	dec hl
	ld a, [hld]
	ld [hItemPrice + 2], a
	ld a, [hld]
	ld [hItemPrice + 1], a
	ld a, [hl]
	ld [hItemPrice], a
	jr .done
.getTMPrice
	ld a, Bank(GetMachinePrice)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call GetMachinePrice
.done
	ld de, hItemPrice
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

// copies a string from [de] to [wcf4b]
CopyStringToCF4B::
	ld hl, wcf4b
	// fall through

// copies a string from [de] to [hl]
CopyString::
	ld a, [de]
	inc de
	ld [hli], a
	cp "@"
	jr nz, CopyString
	ret

// this function is used when lower button sensitivity is wanted (e.g. menus)
// OUTPUT: [hJoy5] = pressed buttons in usual format
// there are two flags that control its functionality, [hJoy6] and [hJoy7]
// there are essentially three modes of operation
// 1. Get newly pressed buttons only
//    ([hJoy7] == 0, [hJoy6] == any)
//    Just copies [hJoyPressed] to [hJoy5].
// 2. Get currently pressed buttons at low sample rate with delay
//    ([hJoy7] == 1, [hJoy6] != 0)
//    If the user holds down buttons for more than half a second,
//    report buttons as being pressed up to 12 times per second thereafter.
//    If the user holds down buttons for less than half a second,
//    report only one button press.
// 3. Same as 2, but report no buttons as pressed if A or B is held down.
//    ([hJoy7] == 1, [hJoy6] == 0)
JoypadLowSensitivity::
	call Joypad
	ld a,[hJoy7] // flag
	and a // get all currently pressed buttons or only newly pressed buttons?
	ld a,[hJoyPressed] // newly pressed buttons
	jr z,.storeButtonState
	ld a,[hJoyHeld] // all currently pressed buttons
.storeButtonState
	ld [hJoy5],a
	ld a,[hJoyPressed] // newly pressed buttons
	and a // have any buttons been newly pressed since last check?
	jr z,.noNewlyPressedButtons
.newlyPressedButtons
	ld a,30 // half a second delay
	ld [H_FRAMECOUNTER],a
	ret
.noNewlyPressedButtons
	ld a,[H_FRAMECOUNTER]
	and a // is the delay over?
	jr z,.delayOver
.delayNotOver
	xor a
	ld [hJoy5],a // report no buttons as pressed
	ret
.delayOver
// if [hJoy6] = 0 and A or B is pressed, report no buttons as pressed
	ld a,[hJoyHeld]
	and A_BUTTON | B_BUTTON
	jr z,.setShortDelay
	ld a,[hJoy6] // flag
	and a
	jr nz,.setShortDelay
	xor a
	ld [hJoy5],a
.setShortDelay
	ld a,5 // 1/12 of a second delay
	ld [H_FRAMECOUNTER],a
	ret

WaitForTextScrollButtonPress::
	ld a, [H_DOWNARROWBLINKCNT1]
	push af
	ld a, [H_DOWNARROWBLINKCNT2]
	push af
	xor a
	ld [H_DOWNARROWBLINKCNT1], a
	ld a, $6
	ld [H_DOWNARROWBLINKCNT2], a
.loop
	push hl
	ld a, [wTownMapSpriteBlinkingEnabled]
	and a
	jr z, .skipAnimation
	call TownMapSpriteBlinkingAnimation
.skipAnimation
	coord hl, 18, 16
	call HandleDownArrowBlinkTiming
	pop hl
	call JoypadLowSensitivity
	predef CableClub_Run
	ld a, [hJoy5]
	and A_BUTTON | B_BUTTON
	jr z, .loop
	pop af
	ld [H_DOWNARROWBLINKCNT2], a
	pop af
	ld [H_DOWNARROWBLINKCNT1], a
	ret

// (unless in link battle) waits for A or B being pressed and outputs the scrolling sound effect
ManualTextScroll::
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .inLinkBattle
	call WaitForTextScrollButtonPress
	ld a, SFX_PRESS_AB
	PlaySound(a);
.inLinkBattle
	ld c, 65
	jp DelayFrames

// function to do multiplication
// all values are big endian
// INPUT
// FF96-FF98 =  multiplicand
// FF99 = multiplier
// OUTPUT
// FF95-FF98 = product
Multiply::
	push hl
	push bc
	callab _Multiply
	pop bc
	pop hl
	ret

// function to do division
// all values are big endian
// INPUT
// FF95-FF98 = dividend
// FF99 = divisor
// b = number of bytes in the dividend (starting from FF95)
// OUTPUT
// FF95-FF98 = quotient
// FF99 = remainder
Divide::
	push hl
	push de
	push bc
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,Bank(_Divide)
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	call _Divide
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	pop bc
	pop de
	pop hl
	ret

// This function is used to wait a short period after printing a letter to the
// screen unless the player presses the A/B button or the delay is turned off
// through the [wd730] or [wLetterPrintingDelayFlags] flags.
PrintLetterDelay::
	ld a,[wd730]
	bit 6,a
	ret nz
	ld a,[wLetterPrintingDelayFlags]
	bit 1,a
	ret z
	push hl
	push de
	push bc
	ld a,[wLetterPrintingDelayFlags]
	bit 0,a
	jr z,.waitOneFrame
	ld a,[wOptions]
	and $f
	ld [H_FRAMECOUNTER],a
	jr .checkButtons
.waitOneFrame
	ld a,1
	ld [H_FRAMECOUNTER],a
.checkButtons
	call Joypad
	ld a,[hJoyHeld]
.checkAButton
	bit 0,a // is the A button pressed?
	jr z,.checkBButton
	jr .endWait
.checkBButton
	bit 1,a // is the B button pressed?
	jr z,.buttonsNotPressed
.endWait
	call DelayFrame
	jr .done
.buttonsNotPressed // if neither A nor B is pressed
	ld a,[H_FRAMECOUNTER]
	and a
	jr nz,.checkButtons
.done
	pop bc
	pop de
	pop hl
	ret

// Copies [hl, bc) to [de, bc - hl).
// In other words, the source data is from hl up to but not including bc,
// and the destination is de.
CopyDataUntil::
	ld a,[hli]
	ld [de],a
	inc de
	ld a,h
	cp b
	jr nz,CopyDataUntil
	ld a,l
	cp c
	jr nz,CopyDataUntil
	ret

// Function to remove a pokemon from the party or the current box.
// wWhichPokemon determines the pokemon.
// [wRemoveMonFromBox] == 0 specifies the party.
// [wRemoveMonFromBox] != 0 specifies the current box.
RemovePokemon::
	jpab _RemovePokemon

AddPartyMon::
	push hl
	push de
	push bc
	callba _AddPartyMon
	pop bc
	pop de
	pop hl
	ret

// calculates all 5 stats of current mon and writes them to [de]
CalcStats::
	ld c, $0
.statsLoop
	inc c
	call CalcStat
	ld a, [H_MULTIPLICAND+1]
	ld [de], a
	inc de
	ld a, [H_MULTIPLICAND+2]
	ld [de], a
	inc de
	ld a, c
	cp NUM_STATS
	jr nz, .statsLoop
	ret

// calculates stat c of current mon
// c: stat to calc (HP=1,Atk=2,Def=3,Spd=4,Spc=5)
// b: consider stat exp?
// hl: base ptr to stat exp values ([hl + 2*c - 1] and [hl + 2*c])
CalcStat::
	push hl
	push de
	push bc
	ld a, b
	ld d, a
	push hl
	ld hl, wMonHeader
	ld b, $0
	add hl, bc
	ld a, [hl]          // read base value of stat
	ld e, a
	pop hl
	push hl
	sla c
	ld a, d
	and a
	jr z, .statExpDone  // consider stat exp?
	add hl, bc          // skip to corresponding stat exp value
.statExpLoop            // calculates ceil(Sqrt(stat exp)) in b
	xor a
	ld [H_MULTIPLICAND], a
	ld [H_MULTIPLICAND+1], a
	inc b               // increment current stat exp bonus
	ld a, b
	cp $ff
	jr z, .statExpDone
	ld [H_MULTIPLICAND+2], a
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, [hld]
	ld d, a
	ld a, [$ff98]
	sub d
	ld a, [hli]
	ld d, a
	ld a, [$ff97]
	sbc d               // test if (current stat exp bonus)^2 < stat exp
	jr c, .statExpLoop
.statExpDone
	srl c
	pop hl
	push bc
	ld bc, wPartyMon1DVs - (wPartyMon1HPExp - 1) // also wEnemyMonDVs - wEnemyMonHP
	add hl, bc
	pop bc
	ld a, c
	cp $2
	jr z, .getAttackIV
	cp $3
	jr z, .getDefenseIV
	cp $4
	jr z, .getSpeedIV
	cp $5
	jr z, .getSpecialIV
.getHpIV
	push bc
	ld a, [hl]  // Atk IV
	swap a
	and $1
	sla a
	sla a
	sla a
	ld b, a
	ld a, [hli] // Def IV
	and $1
	sla a
	sla a
	add b
	ld b, a
	ld a, [hl] // Spd IV
	swap a
	and $1
	sla a
	add b
	ld b, a
	ld a, [hl] // Spc IV
	and $1
	add b      // HP IV: LSB of the other 4 IVs
	pop bc
	jr .calcStatFromIV
.getAttackIV
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getDefenseIV
	ld a, [hl]
	and $f
	jr .calcStatFromIV
.getSpeedIV
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getSpecialIV
	inc hl
	ld a, [hl]
	and $f
.calcStatFromIV
	ld d, $0
	add e
	ld e, a
	jr nc, .noCarry
	inc d                     // de = Base + IV
.noCarry
	sla e
	rl d                      // de = (Base + IV) * 2
	srl b
	srl b                     // b = ceil(Sqrt(stat exp)) / 4
	ld a, b
	add e
	jr nc, .noCarry2
	inc d                     // de = (Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4
.noCarry2
	ld [H_MULTIPLICAND+2], a
	ld a, d
	ld [H_MULTIPLICAND+1], a
	xor a
	ld [H_MULTIPLICAND], a
	ld a, [wCurEnemyLVL]
	ld [H_MULTIPLIER], a
	call Multiply            // ((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level
	ld a, [H_MULTIPLICAND]
	ld [H_DIVIDEND], a
	ld a, [H_MULTIPLICAND+1]
	ld [H_DIVIDEND+1], a
	ld a, [H_MULTIPLICAND+2]
	ld [H_DIVIDEND+2], a
	ld a, $64
	ld [H_DIVISOR], a
	ld a, $3
	ld b, a
	call Divide             // (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100
	ld a, c
	cp $1
	ld a, 5 // + 5 for non-HP stat
	jr nz, .notHPStat
	ld a, [wCurEnemyLVL]
	ld b, a
	ld a, [H_MULTIPLICAND+2]
	add b
	ld [H_MULTIPLICAND+2], a
	jr nc, .noCarry3
	ld a, [H_MULTIPLICAND+1]
	inc a
	ld [H_MULTIPLICAND+1], a // HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level
.noCarry3
	ld a, 10 // +10 for HP stat
.notHPStat
	ld b, a
	ld a, [H_MULTIPLICAND+2]
	add b
	ld [H_MULTIPLICAND+2], a
	jr nc, .noCarry4
	ld a, [H_MULTIPLICAND+1]
	inc a                    // non-HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + 5
	ld [H_MULTIPLICAND+1], a // HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level + 10
.noCarry4
	ld a, [H_MULTIPLICAND+1] // check for overflow (>999)
	cp 999 / $100 + 1
	jr nc, .overflow
	cp 999 / $100
	jr c, .noOverflow
	ld a, [H_MULTIPLICAND+2]
	cp 999 % $100 + 1
	jr c, .noOverflow
.overflow
	ld a, 999 / $100               // overflow: cap at 999
	ld [H_MULTIPLICAND+1], a
	ld a, 999 % $100
	ld [H_MULTIPLICAND+2], a
.noOverflow
	pop bc
	pop de
	pop hl
	ret

AddEnemyMonToPlayerParty::
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(_AddEnemyMonToPlayerParty)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call _AddEnemyMonToPlayerParty
	pop bc
	ld a, b
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

MoveMon::
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(_MoveMon)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call _MoveMon
	pop bc
	ld a, b
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

// skips a text entries, each of size NAME_LENGTH (like trainer name, OT name, rival name, ...)
// hl: base pointer, will be incremented by NAME_LENGTH * a
SkipFixedLengthTextEntries::
	and a
	ret z
	ld bc, NAME_LENGTH
.skipLoop
	add hl, bc
	dec a
	jr nz, .skipLoop
	ret

AddNTimes::
// add bc to hl a times
	and a
	ret z
.loop
	add hl,bc
	dec a
	jr nz,.loop
	ret

// Compare strings, c bytes in length, at de and hl.
// Often used to compare big endian numbers in battle calculations.
StringCmp::
	ld a,[de]
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz,StringCmp
	ret

// INPUT:
// a = oam block index (each block is 4 oam entries)
// b = Y coordinate of upper left corner of sprite
// c = X coordinate of upper left corner of sprite
// de = base address of 4 tile number and attribute pairs
WriteOAMBlock::
	ld h,wOAMBuffer / $100
	swap a // multiply by 16
	ld l,a
	call .writeOneEntry // upper left
	push bc
	ld a,8
	add c
	ld c,a
	call .writeOneEntry // upper right
	pop bc
	ld a,8
	add b
	ld b,a
	call .writeOneEntry // lower left
	ld a,8
	add c
	ld c,a
	                      // lower right
.writeOneEntry
	ld [hl],b // Y coordinate
	inc hl
	ld [hl],c // X coordinate
	inc hl
	ld a,[de] // tile number
	inc de
	ld [hli],a
	ld a,[de] // attribute
	inc de
	ld [hli],a
	ret

HandleMenuInput::
	xor a
	ld [wPartyMenuAnimMonEnabled],a

HandleMenuInput_::
	ld a,[H_DOWNARROWBLINKCNT1]
	push af
	ld a,[H_DOWNARROWBLINKCNT2]
	push af // save existing values on stack
	xor a
	ld [H_DOWNARROWBLINKCNT1],a // blinking down arrow timing value 1
	ld a,6
	ld [H_DOWNARROWBLINKCNT2],a // blinking down arrow timing value 2
.loop1
	xor a
	ld [wAnimCounter],a // counter for pokemon shaking animation
	call PlaceMenuCursor
	call Delay3
.loop2
	push hl
	ld a,[wPartyMenuAnimMonEnabled]
	and a // is it a pokemon selection menu?
	jr z,.getJoypadState
	callba AnimatePartyMon // shake mini sprite of selected pokemon
.getJoypadState
	pop hl
	call JoypadLowSensitivity
	ld a,[hJoy5]
	and a // was a key pressed?
	jr nz,.keyPressed
	push hl
	coord hl, 18, 11 // coordinates of blinking down arrow in some menus
	call HandleDownArrowBlinkTiming // blink down arrow (if any)
	pop hl
	ld a,[wMenuJoypadPollCount]
	dec a
	jr z,.giveUpWaiting
	jr .loop2
.giveUpWaiting
// if a key wasn't pressed within the specified number of checks
	pop af
	ld [H_DOWNARROWBLINKCNT2],a
	pop af
	ld [H_DOWNARROWBLINKCNT1],a // restore previous values
	xor a
	ld [wMenuWrappingEnabled],a // disable menu wrapping
	ret
.keyPressed
	xor a
	ld [wCheckFor180DegreeTurn],a
	ld a,[hJoy5]
	ld b,a
	bit 6,a // pressed Up key?
	jr z,.checkIfDownPressed
.upPressed
	ld a,[wCurrentMenuItem] // selected menu item
	and a // already at the top of the menu?
	jr z,.alreadyAtTop
.notAtTop
	dec a
	ld [wCurrentMenuItem],a // move selected menu item up one space
	jr .checkOtherKeys
.alreadyAtTop
	ld a,[wMenuWrappingEnabled]
	and a // is wrapping around enabled?
	jr z,.noWrappingAround
	ld a,[wMaxMenuItem]
	ld [wCurrentMenuItem],a // wrap to the bottom of the menu
	jr .checkOtherKeys
.checkIfDownPressed
	bit 7,a
	jr z,.checkOtherKeys
.downPressed
	ld a,[wCurrentMenuItem]
	inc a
	ld c,a
	ld a,[wMaxMenuItem]
	cp c
	jr nc,.notAtBottom
.alreadyAtBottom
	ld a,[wMenuWrappingEnabled]
	and a // is wrapping around enabled?
	jr z,.noWrappingAround
	ld c,$00 // wrap from bottom to top
.notAtBottom
	ld a,c
	ld [wCurrentMenuItem],a
.checkOtherKeys
	ld a,[wMenuWatchedKeys]
	and b // does the menu care about any of the pressed keys?
	jp z,.loop1
.checkIfAButtonOrBButtonPressed
	ld a,[hJoy5]
	and A_BUTTON | B_BUTTON
	jr z,.skipPlayingSound
.AButtonOrBButtonPressed
	push hl
	ld hl,wFlags_0xcd60
	bit 5,[hl]
	pop hl
	jr nz,.skipPlayingSound
	ld a,SFX_PRESS_AB
	PlaySound(a);
.skipPlayingSound
	pop af
	ld [H_DOWNARROWBLINKCNT2],a
	pop af
	ld [H_DOWNARROWBLINKCNT1],a // restore previous values
	xor a
	ld [wMenuWrappingEnabled],a // disable menu wrapping
	ld a,[hJoy5]
	ret
.noWrappingAround
	ld a,[wMenuWatchMovingOutOfBounds]
	and a // should we return if the user tried to go past the top or bottom?
	jr z,.checkOtherKeys
	jr .checkIfAButtonOrBButtonPressed

PlaceMenuCursor::
	ld a,[wTopMenuItemY]
	and a // is the y coordinate 0?
	jr z,.adjustForXCoord
	coord hl, 0, 0
	ld bc,SCREEN_WIDTH
.topMenuItemLoop
	add hl,bc
	dec a
	jr nz,.topMenuItemLoop
.adjustForXCoord
	ld a,[wTopMenuItemX]
	ld b,0
	ld c,a
	add hl,bc
	push hl
	ld a,[wLastMenuItem]
	and a // was the previous menu id 0?
	jr z,.checkForArrow1
	push af
	ld a,[hFlags_0xFFF6]
	bit 1,a // is the menu double spaced?
	jr z,.doubleSpaced1
	ld bc,20
	jr .getOldMenuItemScreenPosition
.doubleSpaced1
	ld bc,40
.getOldMenuItemScreenPosition
	pop af
.oldMenuItemLoop
	add hl,bc
	dec a
	jr nz,.oldMenuItemLoop
.checkForArrow1
	ld a,[hl]
	cp a,"▶" // was an arrow next to the previously selected menu item?
	jr nz,.skipClearingArrow
.clearArrow
	ld a,[wTileBehindCursor]
	ld [hl],a
.skipClearingArrow
	pop hl
	ld a,[wCurrentMenuItem]
	and a
	jr z,.checkForArrow2
	push af
	ld a,[hFlags_0xFFF6]
	bit 1,a // is the menu double spaced?
	jr z,.doubleSpaced2
	ld bc,20
	jr .getCurrentMenuItemScreenPosition
.doubleSpaced2
	ld bc,40
.getCurrentMenuItemScreenPosition
	pop af
.currentMenuItemLoop
	add hl,bc
	dec a
	jr nz,.currentMenuItemLoop
.checkForArrow2
	ld a,[hl]
	cp "▶" // has the right arrow already been placed?
	jr z,.skipSavingTile // if so, don't lose the saved tile
	ld [wTileBehindCursor],a // save tile before overwriting with right arrow
.skipSavingTile
	ld a,"▶" // place right arrow
	ld [hl],a
	ld a,l
	ld [wMenuCursorLocation],a
	ld a,h
	ld [wMenuCursorLocation + 1],a
	ld a,[wCurrentMenuItem]
	ld [wLastMenuItem],a
	ret

// This is used to mark a menu cursor other than the one currently being
// manipulated. In the case of submenus, this is used to show the location of
// the menu cursor in the parent menu. In the case of swapping items in list,
// this is used to mark the item that was first chosen to be swapped.
PlaceUnfilledArrowMenuCursor::
	ld b,a
	ld a,[wMenuCursorLocation]
	ld l,a
	ld a,[wMenuCursorLocation + 1]
	ld h,a
	ld [hl],$ec // outline of right arrow
	ld a,b
	ret

// Replaces the menu cursor with a blank space.
EraseMenuCursor::
	ld a,[wMenuCursorLocation]
	ld l,a
	ld a,[wMenuCursorLocation + 1]
	ld h,a
	ld [hl]," "
	ret

// This toggles a blinking down arrow at hl on and off after a delay has passed.
// This is often called even when no blinking is occurring.
// The reason is that most functions that call this initialize H_DOWNARROWBLINKCNT1 to 0.
// The effect is that if the tile at hl is initialized with a down arrow,
// this function will toggle that down arrow on and off, but if the tile isn't
// initialized with a down arrow, this function does nothing.
// That allows this to be called without worrying about if a down arrow should
// be blinking.
HandleDownArrowBlinkTiming::
	ld a,[hl]
	ld b,a
	ld a,"▼"
	cp b
	jr nz,.downArrowOff
.downArrowOn
	ld a,[H_DOWNARROWBLINKCNT1]
	dec a
	ld [H_DOWNARROWBLINKCNT1],a
	ret nz
	ld a,[H_DOWNARROWBLINKCNT2]
	dec a
	ld [H_DOWNARROWBLINKCNT2],a
	ret nz
	ld a," "
	ld [hl],a
	ld a,$ff
	ld [H_DOWNARROWBLINKCNT1],a
	ld a,$06
	ld [H_DOWNARROWBLINKCNT2],a
	ret
.downArrowOff
	ld a,[H_DOWNARROWBLINKCNT1]
	and a
	ret z
	dec a
	ld [H_DOWNARROWBLINKCNT1],a
	ret nz
	dec a
	ld [H_DOWNARROWBLINKCNT1],a
	ld a,[H_DOWNARROWBLINKCNT2]
	dec a
	ld [H_DOWNARROWBLINKCNT2],a
	ret nz
	ld a,$06
	ld [H_DOWNARROWBLINKCNT2],a
	ld a,"▼"
	ld [hl],a
	ret

// The following code either enables or disables the automatic drawing of
// text boxes by DisplayTextID. Both functions cause DisplayTextID to wait
// for a button press after displaying text (unless [wEnteringCableClub] is set).

EnableAutoTextBoxDrawing::
	xor a
	jr AutoTextBoxDrawingCommon

DisableAutoTextBoxDrawing::
	ld a,$01

AutoTextBoxDrawingCommon::
	ld [wAutoTextBoxDrawingControl],a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText],a // make DisplayTextID wait for button press
	ret

PrintText::
// Print text hl at (1, 14).
	push hl
	ld a,MESSAGE_BOX
	ld [wTextBoxID],a
	call DisplayTextBoxID
	call UpdateSprites
	call Delay3
	pop hl
PrintText_NoCreatingTextBox::
	coord bc, 1, 14
	jp TextCommandProcessor


PrintNumber::
// Print the c-digit, b-byte value at de.
// Allows 2 to 7 digits. For 1-digit numbers, add
// the value to char "0" instead of calling PrintNumber.
// Flags LEADING_ZEROES and LEFT_ALIGN can be given
// in bits 7 and 6 of b respectively.
	push bc
	xor a
	ld [H_PASTLEADINGZEROES], a
	ld [H_NUMTOPRINT], a
	ld [H_NUMTOPRINT + 1], a
	ld a, b
	and $f
	cp 1
	jr z, .byte
	cp 2
	jr z, .word
.long
	ld a, [de]
	ld [H_NUMTOPRINT], a
	inc de
	ld a, [de]
	ld [H_NUMTOPRINT + 1], a
	inc de
	ld a, [de]
	ld [H_NUMTOPRINT + 2], a
	jr .start

.word
	ld a, [de]
	ld [H_NUMTOPRINT + 1], a
	inc de
	ld a, [de]
	ld [H_NUMTOPRINT + 2], a
	jr .start

.byte
	ld a, [de]
	ld [H_NUMTOPRINT + 2], a

.start
	push de

	ld d, b
	ld a, c
	ld b, a
	xor a
	ld c, a
	ld a, b

	cp 2
	jr z, .tens
	cp 3
	jr z, .hundreds
	cp 4
	jr z, .thousands
	cp 5
	jr z, .ten_thousands
	cp 6
	jr z, .hundred_thousands

print_digit: macro

if (\1) / $10000
	ld a, \1 / $10000 % $100
else	xor a
endc
	ld [H_POWEROFTEN + 0], a

if (\1) / $100
	ld a, \1 / $100   % $100
else	xor a
endc
	ld [H_POWEROFTEN + 1], a

	ld a, \1 / $1     % $100
	ld [H_POWEROFTEN + 2], a

	call .PrintDigit
	call .NextDigit
endm

.millions          print_digit 1000000
.hundred_thousands print_digit 100000
.ten_thousands     print_digit 10000
.thousands         print_digit 1000
.hundreds          print_digit 100

.tens
	ld c, 0
	ld a, [H_NUMTOPRINT + 2]
.mod
	cp 10
	jr c, .ok
	sub 10
	inc c
	jr .mod
.ok

	ld b, a
	ld a, [H_PASTLEADINGZEROES]
	or c
	ld [H_PASTLEADINGZEROES], a
	jr nz, .past
	call .PrintLeadingZero
	jr .next
.past
	ld a, "0"
	add c
	ld [hl], a
.next

	call .NextDigit
.ones
	ld a, "0"
	add b
	ld [hli], a
	pop de
	dec de
	pop bc
	ret

.PrintDigit:
// Divide by the current decimal place.
// Print the quotient, and keep the modulus.
	ld c, 0
.loop
	ld a, [H_POWEROFTEN]
	ld b, a
	ld a, [H_NUMTOPRINT]
	ld [H_SAVEDNUMTOPRINT], a
	cp b
	jr c, .underflow0
	sub b
	ld [H_NUMTOPRINT], a
	ld a, [H_POWEROFTEN + 1]
	ld b, a
	ld a, [H_NUMTOPRINT + 1]
	ld [H_SAVEDNUMTOPRINT + 1], a
	cp b
	jr nc, .noborrow1

	ld a, [H_NUMTOPRINT]
	or 0
	jr z, .underflow1
	dec a
	ld [H_NUMTOPRINT], a
	ld a, [H_NUMTOPRINT + 1]
.noborrow1

	sub b
	ld [H_NUMTOPRINT + 1], a
	ld a, [H_POWEROFTEN + 2]
	ld b, a
	ld a, [H_NUMTOPRINT + 2]
	ld [H_SAVEDNUMTOPRINT + 2], a
	cp b
	jr nc, .noborrow2

	ld a, [H_NUMTOPRINT + 1]
	and a
	jr nz, .borrowed

	ld a, [H_NUMTOPRINT]
	and a
	jr z, .underflow2
	dec a
	ld [H_NUMTOPRINT], a
	xor a
.borrowed

	dec a
	ld [H_NUMTOPRINT + 1], a
	ld a, [H_NUMTOPRINT + 2]
.noborrow2
	sub b
	ld [H_NUMTOPRINT + 2], a
	inc c
	jr .loop

.underflow2
	ld a, [H_SAVEDNUMTOPRINT + 1]
	ld [H_NUMTOPRINT + 1], a
.underflow1
	ld a, [H_SAVEDNUMTOPRINT]
	ld [H_NUMTOPRINT], a
.underflow0
	ld a, [H_PASTLEADINGZEROES]
	or c
	jr z, .PrintLeadingZero

	ld a, "0"
	add c
	ld [hl], a
	ld [H_PASTLEADINGZEROES], a
	ret

.PrintLeadingZero:
	bit BIT_LEADING_ZEROES, d
	ret z
	ld [hl], "0"
	ret

.NextDigit:
// Increment unless the number is left-aligned,
// leading zeroes are not printed, and no digits
// have been printed yet.
	bit BIT_LEADING_ZEROES, d
	jr nz, .inc
	bit BIT_LEFT_ALIGN, d
	jr z, .inc
	ld a, [H_PASTLEADINGZEROES]
	and a
	ret z
.inc
	inc hl
	ret


CallFunctionInTable::
// Call function a in jumptable hl.
// de is not preserved.
	push hl
	push de
	push bc
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, .returnAddress
	push de
	jp hl
.returnAddress
	pop bc
	pop de
	pop hl
	ret


IsInArray::
// Search an array at hl for the value in a.
// Entry size is de bytes.
// Return count b and carry if found.
	ld b, 0

IsInRestOfArray::
	ld c, a
.loop
	ld a, [hl]
	cp -1
	jr z, .notfound
	cp c
	jr z, .found
	inc b
	add hl, de
	jr .loop

.notfound
	and a
	ret

.found
	scf
	ret


RestoreScreenTilesAndReloadTilePatterns::
	call ClearSprites
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	call ReloadMapSpriteTilePatterns
	call LoadScreenTilesFromBuffer2
	call LoadTextBoxTilePatterns
	call RunDefaultPaletteCommand
	jr Delay3


GBPalWhiteOutWithDelay3::
	call GBPalWhiteOut

Delay3::
// The bg map is updated each frame in thirds.
// Wait three frames to let the bg map fully update.
	ld c, 3
	jp DelayFrames

GBPalNormal::
// Reset BGP and OBP0.
	ld a, %11100100 // 3210
	ld [rBGP], a
	ld a, %11010000 // 3100
	ld [rOBP0], a
	ret

GBPalWhiteOut::
// White out all palettes.
	xor a
	ld [rBGP],a
	ld [rOBP0],a
	ld [rOBP1],a
	ret


RunDefaultPaletteCommand::
	ld b,$ff
RunPaletteCommand::
	ld a,[wOnSGB]
	and a
	ret z
	predef_jump _RunPaletteCommand

GetHealthBarColor::
// Return at hl the palette of
// an HP bar e pixels long.
	ld a, e
	cp 27
	ld d, 0 // green
	jr nc, .gotColor
	cp 10
	inc d // yellow
	jr nc, .gotColor
	inc d // red
.gotColor
	ld [hl], d
	ret

// Copy the current map's sprites' tile patterns to VRAM again after they have
// been overwritten by other tile patterns.
ReloadMapSpriteTilePatterns::
	ld hl, wFontLoaded
	ld a, [hl]
	push af
	res 0, [hl]
	push hl
	xor a
	ld [wSpriteSetID], a
	DisableLCD()
	callba InitMapSprites
	EnableLCD()
	pop hl
	pop af
	ld [hl], a
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	jp UpdateSprites


GiveItem::
// Give player quantity c of item b,
// and copy the item's name to wcf4b.
// Return carry on success.
	ld a, b
	ld [wd11e], a
	ld [wcf91], a
	ld a, c
	ld [wItemQuantity], a
	ld hl,wNumBagItems
	call AddItemToInventory
	ret nc
	call GetItemName
	call CopyStringToCF4B
	scf
	ret

void GivePokemon(b, c)
// Give the player monster b at level c.
	ld a, b
	ld [wcf91], a
	ld a, c
	ld [wCurEnemyLVL], a
	xor a // PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	jpba _GivePokemon


void Random(){
// Return a random number in a.
// For battles, use BattleRandom.
	push hl
	push de
	push bc
	callba Random_
	ld a, [hRandomAdd]
	pop bc
	pop de
	pop hl
	ret
}

#include "home/predef.asm"


UpdateCinnabarGymGateTileBlocks::
	jpba UpdateCinnabarGymGateTileBlocks_

CheckForHiddenObjectOrBookshelfOrCardKeyDoor::
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [hJoyHeld]
	bit 0, a // A button
	jr z, .nothingFound
// A button is pressed
	ld a, Bank(CheckForHiddenObject)
	ld [MBC1RomBank], a
	ld [H_LOADEDROMBANK], a
	call CheckForHiddenObject
	ld a, [$ffee]
	and a
	jr nz, .hiddenObjectNotFound
	ld a, [wHiddenObjectFunctionRomBank]
	ld [MBC1RomBank], a
	ld [H_LOADEDROMBANK], a
	ld de, .returnAddress
	push de
	jp hl
.returnAddress
	xor a
	jr .done
.hiddenObjectNotFound
	callba PrintBookshelfText
	ld a, [$ffdb]
	and a
	jr z, .done
.nothingFound
	ld a, $ff
.done
	ld [$ffeb], a
	pop af
	ld [MBC1RomBank], a
	ld [H_LOADEDROMBANK], a
	ret

PrintPredefTextID::
	ld [hSpriteIndexOrTextID], a
	ld hl, TextPredefs
	call SetMapTextPointer
	ld hl, wTextPredefFlag
	set 0, [hl]
	call DisplayTextID

RestoreMapTextPointer::
	ld hl, wMapTextPtr
	ld a, [$ffec]
	ld [hli], a
	ld a, [$ffec + 1]
	ld [hl], a
	ret

SetMapTextPointer::
	ld a, [wMapTextPtr]
	ld [$ffec], a
	ld a, [wMapTextPtr + 1]
	ld [$ffec + 1], a
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr + 1], a
	ret

TextPredefs::
const_value = 1

	add_tx_pre CardKeySuccessText                   // 01
	add_tx_pre CardKeyFailText                      // 02
	add_tx_pre RedBedroomPCText                     // 03
	add_tx_pre RedBedroomSNESText                   // 04
	add_tx_pre PushStartText                        // 05
	add_tx_pre SaveOptionText                       // 06
	add_tx_pre StrengthsAndWeaknessesText           // 07
	add_tx_pre OakLabEmailText                      // 08
	add_tx_pre AerodactylFossilText                 // 09
	add_tx_pre Route15UpstairsBinocularsText        // 0A
	add_tx_pre KabutopsFossilText                   // 0B
	add_tx_pre GymStatueText1                       // 0C
	add_tx_pre GymStatueText2                       // 0D
	add_tx_pre BookcaseText                         // 0E
	add_tx_pre ViridianCityPokecenterBenchGuyText   // 0F
	add_tx_pre PewterCityPokecenterBenchGuyText     // 10
	add_tx_pre CeruleanCityPokecenterBenchGuyText   // 11
	add_tx_pre LavenderCityPokecenterBenchGuyText   // 12
	add_tx_pre VermilionCityPokecenterBenchGuyText  // 13
	add_tx_pre CeladonCityPokecenterBenchGuyText    // 14
	add_tx_pre CeladonCityHotelText                 // 15
	add_tx_pre FuchsiaCityPokecenterBenchGuyText    // 16
	add_tx_pre CinnabarIslandPokecenterBenchGuyText // 17
	add_tx_pre SaffronCityPokecenterBenchGuyText    // 18
	add_tx_pre MtMoonPokecenterBenchGuyText         // 19
	add_tx_pre RockTunnelPokecenterBenchGuyText     // 1A
	add_tx_pre UnusedBenchGuyText1                  // 1B XXX unused
	add_tx_pre UnusedBenchGuyText2                  // 1C XXX unused
	add_tx_pre UnusedBenchGuyText3                  // 1D XXX unused
	add_tx_pre UnusedPredefText                     // 1E XXX unused
	add_tx_pre PokemonCenterPCText                  // 1F
	add_tx_pre ViridianSchoolNotebook               // 20
	add_tx_pre ViridianSchoolBlackboard             // 21
	add_tx_pre JustAMomentText                      // 22
	add_tx_pre OpenBillsPCText                      // 23
	add_tx_pre FoundHiddenItemText                  // 24
	add_tx_pre HiddenItemBagFullText                // 25 XXX unused
	add_tx_pre VermilionGymTrashText                // 26
	add_tx_pre IndigoPlateauHQText                  // 27
	add_tx_pre GameCornerOutOfOrderText             // 28
	add_tx_pre GameCornerOutToLunchText             // 29
	add_tx_pre GameCornerSomeonesKeysText           // 2A
	add_tx_pre FoundHiddenCoinsText                 // 2B
	add_tx_pre DroppedHiddenCoinsText               // 2C
	add_tx_pre BillsHouseMonitorText                // 2D
	add_tx_pre BillsHouseInitiatedText              // 2E
	add_tx_pre BillsHousePokemonList                // 2F
	add_tx_pre MagazinesText                        // 30
	add_tx_pre CinnabarGymQuiz                      // 31
	add_tx_pre GameCornerNoCoinsText                // 32
	add_tx_pre GameCornerCoinCaseText               // 33
	add_tx_pre LinkCableHelp                        // 34
	add_tx_pre TMNotebook                           // 35
	add_tx_pre FightingDojoText                     // 36
	add_tx_pre EnemiesOnEverySideText               // 37
	add_tx_pre WhatGoesAroundComesAroundText        // 38
	add_tx_pre NewBicycleText                       // 39
	add_tx_pre IndigoPlateauStatues                 // 3A
	add_tx_pre VermilionGymTrashSuccessText1        // 3B
	add_tx_pre VermilionGymTrashSuccessText2        // 3C XXX unused
	add_tx_pre VermilionGymTrashSuccessText3        // 3D
	add_tx_pre VermilionGymTrashFailText            // 3E
	add_tx_pre TownMapText                          // 3F
	add_tx_pre BookOrSculptureText                  // 40
	add_tx_pre ElevatorText                         // 41
	add_tx_pre PokemonStuffText                     // 42
