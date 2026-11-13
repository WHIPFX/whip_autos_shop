fx_version 'cerulean'
game 'gta5'
lua54 'yes'   -- client.lua uses & (Lua 5.3+)

name 'whip_autos_shop'
description 'The WHIPLASH drive-in shop building in Burton, for whip_autos (Whiplash). Map files, and one small client script.'
author '3D Clanker, for Whippy'
version '1.0.0'

-- Rockstar's Tuners Auto Shop inside the Los Santos Customs building in Burton, entered from the car park through
-- its roller door. stream/ is for Legacy servers and stream_enhanced/ for Enhanced (Enhanced reads it instead of
-- stream/). They also hold the 12 Rockstar bt1_02 files this building replaces, so no other resource may stream those
-- names. LS Customs Burton is gone.
--
-- It is its own resource and depends on nothing, so restarting whip_core or whip_autos leaves it alone. Restarting
-- THIS resource while players are in game crashes their games (an interior unloading under them): restart the whole
-- server instead. Start it with `ensure whip_autos_shop` in server.cfg.
--
-- The roller door is GTA's own (Rockstar's style 8 door, in its own small map whiplash_shop_ext, drawn to 160 m): it
-- opens for anyone on foot or in a car and shuts by itself. So does the paint booth's door (whiplash_spray_door, a GTA
-- garage door like LS Customs' spray door). Neither is in whip's door system. To lock it, register model whiplash_shop_door at (-349.824, -117.245, 38.103).
-- Interior proxy order slot 5300 (whippy_mirror_park_homes uses 5000-5094).

files {
    'whiplash_shop_interiorproxies.meta',
    'data/whiplash_shop_timecycle.xml',
}

data_file 'DLC_ITYP_REQUEST' 'stream/whiplash_shop.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/whiplash_shop_ext.ytyp'   -- the roller door, a world entity in its own map
data_file 'INTERIOR_PROXY_ORDER_FILE' 'whiplash_shop_interiorproxies.meta'
-- The shop's own timecycle (whiplash_shop_tc, named by both rooms in whiplash_shop.ytyp): Rockstar's Auto Shop one
-- without its two zero sky-light lines, which turned the street seen from inside black. In data/, not stream/: on
-- Enhanced nothing from stream/ may go in files {}.
data_file 'TIMECYCLEMOD_FILE' 'data/whiplash_shop_timecycle.xml'

-- Switches off Rockstar's Los Santos Customs interior at Burton on each game (GTA registers it at load whatever its maps
-- say, and its walls stood invisibly in the shop). Only that one: the airport's is left alone. And keeps the shop's
-- roller and paint booth doors awake while a player is within 12 m (GTA's high frame rate door bug; F8 whiplash_doors).
client_script 'client.lua'
