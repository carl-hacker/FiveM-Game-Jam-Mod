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

--Missions:
function Mission()
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
    ScaleformMovieMethodAddParamPlayerNameString("MISSION")
    ScaleformMovieMethodAddParamPlayerNameString("Do Something")
    EndScaleformMovieMethod()

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-- Spawning dead bodies

function SpawnDeidMan(x, y, z)
    RequestModel(GetHashKey("a_m_m_beach_02"))
    UnfortunateSoul = CreatePed(0, GetHashKey("a_m_m_beach_02"), x, y, z, 180.0, false, false)
    SetEntityHealth(UnfortunateSoul, 0)
    AddBlipForEntity(UnfortunateSoul)
    BodyFound = false
end

function FindBodyLoc()
    RanX = math.random(-4000.0, 6000.0)
    RanY = math.random(-4000.0, 8000.0)
    X, FoundPos = GetSafeCoordForPed(RanX, RanY, 0.0, true, 2)
    return FoundPos.x, FoundPos.y
end

BodyPosX, BodyPosY = FindBodyLoc()
SpawnDeidMan(BodyPosX, BodyPosY, 0.0)

RegisterKeyMapping("BagUp", "Bag up 'trash'", "keyboard", "b")

RegisterCommand("BagUp", function()
    PlayerCoord = GetEntityCoords(GetPlayerPed(-1))
    TargetCoord = GetEntityCoords(UnfortunateSoul)
    if GetDistanceBetweenCoords(playerCoord.x, playerCoord.y, playerCoord.z, TargetCoord.x, TargetCoord.y, TargetCoord.z, true) < 5 then
        DeleteEntity(UnfortunateSoul)
        RequestModel(GetHashKey("p_Binbag_01_s"))
        -- Hash for a custom pickup
        Binbag = CreatePickup(738282662, TargetCoord.x, TargetCoord.y, TargetCoord.z, 1, 1, true,
            GetHashKey("p_Binbag_01_s"))
        BodyFound = true
        DropOffBlip = AddBlipForCoord(143.5, -2450.0, 5.0)
    end
end, false)

CreateThread(function()
    while true do
        if IsEntityAtCoord(GetPlayerPed(-1), 143.5, -2450.0, 5.0, 5, 5, 5, true, false, 1) and BodyFound == true then
            BodyFound = false
            print("Drop off successful")
            BodyPosX, BodyPosY = FindBodyLoc()
            SpawnDeidMan(BodyPosX, BodyPosY, 0.0)
            RemoveBlip(DropOffBlip)
        end
        Wait(5)
    end
end)
