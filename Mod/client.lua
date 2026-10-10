exports.spawnmanager:setAutoSpawn(true)

local spawnpoint = vector3(143.5, -2450, 5)
local dropzone = vector3(172, -2388, 5)

--Coords:
RegisterCommand("coords", function()
    local ped = GetPlayerPed(-1)
    local csd = GetEntityCoords(ped)
    print(csd)
end, false)

exports.spawnmanager:setAutoSpawnCallback(function()
    exports.spawnmanager:spawnPlayer({
        x = spawnpoint.x,
        y = spawnpoint.y,
        z = spawnpoint.z,
        model = 'csb_trafficwarden' -- Replace with your desired ped model or remove to keep current
    }, function()
        -- Optional: Code to run after the player has spawned
        TriggerEvent('chat:addMessage', {
            args = { 'Respawn', 'You have respawned at the designated location.' }
        })
    end)

    return true
end)

--Missions:
RegisterCommand("start", function()
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
end, false)
