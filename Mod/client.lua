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

TutorialActive = true

--Spawn Player in Vehicle:
AddEventHandler("playerSpawned", function()
    Utils.RemoveVehicle(Vhc)
    print("spawned")
    Utils.SpawnVehicle("trash", 300)
    if TutorialActive then
        TutorialMission()
    elseif Mission2Active then
        SecondMission()
    end
end)

--Missions:
function TutorialMission()
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
    ScaleformMovieMethodAddParamPlayerNameString("FIRST ASSIGNMENT")
    ScaleformMovieMethodAddParamPlayerNameString("Take out the trash")
    EndScaleformMovieMethod()

    spawnDeidMan(877.344788, -2380.534180, 27.957920)

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function SecondMission()
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
    ScaleformMovieMethodAddParamPlayerNameString("GETTING STARTED")
    ScaleformMovieMethodAddParamPlayerNameString("Retrieve the latest body")
    EndScaleformMovieMethod()

    spawnDeidMan(-327.710754, -1743.347656, 1.44066)

    Mission2Active = true

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-- Spawning dead bodies

-- Tutorial Body: 877.344788, -2380.534180, 27.957920
-- Second Mission: -327.710754, -1743.347656, 1.44066

function spawnDeidMan(x, y, z)
    RequestModel(GetHashKey("a_m_m_beach_02"))
    while not HasModelLoaded(GetHashKey("a_m_m_beach_02")) do
        Wait(0)
    end
    unfortunate_soul = CreatePed(0, GetHashKey("a_m_m_beach_02"), x, y, z, 180.0, false, false)
    SetEntityHealth(unfortunate_soul, 0)
    AddBlipForEntity(unfortunate_soul)
    bodyFound = false
end

function findBodyLoc()
    ranX = math.random(-4000.0, 6000.0)
    ranY = math.random(-4000.0, 8000.0)
    x, foundPos = GetSafeCoordForPed(ranX, ranY, 0.0, true, 2)
    return foundPos.x, foundPos.y
end



RegisterKeyMapping("BagUp", "Bag up 'trash'", "keyboard", "b")

RegisterCommand("BagUp", function()
    playerCoord = GetEntityCoords(GetPlayerPed(-1))
    targetCoord = GetEntityCoords(unfortunate_soul)
    if GetDistanceBetweenCoords(playerCoord.x, playerCoord.y, playerCoord.z, targetCoord.x, targetCoord.y, targetCoord.z, true) < 5 then
        DeleteEntity(unfortunate_soul)
        RequestModel(GetHashKey("p_binbag_01_s"))
        -- Hash for a custom pickup
        binbag = CreatePickup(738282662, targetCoord.x, targetCoord.y, targetCoord.z, 1, 1, true,
            GetHashKey("p_binbag_01_s"))
        bodyFound = true
        dropOffBlip = AddBlipForCoord(143.5, -2450.0, 5.0)
    end
end, false)

CreateThread(function()
    while true do
        if IsEntityAtCoord(GetPlayerPed(-1), 143.5, -2450.0, 5.0, 5, 5, 5, true, false, 1) and bodyFound == true then
            bodyFound = false
            RemoveBlip(dropOffBlip)
            if TutorialActive then
                TutorialActive = false
                SecondMission()
            elseif Mission2Active then
                Mission2Active = false
            end
        end
        Wait(5)
    end
end)

-- Still need to test slowing down with bags