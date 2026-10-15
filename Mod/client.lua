exports.spawnmanager:setAutoSpawn(true)

local spawnpoint = vector3(143.5, -2450, 5)
local dropzone = vector3(172, -2388, 5)
Vhc = 0
MissionIndex = 1

MissionList = {}
MissionList[1] = { "Tutorial", "Collect your first body", 877.344788, -2380.534180, 27.957920 }

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
    Utils.Mission()
end)

CreateThread(function()
    while true do
        if IsEntityAtCoord(GetPlayerPed(-1), 172, -2388, 5, 5, 5, 5, true, false, 1) and BodyFound == true then
            BodyFound = false
            print("Drop off successful")
            BodyPosX, BodyPosY = Utils.FindBodyLoc()
            Utils.SpawnDeidMan(BodyPosX, BodyPosY, 0.0)
            RemoveBlip(DropOffBlip)
        end
        Wait(5)
    end
end)
