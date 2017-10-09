SilphCo8Object:
	db $2e // border block

	db $7 // warps
	db $0, $10, $1, SILPH_CO_9F
	db $0, $e, $0, SILPH_CO_7F
	db $0, $12, $0, SILPH_CO_ELEVATOR
	db $b, $3, $6, SILPH_CO_8F
	db $f, $3, $4, SILPH_CO_2F
	db $5, $b, $5, SILPH_CO_2F
	db $9, $b, $3, SILPH_CO_8F

	db $0 // signs

	db $4 // objects
	object SPRITE_LAPRAS_GIVER, $4, $2, STAY, NONE, $1 // person
	object SPRITE_ROCKET, $13, $2, STAY, LEFT, $2, OPP_ROCKET, $23
	object SPRITE_OAK_AIDE, $a, $2, STAY, DOWN, $3, OPP_SCIENTIST, $9
	object SPRITE_ROCKET, $c, $f, STAY, RIGHT, $4, OPP_ROCKET, $24

	// warp-to
	EVENT_DISP SILPH_CO_8F_WIDTH, $0, $10 // SILPH_CO_9F
	EVENT_DISP SILPH_CO_8F_WIDTH, $0, $e // SILPH_CO_7F
	EVENT_DISP SILPH_CO_8F_WIDTH, $0, $12 // SILPH_CO_ELEVATOR
	EVENT_DISP SILPH_CO_8F_WIDTH, $b, $3 // SILPH_CO_8F
	EVENT_DISP SILPH_CO_8F_WIDTH, $f, $3 // SILPH_CO_2F
	EVENT_DISP SILPH_CO_8F_WIDTH, $5, $b // SILPH_CO_2F
	EVENT_DISP SILPH_CO_8F_WIDTH, $9, $b // SILPH_CO_8F_WIDTH
