-- Rockstar's Los Santos Customs interior at Burton (v_carmod) overlaps the WHIPLASH shop. Its placement maps are
-- overridden by this resource, but GTA registers the interior when the game loads, so it is still created: its walls
-- stood invisibly inside the shop (the tool room doorway, in front of the paint booth). Switch that one interior off
-- on this client. Matched by type, name and position, so the airport's LS Customs (also v_carmod) is untouched.

local LSC = vector3(-342.73273, -131.93828, 38.03795)
local LSC_HASH = `v_carmod`

local function burtonLsc()
    local id = GetInteriorAtCoordsWithType(LSC.x, LSC.y, LSC.z, 'v_carmod')
    if not id or id == 0 then return nil end
    local pos, hash = GetInteriorLocationAndNamehash(id)
    if (hash & 0xFFFFFFFF) ~= (LSC_HASH & 0xFFFFFFFF) or #(pos - LSC) > 2.0 then return nil end   -- signed or not
    return id
end

CreateThread(function()
    while true do
        local id = burtonLsc()
        if id and not IsInteriorDisabled(id) then       -- BOOL natives answer 1 / false on Enhanced: truthiness only
            DisableInterior(id, true)
            print('[whip_autos_shop] disabled the Los Santos Customs interior at Burton (it overlaps the shop)')
        end
        Wait(id and 30000 or 5000)
    end
end)

-- The shop's doors are GTA's own automatic doors: GTA opens and shuts them, and nothing registers them in the door
-- system (whip_core owns that). (Up to 1.0.0 this file woke them every frame near a player, as GTA's doors fell asleep
-- at high frame rates. FiveM fixed that on Legacy (citizenfx/fivem#4058), and FiveM for GTAV Enhanced does not do it
-- either: tested 16 Nov 2026.)
-- F8: whiplash_doors (where the doors are, and the roller door's far stand-in).
local DOORS = {
    { name = 'whiplash_shop_door', pos = vector3(-349.824, -117.245, 38.103), search = 6.0 },   -- roller, slides up
    { name = 'whiplash_spray_door', pos = vector3(-338.129, -125.069, 39.177), search = 4.0 },  -- paint booth
}

local function u32(h) return h % 4294967296 end          -- hashes come back signed or unsigned
for _, d in ipairs(DOORS) do d.hash = u32(GetHashKey(d.name)) end

local function doorObject(d)                               -- the door's object, while GTA has it created
    if d.obj and DoesEntityExist(d.obj) and u32(GetEntityModel(d.obj)) == d.hash then return d.obj end
    d.obj = nil
    local now = GetGameTimer()
    if d.retryAt and now < d.retryAt then return nil end   -- not there: look again 4 times a second, not every frame
    local o = GetClosestObjectOfType(d.pos.x, d.pos.y, d.pos.z, d.search, d.hash, false, false, false)
    d.obj = (o and o ~= 0) and o or nil
    d.retryAt = not d.obj and now + 250 or nil
    return d.obj
end

-- The roller door's far stand-in. The real door hangs on the shop's doorway portal, as Rockstar's garage doors do
-- (Michael's, LS Customs', Benny's), so it only exists while the interior is loaded (within about 50 m). From further
-- away a static copy in a world map (whiplash_shop_door_far: same model, no collision) fills the doorway. While the
-- real door object exists the copy is hidden here, so a shut copy never shows over the open door.
local FAR_MODEL = u32(GetHashKey('whiplash_shop_door_far'))
local FAR_CHECK = 120.0                     -- m: look for the real door this close (it streams in at about 50 m)
local farHidden = false

local function setFarHidden(hide)
    local d = DOORS[1]
    if hide then
        CreateModelHide(d.pos.x, d.pos.y, d.pos.z, 3.0, FAR_MODEL, true)
    else
        RemoveModelHide(d.pos.x, d.pos.y, d.pos.z, 3.0, FAR_MODEL, false)
    end
    farHidden = hide
end

CreateThread(function()
    local d = DOORS[1]
    while true do
        local close = #(GetEntityCoords(PlayerPedId()) - d.pos) < FAR_CHECK
        local real = close and doorObject(d) or nil
        if real and not farHidden then setFarHidden(true)
        elseif not real and farHidden then setFarHidden(false) end
        Wait(close and 250 or 1000)
    end
end)

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() and farHidden then setFarHidden(false) end
end)

RegisterCommand('whiplash_doors', function()
    local ped = PlayerPedId()
    local p = GetEntityCoords(ped)
    print(('[whip_autos_shop] the shop\'s doors; you: interior %d room %d'):format(
        GetInteriorFromEntity(ped), GetRoomKeyFromEntity(ped)))
    for _, d in ipairs(DOORS) do
        d.retryAt = nil
        local o = doorObject(d)
        if o then
            print(('  %s: object %d, you %.1f m away, moved %.2f m from shut'):format(d.name, o, #(p - d.pos),
                #(GetEntityCoords(o) - d.pos)))
        else
            print(('  %s: no object (you %.1f m away)'):format(d.name, #(p - d.pos)))
        end
    end
    print(('  roller door far stand-in: %s'):format(farHidden and 'hidden (the real door is there)' or 'showing'))
end, false)
