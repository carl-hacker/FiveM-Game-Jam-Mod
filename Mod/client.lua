exports.spawnmanager:setAutoSpawn(true)

local spawnpoint = vector3(143.5, -2450, 5)
local dropzone = vector3(172, -2388, 5)
Vhc = 0

exports.spawnmanager:setAutoSpawnCallback(function()
    exports.spawnmanager:spawnPlayer({
        x = spawnpoint.x,
        y = spawnpoint.y,
        z = spawnpoint.z,
        model = 'csb_trafficwarden',
    })
    return true
end)


--Spawn Player in Vehicle:
AddEventHandler("playerSpawned", function()
    Utils.RemoveVehicle(Vhc)
    print("spawned")
    Utils.SpawnVehicle("trash", 300)
    Mission()
end)

RegisterKeyMapping("BagUp", "Bag up 'trash'", "keyboard", "b")

CreateThread(function()
    while true do
        if IsEntityAtCoord(GetPlayerPed(-1), 143.5, -2450.0, 5.0, 5, 5, 5, true, false, 1) and BodyFound == true then
            BodyFound = false
            print("Drop off successful")
            BodyPosX, BodyPosY = Utils.FindBodyLoc()
            Utils.SpawnDeidMan(BodyPosX, BodyPosY, 0.0)
            RemoveBlip(DropOffBlip)
        end
        Wait(5)
    end
end)
