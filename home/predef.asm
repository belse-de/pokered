Predef::
// Call predefined function a.
// To preserve other registers, have the
// destination GetPredefRegisters();.

	// Save the predef id for GetPredefPointer.
	ld [wPredefID], a

	// A hack for LoadDestinationWarpPosition.
	// See LoadTilesetHeader (predef $19).
	ld a, [H_LOADEDROMBANK]
	ld [wPredefParentBank], a

	push af
	ld a, BANK(GetPredefPointer)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a

	call GetPredefPointer

	ld a, [wPredefBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a

	ld de, .done
	push de
	jp hl
.done

	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ret

void GetPredefRegisters(){
// Restore the contents of register pairs
// when GetPredefPointer was called.
	h = wPredefRegisters[0];
	l = wPredefRegisters[1];
	d = wPredefRegisters[2];
	e = wPredefRegisters[3];
	b = wPredefRegisters[4];
	c = wPredefRegisters[5];
}
