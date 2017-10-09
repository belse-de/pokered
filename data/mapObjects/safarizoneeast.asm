SafariZoneEastObject:
	db $0 // border block

	db $5 // warps
	db $4, $0, $6, SAFARI_ZONE_NORTH
	db $5, $0, $7, SAFARI_ZONE_NORTH
	db $16, $0, $6, SAFARI_ZONE_CENTER
	db $17, $0, $6, SAFARI_ZONE_CENTER
	db $9, $19, $0, SAFARI_ZONE_REST_HOUSE_3

	db $3 // signs
	db $a, $1a, $5 // SafariZoneEastText5
	db $4, $6, $6 // SafariZoneEastText6
	db $17, $5, $7 // SafariZoneEastText7

	db $4 // objects
	object SPRITE_BALL, $15, $a, STAY, NONE, $1, FULL_RESTORE
	object SPRITE_BALL, $3, $7, STAY, NONE, $2, MAX_POTION
	object SPRITE_BALL, $14, $d, STAY, NONE, $3, CARBOS
	object SPRITE_BALL, $f, $c, STAY, NONE, $4, TM_37

	// warp-to
	EVENT_DISP SAFARI_ZONE_EAST_WIDTH, $4, $0 // SAFARI_ZONE_NORTH
	EVENT_DISP SAFARI_ZONE_EAST_WIDTH, $5, $0 // SAFARI_ZONE_NORTH
	EVENT_DISP SAFARI_ZONE_EAST_WIDTH, $16, $0 // SAFARI_ZONE_CENTER
	EVENT_DISP SAFARI_ZONE_EAST_WIDTH, $17, $0 // SAFARI_ZONE_CENTER
	EVENT_DISP SAFARI_ZONE_EAST_WIDTH, $9, $19 // SAFARI_ZONE_REST_HOUSE_3
