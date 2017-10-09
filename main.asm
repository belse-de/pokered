#include "constants.asm"

NPC_SPRITES_1 EQU $4
NPC_SPRITES_2 EQU $5

GFX EQU $4

PICS_1 EQU $9
PICS_2 EQU $A
PICS_3 EQU $B
PICS_4 EQU $C
PICS_5 EQU $D

#include "home.asm"


SECTION "bank1",ROMX,BANK[$1]

#include "data/facing.asm"

#include "engine/black_out.asm"

MewPicFront:: INCBIN "pic/bmon/mew.pic"
MewPicBack::  INCBIN "pic/monback/mewb.pic"
#include "data/baseStats/mew.asm"

#include "engine/battle/safari_zone.asm"

#include "engine/titlescreen.asm"
#include "engine/load_mon_data.asm"

#include "data/item_prices.asm"
#include "text/item_names.asm"
#include "text/unused_names.asm"

#include "engine/overworld/oam.asm"
#include "engine/oam_dma.asm"

#include "engine/print_waiting_text.asm"

#include "engine/overworld/map_sprite_functions1.asm"

#include "engine/test_battle.asm"

#include "engine/overworld/item.asm"
#include "engine/overworld/movement.asm"

#include "engine/cable_club.asm"

#include "engine/menu/main_menu.asm"

#include "engine/oak_speech.asm"

#include "engine/special_warps.asm"

#include "engine/debug1.asm"

#include "engine/menu/naming_screen.asm"

#include "engine/oak_speech2.asm"

#include "engine/subtract_paid_money.asm"

#include "engine/menu/swap_items.asm"

#include "engine/overworld/pokemart.asm"

#include "engine/learn_move.asm"

#include "engine/overworld/pokecenter.asm"

#include "engine/overworld/set_blackout_map.asm"

#include "engine/display_text_id_init.asm"
#include "engine/menu/draw_start_menu.asm"

#include "engine/overworld/cable_club_npc.asm"

#include "engine/menu/text_box.asm"

#include "engine/battle/moveEffects/drain_hp_effect.asm"

#include "engine/menu/players_pc.asm"

#include "engine/remove_pokemon.asm"

#include "engine/display_pokedex.asm"

SECTION "bank3",ROMX,BANK[$3]

#include "engine/joypad.asm"

#include "data/map_songs.asm"

#include "data/map_header_banks.asm"

#include "engine/overworld/clear_variables.asm"
#include "engine/overworld/player_state.asm"
#include "engine/overworld/poison.asm"
#include "engine/overworld/tileset_header.asm"
#include "engine/overworld/daycare_exp.asm"

#include "data/hide_show_data.asm"

#include "engine/overworld/field_move_messages.asm"

#include "engine/items/inventory.asm"

#include "engine/overworld/wild_mons.asm"

#include "engine/items/items.asm"

#include "engine/menu/draw_badges.asm"

#include "engine/overworld/update_map.asm"
#include "engine/overworld/cut.asm"
#include "engine/overworld/missable_objects.asm"
#include "engine/overworld/push_boulder.asm"

#include "engine/add_mon.asm"
#include "engine/flag_action.asm"
#include "engine/heal_party.asm"
#include "engine/bcd.asm"
#include "engine/init_player_data.asm"
#include "engine/get_bag_item_quantity.asm"
#include "engine/pathfinding.asm"
#include "engine/hp_bar.asm"
#include "engine/hidden_object_functions3.asm"

SECTION "NPC Sprites 1", ROMX, BANK[NPC_SPRITES_1]

OakAideSprite:         INCBIN "gfx/sprites/oak_aide.2bpp"
RockerSprite:          INCBIN "gfx/sprites/rocker.2bpp"
SwimmerSprite:         INCBIN "gfx/sprites/swimmer.2bpp"
WhitePlayerSprite:     INCBIN "gfx/sprites/white_player.2bpp"
GymHelperSprite:       INCBIN "gfx/sprites/gym_helper.2bpp"
OldPersonSprite:       INCBIN "gfx/sprites/old_person.2bpp"
MartGuySprite:         INCBIN "gfx/sprites/mart_guy.2bpp"
FisherSprite:          INCBIN "gfx/sprites/fisher.2bpp"
OldMediumWomanSprite:  INCBIN "gfx/sprites/old_medium_woman.2bpp"
NurseSprite:           INCBIN "gfx/sprites/nurse.2bpp"
CableClubWomanSprite:  INCBIN "gfx/sprites/cable_club_woman.2bpp"
MrMasterballSprite:    INCBIN "gfx/sprites/mr_masterball.2bpp"
LaprasGiverSprite:     INCBIN "gfx/sprites/lapras_giver.2bpp"
WardenSprite:          INCBIN "gfx/sprites/warden.2bpp"
SsCaptainSprite:       INCBIN "gfx/sprites/ss_captain.2bpp"
Fisher2Sprite:         INCBIN "gfx/sprites/fisher2.2bpp"
BlackbeltSprite:       INCBIN "gfx/sprites/blackbelt.2bpp"
GuardSprite:           INCBIN "gfx/sprites/guard.2bpp"
BallSprite:            INCBIN "gfx/sprites/ball.2bpp"
OmanyteSprite:         INCBIN "gfx/sprites/omanyte.2bpp"
BoulderSprite:         INCBIN "gfx/sprites/boulder.2bpp"
PaperSheetSprite:      INCBIN "gfx/sprites/paper_sheet.2bpp"
BookMapDexSprite:      INCBIN "gfx/sprites/book_map_dex.2bpp"
ClipboardSprite:       INCBIN "gfx/sprites/clipboard.2bpp"
SnorlaxSprite:         INCBIN "gfx/sprites/snorlax.2bpp"
OldAmberSprite:        INCBIN "gfx/sprites/old_amber.2bpp"
LyingOldManSprite:     INCBIN "gfx/sprites/lying_old_man.2bpp"


SECTION "Graphics", ROMX, BANK[GFX]

PokemonLogoGraphics:            INCBIN "gfx/pokemon_logo.2bpp"
FontGraphics:                   INCBIN "gfx/font.1bpp"
FontGraphicsEnd:
ABTiles:                        INCBIN "gfx/AB.2bpp"
HpBarAndStatusGraphics:         INCBIN "gfx/hp_bar_and_status.2bpp"
HpBarAndStatusGraphicsEnd:
BattleHudTiles1:                INCBIN "gfx/battle_hud1.1bpp"
BattleHudTiles1End:
BattleHudTiles2:                INCBIN "gfx/battle_hud2.1bpp"
BattleHudTiles3:                INCBIN "gfx/battle_hud3.1bpp"
BattleHudTiles3End:
NintendoCopyrightLogoGraphics:  INCBIN "gfx/copyright.2bpp"
GamefreakLogoGraphics:          INCBIN "gfx/gamefreak.2bpp"
GamefreakLogoGraphicsEnd:
TextBoxGraphics:                INCBIN "gfx/text_box.2bpp"
TextBoxGraphicsEnd:
PokedexTileGraphics:            INCBIN "gfx/pokedex.2bpp"
PokedexTileGraphicsEnd:
WorldMapTileGraphics:           INCBIN "gfx/town_map.2bpp"
WorldMapTileGraphicsEnd:
PlayerCharacterTitleGraphics:   INCBIN "gfx/player_title.2bpp"
PlayerCharacterTitleGraphicsEnd:


SECTION "Battle (bank 4)", ROMX, BANK[$4]

#include "engine/overworld/is_player_just_outside_map.asm"
#include "engine/menu/status_screen.asm"
#include "engine/menu/party_menu.asm"

RedPicFront:: INCBIN "pic/trainer/red.pic"
ShrinkPic1::  INCBIN "pic/trainer/shrink1.pic"
ShrinkPic2::  INCBIN "pic/trainer/shrink2.pic"

#include "engine/turn_sprite.asm"
#include "engine/menu/start_sub_menus.asm"
#include "engine/items/tms.asm"
#include "engine/battle/end_of_battle.asm"
#include "engine/battle/wild_encounters.asm"
#include "engine/battle/moveEffects/recoil_effect.asm"
#include "engine/battle/moveEffects/conversion_effect.asm"
#include "engine/battle/moveEffects/haze_effect.asm"
#include "engine/battle/get_trainer_name.asm"
#include "engine/random.asm"


SECTION "NPC Sprites 2", ROMX, BANK[NPC_SPRITES_2]

RedCyclingSprite:     INCBIN "gfx/sprites/cycling.2bpp"
RedSprite:            INCBIN "gfx/sprites/red.2bpp"
BlueSprite:           INCBIN "gfx/sprites/blue.2bpp"
OakSprite:            INCBIN "gfx/sprites/oak.2bpp"
BugCatcherSprite:     INCBIN "gfx/sprites/bug_catcher.2bpp"
SlowbroSprite:        INCBIN "gfx/sprites/slowbro.2bpp"
LassSprite:           INCBIN "gfx/sprites/lass.2bpp"
BlackHairBoy1Sprite:  INCBIN "gfx/sprites/black_hair_boy_1.2bpp"
LittleGirlSprite:     INCBIN "gfx/sprites/little_girl.2bpp"
BirdSprite:           INCBIN "gfx/sprites/bird.2bpp"
FatBaldGuySprite:     INCBIN "gfx/sprites/fat_bald_guy.2bpp"
GamblerSprite:        INCBIN "gfx/sprites/gambler.2bpp"
BlackHairBoy2Sprite:  INCBIN "gfx/sprites/black_hair_boy_2.2bpp"
GirlSprite:           INCBIN "gfx/sprites/girl.2bpp"
HikerSprite:          INCBIN "gfx/sprites/hiker.2bpp"
FoulardWomanSprite:   INCBIN "gfx/sprites/foulard_woman.2bpp"
GentlemanSprite:      INCBIN "gfx/sprites/gentleman.2bpp"
DaisySprite:          INCBIN "gfx/sprites/daisy.2bpp"
BikerSprite:          INCBIN "gfx/sprites/biker.2bpp"
SailorSprite:         INCBIN "gfx/sprites/sailor.2bpp"
CookSprite:           INCBIN "gfx/sprites/cook.2bpp"
BikeShopGuySprite:    INCBIN "gfx/sprites/bike_shop_guy.2bpp"
MrFujiSprite:         INCBIN "gfx/sprites/mr_fuji.2bpp"
GiovanniSprite:       INCBIN "gfx/sprites/giovanni.2bpp"
RocketSprite:         INCBIN "gfx/sprites/rocket.2bpp"
MediumSprite:         INCBIN "gfx/sprites/medium.2bpp"
WaiterSprite:         INCBIN "gfx/sprites/waiter.2bpp"
ErikaSprite:          INCBIN "gfx/sprites/erika.2bpp"
MomGeishaSprite:      INCBIN "gfx/sprites/mom_geisha.2bpp"
BrunetteGirlSprite:   INCBIN "gfx/sprites/brunette_girl.2bpp"
LanceSprite:          INCBIN "gfx/sprites/lance.2bpp"
MomSprite:            INCBIN "gfx/sprites/mom.2bpp"
BaldingGuySprite:     INCBIN "gfx/sprites/balding_guy.2bpp"
YoungBoySprite:       INCBIN "gfx/sprites/young_boy.2bpp"
GameboyKidSprite:     INCBIN "gfx/sprites/gameboy_kid.2bpp"
ClefairySprite:       INCBIN "gfx/sprites/clefairy.2bpp"
AgathaSprite:         INCBIN "gfx/sprites/agatha.2bpp"
BrunoSprite:          INCBIN "gfx/sprites/bruno.2bpp"
LoreleiSprite:        INCBIN "gfx/sprites/lorelei.2bpp"
SeelSprite:           INCBIN "gfx/sprites/seel.2bpp"


SECTION "Battle (bank 5)", ROMX, BANK[$5]

#include "engine/load_pokedex_tiles.asm"
#include "engine/overworld/map_sprites.asm"
#include "engine/overworld/emotion_bubbles.asm"
#include "engine/evolve_trade.asm"
#include "engine/battle/moveEffects/substitute_effect.asm"
#include "engine/menu/pc.asm"


SECTION "bank6",ROMX,BANK[$6]

#include "data/mapHeaders/celadoncity.asm"
#include "data/mapObjects/celadoncity.asm"
CeladonCityBlocks: INCBIN "maps/celadoncity.blk"

#include "data/mapHeaders/pallettown.asm"
#include "data/mapObjects/pallettown.asm"
PalletTownBlocks: INCBIN "maps/pallettown.blk"

#include "data/mapHeaders/viridiancity.asm"
#include "data/mapObjects/viridiancity.asm"
ViridianCityBlocks: INCBIN "maps/viridiancity.blk"

#include "data/mapHeaders/pewtercity.asm"
#include "data/mapObjects/pewtercity.asm"
PewterCityBlocks: INCBIN "maps/pewtercity.blk"

#include "data/mapHeaders/ceruleancity.asm"
#include "data/mapObjects/ceruleancity.asm"
CeruleanCityBlocks: INCBIN "maps/ceruleancity.blk"

#include "data/mapHeaders/vermilioncity.asm"
#include "data/mapObjects/vermilioncity.asm"
VermilionCityBlocks: INCBIN "maps/vermilioncity.blk"

#include "data/mapHeaders/fuchsiacity.asm"
#include "data/mapObjects/fuchsiacity.asm"
FuchsiaCityBlocks: INCBIN "maps/fuchsiacity.blk"

#include "engine/play_time.asm"

#include "scripts/pallettown.asm"
#include "scripts/viridiancity.asm"
#include "scripts/pewtercity.asm"
#include "scripts/ceruleancity.asm"
#include "scripts/vermilioncity.asm"
#include "scripts/celadoncity.asm"
#include "scripts/fuchsiacity.asm"

#include "data/mapHeaders/blueshouse.asm"
#include "scripts/blueshouse.asm"
#include "data/mapObjects/blueshouse.asm"
BluesHouseBlocks: INCBIN "maps/blueshouse.blk"

#include "data/mapHeaders/vermilionhouse3.asm"
#include "scripts/vermilionhouse3.asm"
#include "data/mapObjects/vermilionhouse3.asm"
VermilionHouse3Blocks: INCBIN "maps/vermilionhouse3.blk"

#include "data/mapHeaders/indigoplateaulobby.asm"
#include "scripts/indigoplateaulobby.asm"
#include "data/mapObjects/indigoplateaulobby.asm"
IndigoPlateauLobbyBlocks: INCBIN "maps/indigoplateaulobby.blk"

#include "data/mapHeaders/silphco4.asm"
#include "scripts/silphco4.asm"
#include "data/mapObjects/silphco4.asm"
SilphCo4Blocks: INCBIN "maps/silphco4.blk"

#include "data/mapHeaders/silphco5.asm"
#include "scripts/silphco5.asm"
#include "data/mapObjects/silphco5.asm"
SilphCo5Blocks: INCBIN "maps/silphco5.blk"

#include "data/mapHeaders/silphco6.asm"
#include "scripts/silphco6.asm"
#include "data/mapObjects/silphco6.asm"
SilphCo6Blocks: INCBIN "maps/silphco6.blk"

#include "engine/overworld/npc_movement.asm"
#include "engine/overworld/doors.asm"
#include "engine/overworld/ledges.asm"


SECTION "bank7",ROMX,BANK[$7]

#include "data/mapHeaders/cinnabarisland.asm"
#include "data/mapObjects/cinnabarisland.asm"
CinnabarIslandBlocks: INCBIN "maps/cinnabarisland.blk"

#include "data/mapHeaders/route1.asm"
#include "data/mapObjects/route1.asm"
Route1Blocks: INCBIN "maps/route1.blk"

UndergroundPathEntranceRoute8Blocks: INCBIN "maps/undergroundpathentranceroute8.blk"

OaksLabBlocks: INCBIN "maps/oakslab.blk"

Route16HouseBlocks:
Route2HouseBlocks:
SaffronHouse1Blocks:
SaffronHouse2Blocks:
VermilionHouse1Blocks:
NameRaterBlocks:
LavenderHouse1Blocks:
LavenderHouse2Blocks:
CeruleanHouse1Blocks:
PewterHouse1Blocks:
PewterHouse2Blocks:
ViridianHouseBlocks: INCBIN "maps/viridianhouse.blk"

CeladonMansion5Blocks:
SchoolBlocks: INCBIN "maps/school.blk"

CeruleanHouseTrashedBlocks: INCBIN "maps/ceruleanhousetrashed.blk"

DiglettsCaveEntranceRoute11Blocks:
DiglettsCaveRoute2Blocks: INCBIN "maps/diglettscaveroute2.blk"

#include "text/monster_names.asm"

#include "engine/clear_save.asm"

#include "engine/predefs7.asm"

#include "scripts/cinnabarisland.asm"

#include "scripts/route1.asm"

#include "data/mapHeaders/oakslab.asm"
#include "scripts/oakslab.asm"
#include "data/mapObjects/oakslab.asm"

#include "data/mapHeaders/viridianmart.asm"
#include "scripts/viridianmart.asm"
#include "data/mapObjects/viridianmart.asm"
ViridianMartBlocks: INCBIN "maps/viridianmart.blk"

#include "data/mapHeaders/school.asm"
#include "scripts/school.asm"
#include "data/mapObjects/school.asm"

#include "data/mapHeaders/viridianhouse.asm"
#include "scripts/viridianhouse.asm"
#include "data/mapObjects/viridianhouse.asm"

#include "data/mapHeaders/pewterhouse1.asm"
#include "scripts/pewterhouse1.asm"
#include "data/mapObjects/pewterhouse1.asm"

#include "data/mapHeaders/pewterhouse2.asm"
#include "scripts/pewterhouse2.asm"
#include "data/mapObjects/pewterhouse2.asm"

#include "data/mapHeaders/ceruleanhousetrashed.asm"
#include "scripts/ceruleanhousetrashed.asm"
#include "data/mapObjects/ceruleanhousetrashed.asm"

#include "data/mapHeaders/ceruleanhouse1.asm"
#include "scripts/ceruleanhouse1.asm"
#include "data/mapObjects/ceruleanhouse1.asm"

#include "data/mapHeaders/bikeshop.asm"
#include "scripts/bikeshop.asm"
#include "data/mapObjects/bikeshop.asm"
BikeShopBlocks: INCBIN "maps/bikeshop.blk"

#include "data/mapHeaders/lavenderhouse1.asm"
#include "scripts/lavenderhouse1.asm"
#include "data/mapObjects/lavenderhouse1.asm"

#include "data/mapHeaders/lavenderhouse2.asm"
#include "scripts/lavenderhouse2.asm"
#include "data/mapObjects/lavenderhouse2.asm"

#include "data/mapHeaders/namerater.asm"
#include "scripts/namerater.asm"
#include "data/mapObjects/namerater.asm"

#include "data/mapHeaders/vermilionhouse1.asm"
#include "scripts/vermilionhouse1.asm"
#include "data/mapObjects/vermilionhouse1.asm"

#include "data/mapHeaders/vermiliondock.asm"
#include "scripts/vermiliondock.asm"
#include "data/mapObjects/vermiliondock.asm"
VermilionDockBlocks: INCBIN "maps/vermiliondock.blk"

#include "data/mapHeaders/celadonmansion5.asm"
#include "scripts/celadonmansion5.asm"
#include "data/mapObjects/celadonmansion5.asm"

#include "data/mapHeaders/fuchsiamart.asm"
#include "scripts/fuchsiamart.asm"
#include "data/mapObjects/fuchsiamart.asm"
FuchsiaMartBlocks: INCBIN "maps/fuchsiamart.blk"

#include "data/mapHeaders/saffronhouse1.asm"
#include "scripts/saffronhouse1.asm"
#include "data/mapObjects/saffronhouse1.asm"

#include "data/mapHeaders/saffronhouse2.asm"
#include "scripts/saffronhouse2.asm"
#include "data/mapObjects/saffronhouse2.asm"

#include "data/mapHeaders/diglettscaveroute2.asm"
#include "scripts/diglettscaveroute2.asm"
#include "data/mapObjects/diglettscaveroute2.asm"

#include "data/mapHeaders/route2house.asm"
#include "scripts/route2house.asm"
#include "data/mapObjects/route2house.asm"

#include "data/mapHeaders/route5gate.asm"
#include "scripts/route5gate.asm"
#include "data/mapObjects/route5gate.asm"
Route5GateBlocks: INCBIN "maps/route5gate.blk"

#include "data/mapHeaders/route6gate.asm"
#include "scripts/route6gate.asm"
#include "data/mapObjects/route6gate.asm"
Route6GateBlocks: INCBIN "maps/route6gate.blk"

#include "data/mapHeaders/route7gate.asm"
#include "scripts/route7gate.asm"
#include "data/mapObjects/route7gate.asm"
Route7GateBlocks: INCBIN "maps/route7gate.blk"

#include "data/mapHeaders/route8gate.asm"
#include "scripts/route8gate.asm"
#include "data/mapObjects/route8gate.asm"
Route8GateBlocks: INCBIN "maps/route8gate.blk"

#include "data/mapHeaders/undergroundpathentranceroute8.asm"
#include "scripts/undergroundpathentranceroute8.asm"
#include "data/mapObjects/undergroundpathentranceroute8.asm"

#include "data/mapHeaders/powerplant.asm"
#include "scripts/powerplant.asm"
#include "data/mapObjects/powerplant.asm"
PowerPlantBlocks: INCBIN "maps/powerplant.blk"

#include "data/mapHeaders/diglettscaveroute11.asm"
#include "scripts/diglettscaveroute11.asm"
#include "data/mapObjects/diglettscaveroute11.asm"

#include "data/mapHeaders/route16house.asm"
#include "scripts/route16house.asm"
#include "data/mapObjects/route16house.asm"

#include "data/mapHeaders/route22gate.asm"
#include "scripts/route22gate.asm"
#include "data/mapObjects/route22gate.asm"
Route22GateBlocks: INCBIN "maps/route22gate.blk"

#include "data/mapHeaders/billshouse.asm"
#include "scripts/billshouse.asm"
#include "data/mapObjects/billshouse.asm"
BillsHouseBlocks: INCBIN "maps/billshouse.blk"

#include "engine/menu/oaks_pc.asm"

#include "engine/hidden_object_functions7.asm"


SECTION "Pics 1", ROMX, BANK[PICS_1]

RhydonPicFront::      INCBIN "pic/bmon/rhydon.pic"
RhydonPicBack::       INCBIN "pic/monback/rhydonb.pic"
KangaskhanPicFront::  INCBIN "pic/bmon/kangaskhan.pic"
KangaskhanPicBack::   INCBIN "pic/monback/kangaskhanb.pic"
NidoranMPicFront::    INCBIN "pic/bmon/nidoranm.pic"
NidoranMPicBack::     INCBIN "pic/monback/nidoranmb.pic"
ClefairyPicFront::    INCBIN "pic/bmon/clefairy.pic"
ClefairyPicBack::     INCBIN "pic/monback/clefairyb.pic"
SpearowPicFront::     INCBIN "pic/bmon/spearow.pic"
SpearowPicBack::      INCBIN "pic/monback/spearowb.pic"
VoltorbPicFront::     INCBIN "pic/bmon/voltorb.pic"
VoltorbPicBack::      INCBIN "pic/monback/voltorbb.pic"
NidokingPicFront::    INCBIN "pic/bmon/nidoking.pic"
NidokingPicBack::     INCBIN "pic/monback/nidokingb.pic"
SlowbroPicFront::     INCBIN "pic/bmon/slowbro.pic"
SlowbroPicBack::      INCBIN "pic/monback/slowbrob.pic"
IvysaurPicFront::     INCBIN "pic/bmon/ivysaur.pic"
IvysaurPicBack::      INCBIN "pic/monback/ivysaurb.pic"
ExeggutorPicFront::   INCBIN "pic/bmon/exeggutor.pic"
ExeggutorPicBack::    INCBIN "pic/monback/exeggutorb.pic"
LickitungPicFront::   INCBIN "pic/bmon/lickitung.pic"
LickitungPicBack::    INCBIN "pic/monback/lickitungb.pic"
ExeggcutePicFront::   INCBIN "pic/bmon/exeggcute.pic"
ExeggcutePicBack::    INCBIN "pic/monback/exeggcuteb.pic"
GrimerPicFront::      INCBIN "pic/bmon/grimer.pic"
GrimerPicBack::       INCBIN "pic/monback/grimerb.pic"
GengarPicFront::      INCBIN "pic/bmon/gengar.pic"
GengarPicBack::       INCBIN "pic/monback/gengarb.pic"
NidoranFPicFront::    INCBIN "pic/bmon/nidoranf.pic"
NidoranFPicBack::     INCBIN "pic/monback/nidoranfb.pic"
NidoqueenPicFront::   INCBIN "pic/bmon/nidoqueen.pic"
NidoqueenPicBack::    INCBIN "pic/monback/nidoqueenb.pic"
CubonePicFront::      INCBIN "pic/bmon/cubone.pic"
CubonePicBack::       INCBIN "pic/monback/cuboneb.pic"
RhyhornPicFront::     INCBIN "pic/bmon/rhyhorn.pic"
RhyhornPicBack::      INCBIN "pic/monback/rhyhornb.pic"
LaprasPicFront::      INCBIN "pic/bmon/lapras.pic"
LaprasPicBack::       INCBIN "pic/monback/laprasb.pic"
ArcaninePicFront::    INCBIN "pic/bmon/arcanine.pic"
ArcaninePicBack::     INCBIN "pic/monback/arcanineb.pic"
GyaradosPicFront::    INCBIN "pic/bmon/gyarados.pic"
GyaradosPicBack::     INCBIN "pic/monback/gyaradosb.pic"
ShellderPicFront::    INCBIN "pic/bmon/shellder.pic"
ShellderPicBack::     INCBIN "pic/monback/shellderb.pic"
TentacoolPicFront::   INCBIN "pic/bmon/tentacool.pic"
TentacoolPicBack::    INCBIN "pic/monback/tentacoolb.pic"
GastlyPicFront::      INCBIN "pic/bmon/gastly.pic"
GastlyPicBack::       INCBIN "pic/monback/gastlyb.pic"
ScytherPicFront::     INCBIN "pic/bmon/scyther.pic"
ScytherPicBack::      INCBIN "pic/monback/scytherb.pic"
StaryuPicFront::      INCBIN "pic/bmon/staryu.pic"
StaryuPicBack::       INCBIN "pic/monback/staryub.pic"
BlastoisePicFront::   INCBIN "pic/bmon/blastoise.pic"
BlastoisePicBack::    INCBIN "pic/monback/blastoiseb.pic"
PinsirPicFront::      INCBIN "pic/bmon/pinsir.pic"
PinsirPicBack::       INCBIN "pic/monback/pinsirb.pic"
TangelaPicFront::     INCBIN "pic/bmon/tangela.pic"
TangelaPicBack::      INCBIN "pic/monback/tangelab.pic"


SECTION "Battle (bank 9)", ROMX, BANK[$9]
#include "engine/battle/print_type.asm"
#include "engine/battle/save_trainer_name.asm"
#include "engine/battle/moveEffects/focus_energy_effect.asm"


SECTION "Pics 2", ROMX, BANK[PICS_2]

GrowlithePicFront::   INCBIN "pic/bmon/growlithe.pic"
GrowlithePicBack::    INCBIN "pic/monback/growlitheb.pic"
OnixPicFront::        INCBIN "pic/bmon/onix.pic"
OnixPicBack::         INCBIN "pic/monback/onixb.pic"
FearowPicFront::      INCBIN "pic/bmon/fearow.pic"
FearowPicBack::       INCBIN "pic/monback/fearowb.pic"
PidgeyPicFront::      INCBIN "pic/bmon/pidgey.pic"
PidgeyPicBack::       INCBIN "pic/monback/pidgeyb.pic"
SlowpokePicFront::    INCBIN "pic/bmon/slowpoke.pic"
SlowpokePicBack::     INCBIN "pic/monback/slowpokeb.pic"
KadabraPicFront::     INCBIN "pic/bmon/kadabra.pic"
KadabraPicBack::      INCBIN "pic/monback/kadabrab.pic"
GravelerPicFront::    INCBIN "pic/bmon/graveler.pic"
GravelerPicBack::     INCBIN "pic/monback/gravelerb.pic"
ChanseyPicFront::     INCBIN "pic/bmon/chansey.pic"
ChanseyPicBack::      INCBIN "pic/monback/chanseyb.pic"
MachokePicFront::     INCBIN "pic/bmon/machoke.pic"
MachokePicBack::      INCBIN "pic/monback/machokeb.pic"
MrMimePicFront::      INCBIN "pic/bmon/mr.mime.pic"
MrMimePicBack::       INCBIN "pic/monback/mr.mimeb.pic"
HitmonleePicFront::   INCBIN "pic/bmon/hitmonlee.pic"
HitmonleePicBack::    INCBIN "pic/monback/hitmonleeb.pic"
HitmonchanPicFront::  INCBIN "pic/bmon/hitmonchan.pic"
HitmonchanPicBack::   INCBIN "pic/monback/hitmonchanb.pic"
ArbokPicFront::       INCBIN "pic/bmon/arbok.pic"
ArbokPicBack::        INCBIN "pic/monback/arbokb.pic"
ParasectPicFront::    INCBIN "pic/bmon/parasect.pic"
ParasectPicBack::     INCBIN "pic/monback/parasectb.pic"
PsyduckPicFront::     INCBIN "pic/bmon/psyduck.pic"
PsyduckPicBack::      INCBIN "pic/monback/psyduckb.pic"
DrowzeePicFront::     INCBIN "pic/bmon/drowzee.pic"
DrowzeePicBack::      INCBIN "pic/monback/drowzeeb.pic"
GolemPicFront::       INCBIN "pic/bmon/golem.pic"
GolemPicBack::        INCBIN "pic/monback/golemb.pic"
MagmarPicFront::      INCBIN "pic/bmon/magmar.pic"
MagmarPicBack::       INCBIN "pic/monback/magmarb.pic"
ElectabuzzPicFront::  INCBIN "pic/bmon/electabuzz.pic"
ElectabuzzPicBack::   INCBIN "pic/monback/electabuzzb.pic"
MagnetonPicFront::    INCBIN "pic/bmon/magneton.pic"
MagnetonPicBack::     INCBIN "pic/monback/magnetonb.pic"
KoffingPicFront::     INCBIN "pic/bmon/koffing.pic"
KoffingPicBack::      INCBIN "pic/monback/koffingb.pic"
MankeyPicFront::      INCBIN "pic/bmon/mankey.pic"
MankeyPicBack::       INCBIN "pic/monback/mankeyb.pic"
SeelPicFront::        INCBIN "pic/bmon/seel.pic"
SeelPicBack::         INCBIN "pic/monback/seelb.pic"
DiglettPicFront::     INCBIN "pic/bmon/diglett.pic"
DiglettPicBack::      INCBIN "pic/monback/diglettb.pic"
TaurosPicFront::      INCBIN "pic/bmon/tauros.pic"
TaurosPicBack::       INCBIN "pic/monback/taurosb.pic"
FarfetchdPicFront::   INCBIN "pic/bmon/farfetchd.pic"
FarfetchdPicBack::    INCBIN "pic/monback/farfetchdb.pic"
VenonatPicFront::     INCBIN "pic/bmon/venonat.pic"
VenonatPicBack::      INCBIN "pic/monback/venonatb.pic"
DragonitePicFront::   INCBIN "pic/bmon/dragonite.pic"
DragonitePicBack::    INCBIN "pic/monback/dragoniteb.pic"
DoduoPicFront::       INCBIN "pic/bmon/doduo.pic"
DoduoPicBack::        INCBIN "pic/monback/doduob.pic"
PoliwagPicFront::     INCBIN "pic/bmon/poliwag.pic"
PoliwagPicBack::      INCBIN "pic/monback/poliwagb.pic"
JynxPicFront::        INCBIN "pic/bmon/jynx.pic"
JynxPicBack::         INCBIN "pic/monback/jynxb.pic"
MoltresPicFront::     INCBIN "pic/bmon/moltres.pic"
MoltresPicBack::      INCBIN "pic/monback/moltresb.pic"


SECTION "Battle (bank A)", ROMX, BANK[$A]
#include "engine/battle/moveEffects/leech_seed_effect.asm"


SECTION "Pics 3", ROMX, BANK[PICS_3]

ArticunoPicFront::    INCBIN "pic/bmon/articuno.pic"
ArticunoPicBack::     INCBIN "pic/monback/articunob.pic"
ZapdosPicFront::      INCBIN "pic/bmon/zapdos.pic"
ZapdosPicBack::       INCBIN "pic/monback/zapdosb.pic"
DittoPicFront::       INCBIN "pic/bmon/ditto.pic"
DittoPicBack::        INCBIN "pic/monback/dittob.pic"
MeowthPicFront::      INCBIN "pic/bmon/meowth.pic"
MeowthPicBack::       INCBIN "pic/monback/meowthb.pic"
KrabbyPicFront::      INCBIN "pic/bmon/krabby.pic"
KrabbyPicBack::       INCBIN "pic/monback/krabbyb.pic"
VulpixPicFront::      INCBIN "pic/bmon/vulpix.pic"
VulpixPicBack::       INCBIN "pic/monback/vulpixb.pic"
NinetalesPicFront::   INCBIN "pic/bmon/ninetales.pic"
NinetalesPicBack::    INCBIN "pic/monback/ninetalesb.pic"
PikachuPicFront::     INCBIN "pic/bmon/pikachu.pic"
PikachuPicBack::      INCBIN "pic/monback/pikachub.pic"
RaichuPicFront::      INCBIN "pic/bmon/raichu.pic"
RaichuPicBack::       INCBIN "pic/monback/raichub.pic"
DratiniPicFront::     INCBIN "pic/bmon/dratini.pic"
DratiniPicBack::      INCBIN "pic/monback/dratinib.pic"
DragonairPicFront::   INCBIN "pic/bmon/dragonair.pic"
DragonairPicBack::    INCBIN "pic/monback/dragonairb.pic"
KabutoPicFront::      INCBIN "pic/bmon/kabuto.pic"
KabutoPicBack::       INCBIN "pic/monback/kabutob.pic"
KabutopsPicFront::    INCBIN "pic/bmon/kabutops.pic"
KabutopsPicBack::     INCBIN "pic/monback/kabutopsb.pic"
HorseaPicFront::      INCBIN "pic/bmon/horsea.pic"
HorseaPicBack::       INCBIN "pic/monback/horseab.pic"
SeadraPicFront::      INCBIN "pic/bmon/seadra.pic"
SeadraPicBack::       INCBIN "pic/monback/seadrab.pic"
SandshrewPicFront::   INCBIN "pic/bmon/sandshrew.pic"
SandshrewPicBack::    INCBIN "pic/monback/sandshrewb.pic"
SandslashPicFront::   INCBIN "pic/bmon/sandslash.pic"
SandslashPicBack::    INCBIN "pic/monback/sandslashb.pic"
OmanytePicFront::     INCBIN "pic/bmon/omanyte.pic"
OmanytePicBack::      INCBIN "pic/monback/omanyteb.pic"
OmastarPicFront::     INCBIN "pic/bmon/omastar.pic"
OmastarPicBack::      INCBIN "pic/monback/omastarb.pic"
JigglypuffPicFront::  INCBIN "pic/bmon/jigglypuff.pic"
JigglypuffPicBack::   INCBIN "pic/monback/jigglypuffb.pic"
WigglytuffPicFront::  INCBIN "pic/bmon/wigglytuff.pic"
WigglytuffPicBack::   INCBIN "pic/monback/wigglytuffb.pic"
EeveePicFront::       INCBIN "pic/bmon/eevee.pic"
EeveePicBack::        INCBIN "pic/monback/eeveeb.pic"
FlareonPicFront::     INCBIN "pic/bmon/flareon.pic"
FlareonPicBack::      INCBIN "pic/monback/flareonb.pic"
JolteonPicFront::     INCBIN "pic/bmon/jolteon.pic"
JolteonPicBack::      INCBIN "pic/monback/jolteonb.pic"
VaporeonPicFront::    INCBIN "pic/bmon/vaporeon.pic"
VaporeonPicBack::     INCBIN "pic/monback/vaporeonb.pic"
MachopPicFront::      INCBIN "pic/bmon/machop.pic"
MachopPicBack::       INCBIN "pic/monback/machopb.pic"
ZubatPicFront::       INCBIN "pic/bmon/zubat.pic"
ZubatPicBack::        INCBIN "pic/monback/zubatb.pic"
EkansPicFront::       INCBIN "pic/bmon/ekans.pic"
EkansPicBack::        INCBIN "pic/monback/ekansb.pic"
ParasPicFront::       INCBIN "pic/bmon/paras.pic"
ParasPicBack::        INCBIN "pic/monback/parasb.pic"
PoliwhirlPicFront::   INCBIN "pic/bmon/poliwhirl.pic"
PoliwhirlPicBack::    INCBIN "pic/monback/poliwhirlb.pic"
PoliwrathPicFront::   INCBIN "pic/bmon/poliwrath.pic"
PoliwrathPicBack::    INCBIN "pic/monback/poliwrathb.pic"
WeedlePicFront::      INCBIN "pic/bmon/weedle.pic"
WeedlePicBack::       INCBIN "pic/monback/weedleb.pic"
KakunaPicFront::      INCBIN "pic/bmon/kakuna.pic"
KakunaPicBack::       INCBIN "pic/monback/kakunab.pic"
BeedrillPicFront::    INCBIN "pic/bmon/beedrill.pic"
BeedrillPicBack::     INCBIN "pic/monback/beedrillb.pic"

FossilKabutopsPic::   INCBIN "pic/bmon/fossilkabutops.pic"


SECTION "Battle (bank B)", ROMX, BANK[$B]

#include "engine/battle/display_effectiveness.asm"

TrainerInfoTextBoxTileGraphics:  INCBIN "gfx/trainer_info.2bpp"
TrainerInfoTextBoxTileGraphicsEnd:
BlankLeaderNames:                INCBIN "gfx/blank_leader_names.2bpp"
CircleTile:                      INCBIN "gfx/circle_tile.2bpp"
BadgeNumbersTileGraphics:        INCBIN "gfx/badge_numbers.2bpp"

#include "engine/items/tmhm.asm"
#include "engine/battle/scale_sprites.asm"
#include "engine/battle/moveEffects/pay_day_effect.asm"
#include "engine/game_corner_slots2.asm"


SECTION "Pics 4", ROMX, BANK[PICS_4]

DodrioPicFront::       INCBIN "pic/bmon/dodrio.pic"
DodrioPicBack::        INCBIN "pic/monback/dodriob.pic"
PrimeapePicFront::     INCBIN "pic/bmon/primeape.pic"
PrimeapePicBack::      INCBIN "pic/monback/primeapeb.pic"
DugtrioPicFront::      INCBIN "pic/bmon/dugtrio.pic"
DugtrioPicBack::       INCBIN "pic/monback/dugtriob.pic"
VenomothPicFront::     INCBIN "pic/bmon/venomoth.pic"
VenomothPicBack::      INCBIN "pic/monback/venomothb.pic"
DewgongPicFront::      INCBIN "pic/bmon/dewgong.pic"
DewgongPicBack::       INCBIN "pic/monback/dewgongb.pic"
CaterpiePicFront::     INCBIN "pic/bmon/caterpie.pic"
CaterpiePicBack::      INCBIN "pic/monback/caterpieb.pic"
MetapodPicFront::      INCBIN "pic/bmon/metapod.pic"
MetapodPicBack::       INCBIN "pic/monback/metapodb.pic"
ButterfreePicFront::   INCBIN "pic/bmon/butterfree.pic"
ButterfreePicBack::    INCBIN "pic/monback/butterfreeb.pic"
MachampPicFront::      INCBIN "pic/bmon/machamp.pic"
MachampPicBack::       INCBIN "pic/monback/machampb.pic"
GolduckPicFront::      INCBIN "pic/bmon/golduck.pic"
GolduckPicBack::       INCBIN "pic/monback/golduckb.pic"
HypnoPicFront::        INCBIN "pic/bmon/hypno.pic"
HypnoPicBack::         INCBIN "pic/monback/hypnob.pic"
GolbatPicFront::       INCBIN "pic/bmon/golbat.pic"
GolbatPicBack::        INCBIN "pic/monback/golbatb.pic"
MewtwoPicFront::       INCBIN "pic/bmon/mewtwo.pic"
MewtwoPicBack::        INCBIN "pic/monback/mewtwob.pic"
SnorlaxPicFront::      INCBIN "pic/bmon/snorlax.pic"
SnorlaxPicBack::       INCBIN "pic/monback/snorlaxb.pic"
MagikarpPicFront::     INCBIN "pic/bmon/magikarp.pic"
MagikarpPicBack::      INCBIN "pic/monback/magikarpb.pic"
MukPicFront::          INCBIN "pic/bmon/muk.pic"
MukPicBack::           INCBIN "pic/monback/mukb.pic"
KinglerPicFront::      INCBIN "pic/bmon/kingler.pic"
KinglerPicBack::       INCBIN "pic/monback/kinglerb.pic"
CloysterPicFront::     INCBIN "pic/bmon/cloyster.pic"
CloysterPicBack::      INCBIN "pic/monback/cloysterb.pic"
ElectrodePicFront::    INCBIN "pic/bmon/electrode.pic"
ElectrodePicBack::     INCBIN "pic/monback/electrodeb.pic"
ClefablePicFront::     INCBIN "pic/bmon/clefable.pic"
ClefablePicBack::      INCBIN "pic/monback/clefableb.pic"
WeezingPicFront::      INCBIN "pic/bmon/weezing.pic"
WeezingPicBack::       INCBIN "pic/monback/weezingb.pic"
PersianPicFront::      INCBIN "pic/bmon/persian.pic"
PersianPicBack::       INCBIN "pic/monback/persianb.pic"
MarowakPicFront::      INCBIN "pic/bmon/marowak.pic"
MarowakPicBack::       INCBIN "pic/monback/marowakb.pic"
HaunterPicFront::      INCBIN "pic/bmon/haunter.pic"
HaunterPicBack::       INCBIN "pic/monback/haunterb.pic"
AbraPicFront::         INCBIN "pic/bmon/abra.pic"
AbraPicBack::          INCBIN "pic/monback/abrab.pic"
AlakazamPicFront::     INCBIN "pic/bmon/alakazam.pic"
AlakazamPicBack::      INCBIN "pic/monback/alakazamb.pic"
PidgeottoPicFront::    INCBIN "pic/bmon/pidgeotto.pic"
PidgeottoPicBack::     INCBIN "pic/monback/pidgeottob.pic"
PidgeotPicFront::      INCBIN "pic/bmon/pidgeot.pic"
PidgeotPicBack::       INCBIN "pic/monback/pidgeotb.pic"
StarmiePicFront::      INCBIN "pic/bmon/starmie.pic"
StarmiePicBack::       INCBIN "pic/monback/starmieb.pic"

RedPicBack::           INCBIN "pic/trainer/redb.pic"
OldManPic::            INCBIN "pic/trainer/oldman.pic"


SECTION "Battle (bank C)", ROMX, BANK[$C]
#include "engine/battle/moveEffects/mist_effect.asm"
#include "engine/battle/moveEffects/one_hit_ko_effect.asm"


SECTION "Pics 5", ROMX, BANK[PICS_5]

BulbasaurPicFront::    INCBIN "pic/bmon/bulbasaur.pic"
BulbasaurPicBack::     INCBIN "pic/monback/bulbasaurb.pic"
VenusaurPicFront::     INCBIN "pic/bmon/venusaur.pic"
VenusaurPicBack::      INCBIN "pic/monback/venusaurb.pic"
TentacruelPicFront::   INCBIN "pic/bmon/tentacruel.pic"
TentacruelPicBack::    INCBIN "pic/monback/tentacruelb.pic"
GoldeenPicFront::      INCBIN "pic/bmon/goldeen.pic"
GoldeenPicBack::       INCBIN "pic/monback/goldeenb.pic"
SeakingPicFront::      INCBIN "pic/bmon/seaking.pic"
SeakingPicBack::       INCBIN "pic/monback/seakingb.pic"
PonytaPicFront::       INCBIN "pic/bmon/ponyta.pic"
RapidashPicFront::     INCBIN "pic/bmon/rapidash.pic"
PonytaPicBack::        INCBIN "pic/monback/ponytab.pic"
RapidashPicBack::      INCBIN "pic/monback/rapidashb.pic"
RattataPicFront::      INCBIN "pic/bmon/rattata.pic"
RattataPicBack::       INCBIN "pic/monback/rattatab.pic"
RaticatePicFront::     INCBIN "pic/bmon/raticate.pic"
RaticatePicBack::      INCBIN "pic/monback/raticateb.pic"
NidorinoPicFront::     INCBIN "pic/bmon/nidorino.pic"
NidorinoPicBack::      INCBIN "pic/monback/nidorinob.pic"
NidorinaPicFront::     INCBIN "pic/bmon/nidorina.pic"
NidorinaPicBack::      INCBIN "pic/monback/nidorinab.pic"
GeodudePicFront::      INCBIN "pic/bmon/geodude.pic"
GeodudePicBack::       INCBIN "pic/monback/geodudeb.pic"
PorygonPicFront::      INCBIN "pic/bmon/porygon.pic"
PorygonPicBack::       INCBIN "pic/monback/porygonb.pic"
AerodactylPicFront::   INCBIN "pic/bmon/aerodactyl.pic"
AerodactylPicBack::    INCBIN "pic/monback/aerodactylb.pic"
MagnemitePicFront::    INCBIN "pic/bmon/magnemite.pic"
MagnemitePicBack::     INCBIN "pic/monback/magnemiteb.pic"
CharmanderPicFront::   INCBIN "pic/bmon/charmander.pic"
CharmanderPicBack::    INCBIN "pic/monback/charmanderb.pic"
SquirtlePicFront::     INCBIN "pic/bmon/squirtle.pic"
SquirtlePicBack::      INCBIN "pic/monback/squirtleb.pic"
CharmeleonPicFront::   INCBIN "pic/bmon/charmeleon.pic"
CharmeleonPicBack::    INCBIN "pic/monback/charmeleonb.pic"
WartortlePicFront::    INCBIN "pic/bmon/wartortle.pic"
WartortlePicBack::     INCBIN "pic/monback/wartortleb.pic"
CharizardPicFront::    INCBIN "pic/bmon/charizard.pic"
CharizardPicBack::     INCBIN "pic/monback/charizardb.pic"
FossilAerodactylPic::  INCBIN "pic/bmon/fossilaerodactyl.pic"
GhostPic::             INCBIN "pic/other/ghost.pic"
OddishPicFront::       INCBIN "pic/bmon/oddish.pic"
OddishPicBack::        INCBIN "pic/monback/oddishb.pic"
GloomPicFront::        INCBIN "pic/bmon/gloom.pic"
GloomPicBack::         INCBIN "pic/monback/gloomb.pic"
VileplumePicFront::    INCBIN "pic/bmon/vileplume.pic"
VileplumePicBack::     INCBIN "pic/monback/vileplumeb.pic"
BellsproutPicFront::   INCBIN "pic/bmon/bellsprout.pic"
BellsproutPicBack::    INCBIN "pic/monback/bellsproutb.pic"
WeepinbellPicFront::   INCBIN "pic/bmon/weepinbell.pic"
WeepinbellPicBack::    INCBIN "pic/monback/weepinbellb.pic"
VictreebelPicFront::   INCBIN "pic/bmon/victreebel.pic"
VictreebelPicBack::    INCBIN "pic/monback/victreebelb.pic"


SECTION "Battle (bank D)", ROMX, BANK[$D]

#include "engine/titlescreen2.asm"
#include "engine/battle/link_battle_versus_text.asm"
#include "engine/slot_machine.asm"
#include "engine/overworld/pewter_guys.asm"
#include "engine/multiply_divide.asm"
#include "engine/game_corner_slots.asm"


SECTION "bankE",ROMX,BANK[$E]

#include "data/moves.asm"
BaseStats: #include "data/base_stats.asm"
#include "data/cries.asm"
#include "engine/battle/unused_stats_functions.asm"
#include "engine/battle/scroll_draw_trainer_pic.asm"
#include "engine/battle/trainer_ai.asm"
#include "engine/battle/draw_hud_pokeball_gfx.asm"

TradingAnimationGraphics:
	INCBIN "gfx/game_boy.norepeat.2bpp"
	INCBIN "gfx/link_cable.2bpp"
TradingAnimationGraphicsEnd:

TradingAnimationGraphics2:
// Pokeball traveling through the link cable.
	INCBIN "gfx/trade2.2bpp"
TradingAnimationGraphics2End:

#include "engine/evos_moves.asm"
#include "engine/battle/moveEffects/heal_effect.asm"
#include "engine/battle/moveEffects/transform_effect.asm"
#include "engine/battle/moveEffects/reflect_light_screen_effect.asm"


SECTION "bankF",ROMX,BANK[$F]

#include "engine/battle/core.asm"


SECTION "bank10",ROMX,BANK[$10]

#include "engine/menu/pokedex.asm"
#include "engine/trade.asm"
#include "engine/intro.asm"
#include "engine/trade2.asm"


SECTION "bank11",ROMX,BANK[$11]

#include "data/mapHeaders/lavendertown.asm"
#include "data/mapObjects/lavendertown.asm"
LavenderTownBlocks: INCBIN "maps/lavendertown.blk"

ViridianPokecenterBlocks: INCBIN "maps/viridianpokecenter.blk"

SafariZoneRestHouse1Blocks:
SafariZoneRestHouse2Blocks:
SafariZoneRestHouse3Blocks:
SafariZoneRestHouse4Blocks: INCBIN "maps/safarizoneresthouse1.blk"

#include "scripts/lavendertown.asm"

#include "engine/pokedex_rating.asm"

#include "data/mapHeaders/viridianpokecenter.asm"
#include "scripts/viridianpokecenter.asm"
#include "data/mapObjects/viridianpokecenter.asm"

#include "data/mapHeaders/mansion1.asm"
#include "scripts/mansion1.asm"
#include "data/mapObjects/mansion1.asm"
Mansion1Blocks: INCBIN "maps/mansion1.blk"

#include "data/mapHeaders/rocktunnel1.asm"
#include "scripts/rocktunnel1.asm"
#include "data/mapObjects/rocktunnel1.asm"
RockTunnel1Blocks: INCBIN "maps/rocktunnel1.blk"

#include "data/mapHeaders/seafoamislands1.asm"
#include "scripts/seafoamislands1.asm"
#include "data/mapObjects/seafoamislands1.asm"
SeafoamIslands1Blocks: INCBIN "maps/seafoamislands1.blk"

#include "data/mapHeaders/ssanne3.asm"
#include "scripts/ssanne3.asm"
#include "data/mapObjects/ssanne3.asm"
SSAnne3Blocks: INCBIN "maps/ssanne3.blk"

#include "data/mapHeaders/victoryroad3.asm"
#include "scripts/victoryroad3.asm"
#include "data/mapObjects/victoryroad3.asm"
VictoryRoad3Blocks: INCBIN "maps/victoryroad3.blk"

#include "data/mapHeaders/rockethideout1.asm"
#include "scripts/rockethideout1.asm"
#include "data/mapObjects/rockethideout1.asm"
RocketHideout1Blocks: INCBIN "maps/rockethideout1.blk"

#include "data/mapHeaders/rockethideout2.asm"
#include "scripts/rockethideout2.asm"
#include "data/mapObjects/rockethideout2.asm"
RocketHideout2Blocks: INCBIN "maps/rockethideout2.blk"

#include "data/mapHeaders/rockethideout3.asm"
#include "scripts/rockethideout3.asm"
#include "data/mapObjects/rockethideout3.asm"
RocketHideout3Blocks: INCBIN "maps/rockethideout3.blk"

#include "data/mapHeaders/rockethideout4.asm"
#include "scripts/rockethideout4.asm"
#include "data/mapObjects/rockethideout4.asm"
RocketHideout4Blocks: INCBIN "maps/rockethideout4.blk"

#include "data/mapHeaders/rockethideoutelevator.asm"
#include "scripts/rockethideoutelevator.asm"
#include "data/mapObjects/rockethideoutelevator.asm"
RocketHideoutElevatorBlocks: INCBIN "maps/rockethideoutelevator.blk"

#include "data/mapHeaders/silphcoelevator.asm"
#include "scripts/silphcoelevator.asm"
#include "data/mapObjects/silphcoelevator.asm"
SilphCoElevatorBlocks: INCBIN "maps/silphcoelevator.blk"

#include "data/mapHeaders/safarizoneeast.asm"
#include "scripts/safarizoneeast.asm"
#include "data/mapObjects/safarizoneeast.asm"
SafariZoneEastBlocks: INCBIN "maps/safarizoneeast.blk"

#include "data/mapHeaders/safarizonenorth.asm"
#include "scripts/safarizonenorth.asm"
#include "data/mapObjects/safarizonenorth.asm"
SafariZoneNorthBlocks: INCBIN "maps/safarizonenorth.blk"

#include "data/mapHeaders/safarizonecenter.asm"
#include "scripts/safarizonecenter.asm"
#include "data/mapObjects/safarizonecenter.asm"
SafariZoneCenterBlocks: INCBIN "maps/safarizonecenter.blk"

#include "data/mapHeaders/safarizoneresthouse1.asm"
#include "scripts/safarizoneresthouse1.asm"
#include "data/mapObjects/safarizoneresthouse1.asm"

#include "data/mapHeaders/safarizoneresthouse2.asm"
#include "scripts/safarizoneresthouse2.asm"
#include "data/mapObjects/safarizoneresthouse2.asm"

#include "data/mapHeaders/safarizoneresthouse3.asm"
#include "scripts/safarizoneresthouse3.asm"
#include "data/mapObjects/safarizoneresthouse3.asm"

#include "data/mapHeaders/safarizoneresthouse4.asm"
#include "scripts/safarizoneresthouse4.asm"
#include "data/mapObjects/safarizoneresthouse4.asm"

#include "data/mapHeaders/unknowndungeon2.asm"
#include "scripts/unknowndungeon2.asm"
#include "data/mapObjects/unknowndungeon2.asm"
UnknownDungeon2Blocks: INCBIN "maps/unknowndungeon2.blk"

#include "data/mapHeaders/unknowndungeon3.asm"
#include "scripts/unknowndungeon3.asm"
#include "data/mapObjects/unknowndungeon3.asm"
UnknownDungeon3Blocks: INCBIN "maps/unknowndungeon3.blk"

#include "data/mapHeaders/rocktunnel2.asm"
#include "scripts/rocktunnel2.asm"
#include "data/mapObjects/rocktunnel2.asm"
RockTunnel2Blocks: INCBIN "maps/rocktunnel2.blk"

#include "data/mapHeaders/seafoamislands2.asm"
#include "scripts/seafoamislands2.asm"
#include "data/mapObjects/seafoamislands2.asm"
SeafoamIslands2Blocks: INCBIN "maps/seafoamislands2.blk"

#include "data/mapHeaders/seafoamislands3.asm"
#include "scripts/seafoamislands3.asm"
#include "data/mapObjects/seafoamislands3.asm"
SeafoamIslands3Blocks: INCBIN "maps/seafoamislands3.blk"

#include "data/mapHeaders/seafoamislands4.asm"
#include "scripts/seafoamislands4.asm"
#include "data/mapObjects/seafoamislands4.asm"
SeafoamIslands4Blocks: INCBIN "maps/seafoamislands4.blk"

#include "data/mapHeaders/seafoamislands5.asm"
#include "scripts/seafoamislands5.asm"
#include "data/mapObjects/seafoamislands5.asm"
SeafoamIslands5Blocks: INCBIN "maps/seafoamislands5.blk"

#include "engine/overworld/hidden_objects.asm"


SECTION "bank12",ROMX,BANK[$12]

#include "data/mapHeaders/route7.asm"
#include "data/mapObjects/route7.asm"
Route7Blocks: INCBIN "maps/route7.blk"

CeladonPokecenterBlocks:
RockTunnelPokecenterBlocks:
MtMoonPokecenterBlocks: INCBIN "maps/mtmoonpokecenter.blk"

Route18GateBlocks:
Route15GateBlocks:
Route11GateBlocks: INCBIN "maps/route11gate.blk"

Route18GateUpstairsBlocks:
Route16GateUpstairsBlocks:
Route12GateUpstairsBlocks:
Route15GateUpstairsBlocks:
Route11GateUpstairsBlocks: INCBIN "maps/route11gateupstairs.blk"

#include "engine/predefs12.asm"

#include "scripts/route7.asm"

#include "data/mapHeaders/redshouse1f.asm"
#include "scripts/redshouse1f.asm"
#include "data/mapObjects/redshouse1f.asm"
RedsHouse1FBlocks: INCBIN "maps/redshouse1f.blk"

#include "data/mapHeaders/celadonmart3.asm"
#include "scripts/celadonmart3.asm"
#include "data/mapObjects/celadonmart3.asm"
CeladonMart3Blocks: INCBIN "maps/celadonmart3.blk"

#include "data/mapHeaders/celadonmart4.asm"
#include "scripts/celadonmart4.asm"
#include "data/mapObjects/celadonmart4.asm"
CeladonMart4Blocks: INCBIN "maps/celadonmart4.blk"

#include "data/mapHeaders/celadonmartroof.asm"
#include "scripts/celadonmartroof.asm"
#include "data/mapObjects/celadonmartroof.asm"
CeladonMartRoofBlocks: INCBIN "maps/celadonmartroof.blk"

#include "data/mapHeaders/celadonmartelevator.asm"
#include "scripts/celadonmartelevator.asm"
#include "data/mapObjects/celadonmartelevator.asm"
CeladonMartElevatorBlocks: INCBIN "maps/celadonmartelevator.blk"

#include "data/mapHeaders/celadonmansion1.asm"
#include "scripts/celadonmansion1.asm"
#include "data/mapObjects/celadonmansion1.asm"
CeladonMansion1Blocks: INCBIN "maps/celadonmansion1.blk"

#include "data/mapHeaders/celadonmansion2.asm"
#include "scripts/celadonmansion2.asm"
#include "data/mapObjects/celadonmansion2.asm"
CeladonMansion2Blocks: INCBIN "maps/celadonmansion2.blk"

#include "data/mapHeaders/celadonmansion3.asm"
#include "scripts/celadonmansion3.asm"
#include "data/mapObjects/celadonmansion3.asm"
CeladonMansion3Blocks: INCBIN "maps/celadonmansion3.blk"

#include "data/mapHeaders/celadonmansion4.asm"
#include "scripts/celadonmansion4.asm"
#include "data/mapObjects/celadonmansion4.asm"
CeladonMansion4Blocks: INCBIN "maps/celadonmansion4.blk"

#include "data/mapHeaders/celadonpokecenter.asm"
#include "scripts/celadonpokecenter.asm"
#include "data/mapObjects/celadonpokecenter.asm"

#include "data/mapHeaders/celadongym.asm"
#include "scripts/celadongym.asm"
#include "data/mapObjects/celadongym.asm"
CeladonGymBlocks: INCBIN "maps/celadongym.blk"

#include "data/mapHeaders/celadongamecorner.asm"
#include "scripts/celadongamecorner.asm"
#include "data/mapObjects/celadongamecorner.asm"
CeladonGameCornerBlocks: INCBIN "maps/celadongamecorner.blk"

#include "data/mapHeaders/celadonmart5.asm"
#include "scripts/celadonmart5.asm"
#include "data/mapObjects/celadonmart5.asm"
CeladonMart5Blocks: INCBIN "maps/celadonmart5.blk"

#include "data/mapHeaders/celadonprizeroom.asm"
#include "scripts/celadonprizeroom.asm"
#include "data/mapObjects/celadonprizeroom.asm"
CeladonPrizeRoomBlocks: INCBIN "maps/celadonprizeroom.blk"

#include "data/mapHeaders/celadondiner.asm"
#include "scripts/celadondiner.asm"
#include "data/mapObjects/celadondiner.asm"
CeladonDinerBlocks: INCBIN "maps/celadondiner.blk"

#include "data/mapHeaders/celadonhouse.asm"
#include "scripts/celadonhouse.asm"
#include "data/mapObjects/celadonhouse.asm"
CeladonHouseBlocks: INCBIN "maps/celadonhouse.blk"

#include "data/mapHeaders/celadonhotel.asm"
#include "scripts/celadonhotel.asm"
#include "data/mapObjects/celadonhotel.asm"
CeladonHotelBlocks: INCBIN "maps/celadonhotel.blk"

#include "data/mapHeaders/mtmoonpokecenter.asm"
#include "scripts/mtmoonpokecenter.asm"
#include "data/mapObjects/mtmoonpokecenter.asm"

#include "data/mapHeaders/rocktunnelpokecenter.asm"
#include "scripts/rocktunnelpokecenter.asm"
#include "data/mapObjects/rocktunnelpokecenter.asm"

#include "data/mapHeaders/route11gate.asm"
#include "scripts/route11gate.asm"
#include "data/mapObjects/route11gate.asm"

#include "data/mapHeaders/route11gateupstairs.asm"
#include "scripts/route11gateupstairs.asm"
#include "data/mapObjects/route11gateupstairs.asm"

#include "data/mapHeaders/route12gate.asm"
#include "scripts/route12gate.asm"
#include "data/mapObjects/route12gate.asm"
Route12GateBlocks: INCBIN "maps/route12gate.blk"

#include "data/mapHeaders/route12gateupstairs.asm"
#include "scripts/route12gateupstairs.asm"
#include "data/mapObjects/route12gateupstairs.asm"

#include "data/mapHeaders/route15gate.asm"
#include "scripts/route15gate.asm"
#include "data/mapObjects/route15gate.asm"

#include "data/mapHeaders/route15gateupstairs.asm"
#include "scripts/route15gateupstairs.asm"
#include "data/mapObjects/route15gateupstairs.asm"

#include "data/mapHeaders/route16gate.asm"
#include "scripts/route16gate.asm"
#include "data/mapObjects/route16gate.asm"
Route16GateBlocks: INCBIN "maps/route16gate.blk"

#include "data/mapHeaders/route16gateupstairs.asm"
#include "scripts/route16gateupstairs.asm"
#include "data/mapObjects/route16gateupstairs.asm"

#include "data/mapHeaders/route18gate.asm"
#include "scripts/route18gate.asm"
#include "data/mapObjects/route18gate.asm"

#include "data/mapHeaders/route18gateupstairs.asm"
#include "scripts/route18gateupstairs.asm"
#include "data/mapObjects/route18gateupstairs.asm"

#include "data/mapHeaders/mtmoon1.asm"
#include "scripts/mtmoon1.asm"
#include "data/mapObjects/mtmoon1.asm"
MtMoon1Blocks: INCBIN "maps/mtmoon1.blk"

#include "data/mapHeaders/mtmoon3.asm"
#include "scripts/mtmoon3.asm"
#include "data/mapObjects/mtmoon3.asm"
MtMoon3Blocks: INCBIN "maps/mtmoon3.blk"

#include "data/mapHeaders/safarizonewest.asm"
#include "scripts/safarizonewest.asm"
#include "data/mapObjects/safarizonewest.asm"
SafariZoneWestBlocks: INCBIN "maps/safarizonewest.blk"

#include "data/mapHeaders/safarizonesecrethouse.asm"
#include "scripts/safarizonesecrethouse.asm"
#include "data/mapObjects/safarizonesecrethouse.asm"
SafariZoneSecretHouseBlocks: INCBIN "maps/safarizonesecrethouse.blk"


SECTION "bank13",ROMX,BANK[$13]

TrainerPics::
YoungsterPic::     INCBIN "pic/trainer/youngster.pic"
BugCatcherPic::    INCBIN "pic/trainer/bugcatcher.pic"
LassPic::          INCBIN "pic/trainer/lass.pic"
SailorPic::        INCBIN "pic/trainer/sailor.pic"
JrTrainerMPic::    INCBIN "pic/trainer/jr.trainerm.pic"
JrTrainerFPic::    INCBIN "pic/trainer/jr.trainerf.pic"
PokemaniacPic::    INCBIN "pic/trainer/pokemaniac.pic"
SuperNerdPic::     INCBIN "pic/trainer/supernerd.pic"
HikerPic::         INCBIN "pic/trainer/hiker.pic"
BikerPic::         INCBIN "pic/trainer/biker.pic"
BurglarPic::       INCBIN "pic/trainer/burglar.pic"
EngineerPic::      INCBIN "pic/trainer/engineer.pic"
FisherPic::        INCBIN "pic/trainer/fisher.pic"
SwimmerPic::       INCBIN "pic/trainer/swimmer.pic"
CueBallPic::       INCBIN "pic/trainer/cueball.pic"
GamblerPic::       INCBIN "pic/trainer/gambler.pic"
BeautyPic::        INCBIN "pic/trainer/beauty.pic"
PsychicPic::       INCBIN "pic/trainer/psychic.pic"
RockerPic::        INCBIN "pic/trainer/rocker.pic"
JugglerPic::       INCBIN "pic/trainer/juggler.pic"
TamerPic::         INCBIN "pic/trainer/tamer.pic"
BirdKeeperPic::    INCBIN "pic/trainer/birdkeeper.pic"
BlackbeltPic::     INCBIN "pic/trainer/blackbelt.pic"
Rival1Pic::        INCBIN "pic/trainer/rival1.pic"
ProfOakPic::       INCBIN "pic/trainer/prof.oak.pic"
ChiefPic::
ScientistPic::     INCBIN "pic/trainer/scientist.pic"
GiovanniPic::      INCBIN "pic/trainer/giovanni.pic"
RocketPic::        INCBIN "pic/trainer/rocket.pic"
CooltrainerMPic::  INCBIN "pic/trainer/cooltrainerm.pic"
CooltrainerFPic::  INCBIN "pic/trainer/cooltrainerf.pic"
BrunoPic::         INCBIN "pic/trainer/bruno.pic"
BrockPic::         INCBIN "pic/trainer/brock.pic"
MistyPic::         INCBIN "pic/trainer/misty.pic"
LtSurgePic::       INCBIN "pic/trainer/lt.surge.pic"
ErikaPic::         INCBIN "pic/trainer/erika.pic"
KogaPic::          INCBIN "pic/trainer/koga.pic"
BlainePic::        INCBIN "pic/trainer/blaine.pic"
SabrinaPic::       INCBIN "pic/trainer/sabrina.pic"
GentlemanPic::     INCBIN "pic/trainer/gentleman.pic"
Rival2Pic::        INCBIN "pic/trainer/rival2.pic"
Rival3Pic::        INCBIN "pic/trainer/rival3.pic"
LoreleiPic::       INCBIN "pic/trainer/lorelei.pic"
ChannelerPic::     INCBIN "pic/trainer/channeler.pic"
AgathaPic::        INCBIN "pic/trainer/agatha.pic"
LancePic::         INCBIN "pic/trainer/lance.pic"

#include "data/mapHeaders/tradecenter.asm"
#include "scripts/tradecenter.asm"
#include "data/mapObjects/tradecenter.asm"
TradeCenterBlocks: INCBIN "maps/tradecenter.blk"

#include "data/mapHeaders/colosseum.asm"
#include "scripts/colosseum.asm"
#include "data/mapObjects/colosseum.asm"
ColosseumBlocks: INCBIN "maps/colosseum.blk"

#include "engine/give_pokemon.asm"

#include "engine/predefs.asm"


SECTION "bank14",ROMX,BANK[$14]

#include "data/mapHeaders/route22.asm"
#include "data/mapObjects/route22.asm"
Route22Blocks: INCBIN "maps/route22.blk"

#include "data/mapHeaders/route20.asm"
#include "data/mapObjects/route20.asm"
Route20Blocks: INCBIN "maps/route20.blk"

#include "data/mapHeaders/route23.asm"
#include "data/mapObjects/route23.asm"
Route23Blocks: INCBIN "maps/route23.blk"

#include "data/mapHeaders/route24.asm"
#include "data/mapObjects/route24.asm"
Route24Blocks: INCBIN "maps/route24.blk"

#include "data/mapHeaders/route25.asm"
#include "data/mapObjects/route25.asm"
Route25Blocks: INCBIN "maps/route25.blk"

#include "data/mapHeaders/indigoplateau.asm"
#include "scripts/indigoplateau.asm"
#include "data/mapObjects/indigoplateau.asm"
IndigoPlateauBlocks: INCBIN "maps/indigoplateau.blk"

#include "data/mapHeaders/saffroncity.asm"
#include "data/mapObjects/saffroncity.asm"
SaffronCityBlocks: INCBIN "maps/saffroncity.blk"
#include "scripts/saffroncity.asm"

#include "scripts/route20.asm"
#include "scripts/route22.asm"
#include "scripts/route23.asm"
#include "scripts/route24.asm"
#include "scripts/route25.asm"

#include "data/mapHeaders/victoryroad2.asm"
#include "scripts/victoryroad2.asm"
#include "data/mapObjects/victoryroad2.asm"
VictoryRoad2Blocks: INCBIN "maps/victoryroad2.blk"

#include "data/mapHeaders/mtmoon2.asm"
#include "scripts/mtmoon2.asm"
#include "data/mapObjects/mtmoon2.asm"
MtMoon2Blocks: INCBIN "maps/mtmoon2.blk"

#include "data/mapHeaders/silphco7.asm"
#include "scripts/silphco7.asm"
#include "data/mapObjects/silphco7.asm"
SilphCo7Blocks: INCBIN "maps/silphco7.blk"

#include "data/mapHeaders/mansion2.asm"
#include "scripts/mansion2.asm"
#include "data/mapObjects/mansion2.asm"
Mansion2Blocks: INCBIN "maps/mansion2.blk"

#include "data/mapHeaders/mansion3.asm"
#include "scripts/mansion3.asm"
#include "data/mapObjects/mansion3.asm"
Mansion3Blocks: INCBIN "maps/mansion3.blk"

#include "data/mapHeaders/mansion4.asm"
#include "scripts/mansion4.asm"
#include "data/mapObjects/mansion4.asm"
Mansion4Blocks: INCBIN "maps/mansion4.blk"

#include "engine/battle/init_battle_variables.asm"
#include "engine/battle/moveEffects/paralyze_effect.asm"

#include "engine/overworld/card_key.asm"

#include "engine/menu/prize_menu.asm"

#include "engine/hidden_object_functions14.asm"


SECTION "bank15",ROMX,BANK[$15]

#include "data/mapHeaders/route2.asm"
#include "data/mapObjects/route2.asm"
Route2Blocks: INCBIN "maps/route2.blk"

#include "data/mapHeaders/route3.asm"
#include "data/mapObjects/route3.asm"
Route3Blocks: INCBIN "maps/route3.blk"

#include "data/mapHeaders/route4.asm"
#include "data/mapObjects/route4.asm"
Route4Blocks: INCBIN "maps/route4.blk"

#include "data/mapHeaders/route5.asm"
#include "data/mapObjects/route5.asm"
Route5Blocks: INCBIN "maps/route5.blk"

#include "data/mapHeaders/route9.asm"
#include "data/mapObjects/route9.asm"
Route9Blocks: INCBIN "maps/route9.blk"

#include "data/mapHeaders/route13.asm"
#include "data/mapObjects/route13.asm"
Route13Blocks: INCBIN "maps/route13.blk"

#include "data/mapHeaders/route14.asm"
#include "data/mapObjects/route14.asm"
Route14Blocks: INCBIN "maps/route14.blk"

#include "data/mapHeaders/route17.asm"
#include "data/mapObjects/route17.asm"
Route17Blocks: INCBIN "maps/route17.blk"

#include "data/mapHeaders/route19.asm"
#include "data/mapObjects/route19.asm"
Route19Blocks: INCBIN "maps/route19.blk"

#include "data/mapHeaders/route21.asm"
#include "data/mapObjects/route21.asm"
Route21Blocks: INCBIN "maps/route21.blk"

VermilionHouse2Blocks:
Route12HouseBlocks:
DayCareMBlocks: INCBIN "maps/daycarem.blk"

FuchsiaHouse3Blocks: INCBIN "maps/fuchsiahouse3.blk"

#include "engine/battle/experience.asm"

#include "scripts/route2.asm"
#include "scripts/route3.asm"
#include "scripts/route4.asm"
#include "scripts/route5.asm"
#include "scripts/route9.asm"
#include "scripts/route13.asm"
#include "scripts/route14.asm"
#include "scripts/route17.asm"
#include "scripts/route19.asm"
#include "scripts/route21.asm"

#include "data/mapHeaders/vermilionhouse2.asm"
#include "scripts/vermilionhouse2.asm"
#include "data/mapObjects/vermilionhouse2.asm"

#include "data/mapHeaders/celadonmart2.asm"
#include "scripts/celadonmart2.asm"
#include "data/mapObjects/celadonmart2.asm"
CeladonMart2Blocks: INCBIN "maps/celadonmart2.blk"

#include "data/mapHeaders/fuchsiahouse3.asm"
#include "scripts/fuchsiahouse3.asm"
#include "data/mapObjects/fuchsiahouse3.asm"

#include "data/mapHeaders/daycarem.asm"
#include "scripts/daycarem.asm"
#include "data/mapObjects/daycarem.asm"

#include "data/mapHeaders/route12house.asm"
#include "scripts/route12house.asm"
#include "data/mapObjects/route12house.asm"

#include "data/mapHeaders/silphco8.asm"
#include "scripts/silphco8.asm"
#include "data/mapObjects/silphco8.asm"
SilphCo8Blocks: INCBIN "maps/silphco8.blk"

#include "engine/menu/diploma.asm"

#include "engine/overworld/trainers.asm"


SECTION "bank16",ROMX,BANK[$16]

#include "data/mapHeaders/route6.asm"
#include "data/mapObjects/route6.asm"
Route6Blocks: INCBIN "maps/route6.blk"

#include "data/mapHeaders/route8.asm"
#include "data/mapObjects/route8.asm"
Route8Blocks: INCBIN "maps/route8.blk"

#include "data/mapHeaders/route10.asm"
#include "data/mapObjects/route10.asm"
Route10Blocks: INCBIN "maps/route10.blk"

#include "data/mapHeaders/route11.asm"
#include "data/mapObjects/route11.asm"
Route11Blocks: INCBIN "maps/route11.blk"

#include "data/mapHeaders/route12.asm"
#include "data/mapObjects/route12.asm"
Route12Blocks: INCBIN "maps/route12.blk"

#include "data/mapHeaders/route15.asm"
#include "data/mapObjects/route15.asm"
Route15Blocks: INCBIN "maps/route15.blk"

#include "data/mapHeaders/route16.asm"
#include "data/mapObjects/route16.asm"
Route16Blocks: INCBIN "maps/route16.blk"

#include "data/mapHeaders/route18.asm"
#include "data/mapObjects/route18.asm"
Route18Blocks: INCBIN "maps/route18.blk"

	INCBIN "maps/unusedblocks58d7d.blk"

#include "engine/battle/common_text.asm"

#include "engine/experience.asm"

#include "engine/overworld/oaks_aide.asm"

#include "scripts/route6.asm"
#include "scripts/route8.asm"
#include "scripts/route10.asm"
#include "scripts/route11.asm"
#include "scripts/route12.asm"
#include "scripts/route15.asm"
#include "scripts/route16.asm"
#include "scripts/route18.asm"

#include "data/mapHeaders/fanclub.asm"
#include "scripts/fanclub.asm"
#include "data/mapObjects/fanclub.asm"
FanClubBlocks:
	INCBIN "maps/fanclub.blk"

#include "data/mapHeaders/silphco2.asm"
#include "scripts/silphco2.asm"
#include "data/mapObjects/silphco2.asm"
SilphCo2Blocks:
	INCBIN "maps/silphco2.blk"

#include "data/mapHeaders/silphco3.asm"
#include "scripts/silphco3.asm"
#include "data/mapObjects/silphco3.asm"
SilphCo3Blocks:
	INCBIN "maps/silphco3.blk"

#include "data/mapHeaders/silphco10.asm"
#include "scripts/silphco10.asm"
#include "data/mapObjects/silphco10.asm"
SilphCo10Blocks:
	INCBIN "maps/silphco10.blk"

#include "data/mapHeaders/lance.asm"
#include "scripts/lance.asm"
#include "data/mapObjects/lance.asm"
LanceBlocks:
	INCBIN "maps/lance.blk"

#include "data/mapHeaders/halloffameroom.asm"
#include "scripts/halloffameroom.asm"
#include "data/mapObjects/halloffameroom.asm"
HallofFameRoomBlocks:
	INCBIN "maps/halloffameroom.blk"

#include "engine/overworld/saffron_guards.asm"


SECTION "bank17",ROMX,BANK[$17]

SaffronMartBlocks:
LavenderMartBlocks:
CeruleanMartBlocks:
VermilionMartBlocks: INCBIN "maps/vermilionmart.blk"

CopycatsHouse2FBlocks:
RedsHouse2FBlocks: INCBIN "maps/redshouse2f.blk"

Museum1FBlocks: INCBIN "maps/museum1f.blk"

Museum2FBlocks: INCBIN "maps/museum2f.blk"

SaffronPokecenterBlocks:
VermilionPokecenterBlocks:
LavenderPokecenterBlocks:
PewterPokecenterBlocks: INCBIN "maps/pewterpokecenter.blk"

UndergroundPathEntranceRoute7Blocks:
UndergroundPathEntranceRoute7CopyBlocks:
UndergroundPathEntranceRoute6Blocks:
UndergroundPathEntranceRoute5Blocks: INCBIN "maps/undergroundpathentranceroute5.blk"

Route2GateBlocks:
ViridianForestEntranceBlocks:
ViridianForestExitBlocks: INCBIN "maps/viridianforestexit.blk"

#include "data/mapHeaders/redshouse2f.asm"
#include "scripts/redshouse2f.asm"
#include "data/mapObjects/redshouse2f.asm"

#include "engine/predefs17.asm"

#include "data/mapHeaders/museum1f.asm"
#include "scripts/museum1f.asm"
#include "data/mapObjects/museum1f.asm"

#include "data/mapHeaders/museum2f.asm"
#include "scripts/museum2f.asm"
#include "data/mapObjects/museum2f.asm"

#include "data/mapHeaders/pewtergym.asm"
#include "scripts/pewtergym.asm"
#include "data/mapObjects/pewtergym.asm"
PewterGymBlocks: INCBIN "maps/pewtergym.blk"

#include "data/mapHeaders/pewterpokecenter.asm"
#include "scripts/pewterpokecenter.asm"
#include "data/mapObjects/pewterpokecenter.asm"

#include "data/mapHeaders/ceruleanpokecenter.asm"
#include "scripts/ceruleanpokecenter.asm"
#include "data/mapObjects/ceruleanpokecenter.asm"
CeruleanPokecenterBlocks: INCBIN "maps/ceruleanpokecenter.blk"

#include "data/mapHeaders/ceruleangym.asm"
#include "scripts/ceruleangym.asm"
#include "data/mapObjects/ceruleangym.asm"
CeruleanGymBlocks: INCBIN "maps/ceruleangym.blk"

#include "data/mapHeaders/ceruleanmart.asm"
#include "scripts/ceruleanmart.asm"
#include "data/mapObjects/ceruleanmart.asm"

#include "data/mapHeaders/lavenderpokecenter.asm"
#include "scripts/lavenderpokecenter.asm"
#include "data/mapObjects/lavenderpokecenter.asm"

#include "data/mapHeaders/lavendermart.asm"
#include "scripts/lavendermart.asm"
#include "data/mapObjects/lavendermart.asm"

#include "data/mapHeaders/vermilionpokecenter.asm"
#include "scripts/vermilionpokecenter.asm"
#include "data/mapObjects/vermilionpokecenter.asm"

#include "data/mapHeaders/vermilionmart.asm"
#include "scripts/vermilionmart.asm"
#include "data/mapObjects/vermilionmart.asm"

#include "data/mapHeaders/vermiliongym.asm"
#include "scripts/vermiliongym.asm"
#include "data/mapObjects/vermiliongym.asm"
VermilionGymBlocks: INCBIN "maps/vermiliongym.blk"

#include "data/mapHeaders/copycatshouse2f.asm"
#include "scripts/copycatshouse2f.asm"
#include "data/mapObjects/copycatshouse2f.asm"

#include "data/mapHeaders/fightingdojo.asm"
#include "scripts/fightingdojo.asm"
#include "data/mapObjects/fightingdojo.asm"
FightingDojoBlocks: INCBIN "maps/fightingdojo.blk"

#include "data/mapHeaders/saffrongym.asm"
#include "scripts/saffrongym.asm"
#include "data/mapObjects/saffrongym.asm"
SaffronGymBlocks: INCBIN "maps/saffrongym.blk"

#include "data/mapHeaders/saffronmart.asm"
#include "scripts/saffronmart.asm"
#include "data/mapObjects/saffronmart.asm"

#include "data/mapHeaders/silphco1.asm"
#include "scripts/silphco1.asm"
#include "data/mapObjects/silphco1.asm"
SilphCo1Blocks: INCBIN "maps/silphco1.blk"

#include "data/mapHeaders/saffronpokecenter.asm"
#include "scripts/saffronpokecenter.asm"
#include "data/mapObjects/saffronpokecenter.asm"

#include "data/mapHeaders/viridianforestexit.asm"
#include "scripts/viridianforestexit.asm"
#include "data/mapObjects/viridianforestexit.asm"

#include "data/mapHeaders/route2gate.asm"
#include "scripts/route2gate.asm"
#include "data/mapObjects/route2gate.asm"

#include "data/mapHeaders/viridianforestentrance.asm"
#include "scripts/viridianforestentrance.asm"
#include "data/mapObjects/viridianforestentrance.asm"

#include "data/mapHeaders/undergroundpathentranceroute5.asm"
#include "scripts/undergroundpathentranceroute5.asm"
#include "data/mapObjects/undergroundpathentranceroute5.asm"

#include "data/mapHeaders/undergroundpathentranceroute6.asm"
#include "scripts/undergroundpathentranceroute6.asm"
#include "data/mapObjects/undergroundpathentranceroute6.asm"

#include "data/mapHeaders/undergroundpathentranceroute7.asm"
#include "scripts/undergroundpathentranceroute7.asm"
#include "data/mapObjects/undergroundpathentranceroute7.asm"

#include "data/mapHeaders/undergroundpathentranceroute7copy.asm"
#include "scripts/undergroundpathentranceroute7copy.asm"
#include "data/mapObjects/undergroundpathentranceroute7copy.asm"

#include "data/mapHeaders/silphco9.asm"
#include "scripts/silphco9.asm"
#include "data/mapObjects/silphco9.asm"
SilphCo9Blocks: INCBIN "maps/silphco9.blk"

#include "data/mapHeaders/victoryroad1.asm"
#include "scripts/victoryroad1.asm"
#include "data/mapObjects/victoryroad1.asm"
VictoryRoad1Blocks: INCBIN "maps/victoryroad1.blk"

#include "engine/predefs17_2.asm"

#include "engine/hidden_object_functions17.asm"


SECTION "bank18",ROMX,BANK[$18]

ViridianForestBlocks:    INCBIN "maps/viridianforest.blk"
UndergroundPathNSBlocks: INCBIN "maps/undergroundpathns.blk"
UndergroundPathWEBlocks: INCBIN "maps/undergroundpathwe.blk"

	INCBIN "maps/unusedblocks60258.blk"

SSAnne10Blocks:
SSAnne9Blocks: INCBIN "maps/ssanne9.blk"

#include "data/mapHeaders/pokemontower1.asm"
#include "scripts/pokemontower1.asm"
#include "data/mapObjects/pokemontower1.asm"
PokemonTower1Blocks: INCBIN "maps/pokemontower1.blk"

#include "data/mapHeaders/pokemontower2.asm"
#include "scripts/pokemontower2.asm"
#include "data/mapObjects/pokemontower2.asm"
PokemonTower2Blocks: INCBIN "maps/pokemontower2.blk"

#include "data/mapHeaders/pokemontower3.asm"
#include "scripts/pokemontower3.asm"
#include "data/mapObjects/pokemontower3.asm"
PokemonTower3Blocks: INCBIN "maps/pokemontower3.blk"

#include "data/mapHeaders/pokemontower4.asm"
#include "scripts/pokemontower4.asm"
#include "data/mapObjects/pokemontower4.asm"
PokemonTower4Blocks: INCBIN "maps/pokemontower4.blk"

#include "data/mapHeaders/pokemontower5.asm"
#include "scripts/pokemontower5.asm"
#include "data/mapObjects/pokemontower5.asm"
PokemonTower5Blocks: INCBIN "maps/pokemontower5.blk"

#include "data/mapHeaders/pokemontower6.asm"
#include "scripts/pokemontower6.asm"
#include "data/mapObjects/pokemontower6.asm"
PokemonTower6Blocks: INCBIN "maps/pokemontower6.blk"

	INCBIN "maps/unusedblocks60cef.blk"

#include "data/mapHeaders/pokemontower7.asm"
#include "scripts/pokemontower7.asm"
#include "data/mapObjects/pokemontower7.asm"
PokemonTower7Blocks: INCBIN "maps/pokemontower7.blk"

#include "data/mapHeaders/celadonmart1.asm"
#include "scripts/celadonmart1.asm"
#include "data/mapObjects/celadonmart1.asm"
CeladonMart1Blocks: INCBIN "maps/celadonmart1.blk"

#include "engine/overworld/cinnabar_lab.asm"

#include "data/mapHeaders/viridianforest.asm"
#include "scripts/viridianforest.asm"
#include "data/mapObjects/viridianforest.asm"

#include "data/mapHeaders/ssanne1.asm"
#include "scripts/ssanne1.asm"
#include "data/mapObjects/ssanne1.asm"
SSAnne1Blocks: INCBIN "maps/ssanne1.blk"

#include "data/mapHeaders/ssanne2.asm"
#include "scripts/ssanne2.asm"
#include "data/mapObjects/ssanne2.asm"
SSAnne2Blocks: INCBIN "maps/ssanne2.blk"

#include "data/mapHeaders/ssanne4.asm"
#include "scripts/ssanne4.asm"
#include "data/mapObjects/ssanne4.asm"
SSAnne4Blocks: INCBIN "maps/ssanne4.blk"

#include "data/mapHeaders/ssanne5.asm"
#include "scripts/ssanne5.asm"
#include "data/mapObjects/ssanne5.asm"
SSAnne5Blocks: INCBIN "maps/ssanne5.blk"

#include "data/mapHeaders/ssanne6.asm"
#include "scripts/ssanne6.asm"
#include "data/mapObjects/ssanne6.asm"
SSAnne6Blocks: INCBIN "maps/ssanne6.blk"

#include "data/mapHeaders/ssanne7.asm"
#include "scripts/ssanne7.asm"
#include "data/mapObjects/ssanne7.asm"
SSAnne7Blocks: INCBIN "maps/ssanne7.blk"

#include "data/mapHeaders/ssanne8.asm"
#include "scripts/ssanne8.asm"
#include "data/mapObjects/ssanne8.asm"
SSAnne8Blocks: INCBIN "maps/ssanne8.blk"

#include "data/mapHeaders/ssanne9.asm"
#include "scripts/ssanne9.asm"
#include "data/mapObjects/ssanne9.asm"

#include "data/mapHeaders/ssanne10.asm"
#include "scripts/ssanne10.asm"
#include "data/mapObjects/ssanne10.asm"

#include "data/mapHeaders/undergroundpathns.asm"
#include "scripts/undergroundpathns.asm"
#include "data/mapObjects/undergroundpathns.asm"

#include "data/mapHeaders/undergroundpathwe.asm"
#include "scripts/undergroundpathwe.asm"
#include "data/mapObjects/undergroundpathwe.asm"

#include "data/mapHeaders/diglettscave.asm"
#include "scripts/diglettscave.asm"
#include "data/mapObjects/diglettscave.asm"
DiglettsCaveBlocks: INCBIN "maps/diglettscave.blk"

#include "data/mapHeaders/silphco11.asm"
#include "scripts/silphco11.asm"
#include "data/mapObjects/silphco11.asm"
SilphCo11Blocks: INCBIN "maps/silphco11.blk"

#include "engine/hidden_object_functions18.asm"


SECTION "bank19",ROMX,BANK[$19]

Overworld_GFX:     INCBIN "gfx/tilesets/overworld.t2.2bpp"
Overworld_Block:   INCBIN "gfx/blocksets/overworld.bst"

RedsHouse1_GFX:
RedsHouse2_GFX:    INCBIN "gfx/tilesets/reds_house.t7.2bpp"
RedsHouse1_Block:
RedsHouse2_Block:  INCBIN "gfx/blocksets/reds_house.bst"

House_GFX:         INCBIN "gfx/tilesets/house.t2.2bpp"
House_Block:       INCBIN "gfx/blocksets/house.bst"
Mansion_GFX:       INCBIN "gfx/tilesets/mansion.t2.2bpp"
Mansion_Block:     INCBIN "gfx/blocksets/mansion.bst"
ShipPort_GFX:      INCBIN "gfx/tilesets/ship_port.t2.2bpp"
ShipPort_Block:    INCBIN "gfx/blocksets/ship_port.bst"
Interior_GFX:      INCBIN "gfx/tilesets/interior.t1.2bpp"
Interior_Block:    INCBIN "gfx/blocksets/interior.bst"
Plateau_GFX:       INCBIN "gfx/tilesets/plateau.t10.2bpp"
Plateau_Block:     INCBIN "gfx/blocksets/plateau.bst"


SECTION "bank1A",ROMX,BANK[$1A]

#include "engine/battle/decrement_pp.asm"

Version_GFX:
IF DEF(_RED)
	INCBIN "gfx/red/redgreenversion.1bpp" // 10 tiles
ENDC
IF DEF(_BLUE)
	INCBIN "gfx/blue/blueversion.1bpp" // 8 tiles
ENDC
Version_GFXEnd:

Dojo_GFX:
Gym_GFX:           INCBIN "gfx/tilesets/gym.2bpp"
Dojo_Block:
Gym_Block:         INCBIN "gfx/blocksets/gym.bst"

Mart_GFX:
Pokecenter_GFX:    INCBIN "gfx/tilesets/pokecenter.2bpp"
Mart_Block:
Pokecenter_Block:  INCBIN "gfx/blocksets/pokecenter.bst"

ForestGate_GFX:
Museum_GFX:
Gate_GFX:          INCBIN "gfx/tilesets/gate.t1.2bpp"
ForestGate_Block:
Museum_Block:
Gate_Block:        INCBIN "gfx/blocksets/gate.bst"

Forest_GFX:        INCBIN "gfx/tilesets/forest.2bpp"
Forest_Block:      INCBIN "gfx/blocksets/forest.bst"
Facility_GFX:      INCBIN "gfx/tilesets/facility.2bpp"
Facility_Block:    INCBIN "gfx/blocksets/facility.bst"


SECTION "bank1B",ROMX,BANK[$1B]

Cemetery_GFX:      INCBIN "gfx/tilesets/cemetery.t4.2bpp"
Cemetery_Block:    INCBIN "gfx/blocksets/cemetery.bst"
Cavern_GFX:        INCBIN "gfx/tilesets/cavern.t14.2bpp"
Cavern_Block:      INCBIN "gfx/blocksets/cavern.bst"
Lobby_GFX:         INCBIN "gfx/tilesets/lobby.t2.2bpp"
Lobby_Block:       INCBIN "gfx/blocksets/lobby.bst"
Ship_GFX:          INCBIN "gfx/tilesets/ship.t6.2bpp"
Ship_Block:        INCBIN "gfx/blocksets/ship.bst"
Lab_GFX:           INCBIN "gfx/tilesets/lab.t4.2bpp"
Lab_Block:         INCBIN "gfx/blocksets/lab.bst"
Club_GFX:          INCBIN "gfx/tilesets/club.t5.2bpp"
Club_Block:        INCBIN "gfx/blocksets/club.bst"
Underground_GFX:   INCBIN "gfx/tilesets/underground.t7.2bpp"
Underground_Block: INCBIN "gfx/blocksets/underground.bst"


SECTION "bank1C",ROMX,BANK[$1C]

#include "engine/gamefreak.asm"
#include "engine/hall_of_fame.asm"
#include "engine/overworld/healing_machine.asm"
#include "engine/overworld/player_animations.asm"
#include "engine/battle/ghost_marowak_anim.asm"
#include "engine/battle/battle_transitions.asm"
#include "engine/town_map.asm"
#include "engine/mon_party_sprites.asm"
#include "engine/in_game_trades.asm"
#include "engine/palettes.asm"
#include "engine/save.asm"


SECTION "bank1D",ROMX,BANK[$1D]

CopycatsHouse1FBlocks: INCBIN "maps/copycatshouse1f.blk"

CinnabarMartBlocks:
PewterMartBlocks: INCBIN "maps/pewtermart.blk"

FuchsiaHouse1Blocks: INCBIN "maps/fuchsiahouse1.blk"

CinnabarPokecenterBlocks:
FuchsiaPokecenterBlocks: INCBIN "maps/fuchsiapokecenter.blk"

CeruleanHouse2Blocks: INCBIN "maps/ceruleanhouse2.blk"

#include "engine/HoF_room_pc.asm"

#include "engine/status_ailments.asm"

#include "engine/items/itemfinder.asm"

#include "scripts/ceruleancity2.asm"

#include "data/mapHeaders/viridiangym.asm"
#include "scripts/viridiangym.asm"
#include "data/mapObjects/viridiangym.asm"
ViridianGymBlocks: INCBIN "maps/viridiangym.blk"

#include "data/mapHeaders/pewtermart.asm"
#include "scripts/pewtermart.asm"
#include "data/mapObjects/pewtermart.asm"

#include "data/mapHeaders/unknowndungeon1.asm"
#include "scripts/unknowndungeon1.asm"
#include "data/mapObjects/unknowndungeon1.asm"
UnknownDungeon1Blocks: INCBIN "maps/unknowndungeon1.blk"

#include "data/mapHeaders/ceruleanhouse2.asm"
#include "scripts/ceruleanhouse2.asm"
#include "data/mapObjects/ceruleanhouse2.asm"

#include "engine/menu/vending_machine.asm"

#include "data/mapHeaders/fuchsiahouse1.asm"
#include "scripts/fuchsiahouse1.asm"
#include "data/mapObjects/fuchsiahouse1.asm"

#include "data/mapHeaders/fuchsiapokecenter.asm"
#include "scripts/fuchsiapokecenter.asm"
#include "data/mapObjects/fuchsiapokecenter.asm"

#include "data/mapHeaders/fuchsiahouse2.asm"
#include "scripts/fuchsiahouse2.asm"
#include "data/mapObjects/fuchsiahouse2.asm"
FuchsiaHouse2Blocks: INCBIN "maps/fuchsiahouse2.blk"

#include "data/mapHeaders/safarizoneentrance.asm"
#include "scripts/safarizoneentrance.asm"
#include "data/mapObjects/safarizoneentrance.asm"
SafariZoneEntranceBlocks: INCBIN "maps/safarizoneentrance.blk"

#include "data/mapHeaders/fuchsiagym.asm"
#include "scripts/fuchsiagym.asm"
#include "data/mapObjects/fuchsiagym.asm"
FuchsiaGymBlocks: INCBIN "maps/fuchsiagym.blk"

#include "data/mapHeaders/fuchsiameetingroom.asm"
#include "scripts/fuchsiameetingroom.asm"
#include "data/mapObjects/fuchsiameetingroom.asm"
FuchsiaMeetingRoomBlocks: INCBIN "maps/fuchsiameetingroom.blk"

#include "data/mapHeaders/cinnabargym.asm"
#include "scripts/cinnabargym.asm"
#include "data/mapObjects/cinnabargym.asm"
CinnabarGymBlocks: INCBIN "maps/cinnabargym.blk"

#include "data/mapHeaders/lab1.asm"
#include "scripts/lab1.asm"
#include "data/mapObjects/lab1.asm"
Lab1Blocks: INCBIN "maps/lab1.blk"

#include "data/mapHeaders/lab2.asm"
#include "scripts/lab2.asm"
#include "data/mapObjects/lab2.asm"
Lab2Blocks: INCBIN "maps/lab2.blk"

#include "data/mapHeaders/lab3.asm"
#include "scripts/lab3.asm"
#include "data/mapObjects/lab3.asm"
Lab3Blocks: INCBIN "maps/lab3.blk"

#include "data/mapHeaders/lab4.asm"
#include "scripts/lab4.asm"
#include "data/mapObjects/lab4.asm"
Lab4Blocks: INCBIN "maps/lab4.blk"

#include "data/mapHeaders/cinnabarpokecenter.asm"
#include "scripts/cinnabarpokecenter.asm"
#include "data/mapObjects/cinnabarpokecenter.asm"

#include "data/mapHeaders/cinnabarmart.asm"
#include "scripts/cinnabarmart.asm"
#include "data/mapObjects/cinnabarmart.asm"

#include "data/mapHeaders/copycatshouse1f.asm"
#include "scripts/copycatshouse1f.asm"
#include "data/mapObjects/copycatshouse1f.asm"

#include "data/mapHeaders/gary.asm"
#include "scripts/gary.asm"
#include "data/mapObjects/gary.asm"
GaryBlocks: INCBIN "maps/gary.blk"

#include "data/mapHeaders/lorelei.asm"
#include "scripts/lorelei.asm"
#include "data/mapObjects/lorelei.asm"
LoreleiBlocks: INCBIN "maps/lorelei.blk"

#include "data/mapHeaders/bruno.asm"
#include "scripts/bruno.asm"
#include "data/mapObjects/bruno.asm"
BrunoBlocks: INCBIN "maps/bruno.blk"

#include "data/mapHeaders/agatha.asm"
#include "scripts/agatha.asm"
#include "data/mapObjects/agatha.asm"
AgathaBlocks: INCBIN "maps/agatha.blk"

#include "engine/menu/league_pc.asm"

#include "engine/overworld/hidden_items.asm"


SECTION "bank1E",ROMX,BANK[$1E]

#include "engine/battle/animations.asm"

#include "engine/overworld/cut2.asm"

#include "engine/overworld/ssanne.asm"

RedFishingTilesFront: INCBIN "gfx/red_fishing_tile_front.2bpp"
RedFishingTilesBack:  INCBIN "gfx/red_fishing_tile_back.2bpp"
RedFishingTilesSide:  INCBIN "gfx/red_fishing_tile_side.2bpp"
RedFishingRodTiles:   INCBIN "gfx/red_fishingrod_tiles.2bpp"

#include "data/animations.asm"

#include "engine/evolution.asm"

#include "engine/overworld/elevator.asm"

#include "engine/items/tm_prices.asm"
