LoreleiObject:
	db $3 // border block

	db $4 // warps
	db $b, $4, $2, INDIGO_PLATEAU_LOBBY
	db $b, $5, $2, INDIGO_PLATEAU_LOBBY
	db $0, $4, $0, BRUNOS_ROOM
	db $0, $5, $1, BRUNOS_ROOM

	db $0 // signs

	db $1 // objects
	object SPRITE_LORELEI, $5, $2, STAY, DOWN, $1, OPP_LORELEI, $1

	// warp-to
	EVENT_DISP LORELEIS_ROOM_WIDTH, $b, $4 // INDIGO_PLATEAU_LOBBY
	EVENT_DISP LORELEIS_ROOM_WIDTH, $b, $5 // INDIGO_PLATEAU_LOBBY
	EVENT_DISP LORELEIS_ROOM_WIDTH, $0, $4 // BRUNOS_ROOM
	EVENT_DISP LORELEIS_ROOM_WIDTH, $0, $5 // BRUNOS_ROOM
