CeladonMansion2Object:
	db $f // border block

	db $4 // warps
	db $1, $6, $0, CELADON_MANSION_3
	db $1, $7, $3, CELADON_MANSION_1
	db $1, $2, $4, CELADON_MANSION_1
	db $1, $4, $3, CELADON_MANSION_3

	db $1 // signs
	db $9, $4, $1 // CeladonMansion2Text1

	db $0 // objects

	// warp-to
	EVENT_DISP CELADON_MANSION_2_WIDTH, $1, $6 // CELADON_MANSION_3
	EVENT_DISP CELADON_MANSION_2_WIDTH, $1, $7 // CELADON_MANSION_1
	EVENT_DISP CELADON_MANSION_2_WIDTH, $1, $2 // CELADON_MANSION_1
	EVENT_DISP CELADON_MANSION_2_WIDTH, $1, $4 // CELADON_MANSION_3
