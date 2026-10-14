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
    if DoesEntityExist(unfortunate_soul) then
        DeleteEntity(unfortunate_soul)
    end
    if DoesBlipExist(dropOffBlip) then
        RemoveBlip(dropOffBlip)
    end
    bodyFound = false
    if TutorialActive then
        TutorialMission()
    elseif Mission2Active then
        SecondMission()
    elseif Mission3Active then
        PondMission()
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
--    BeginTextCommandDisplayText("Congrats on the new job, theres been an unfortunate accident by the old warehouse, we need you to... take care of it. The trash is quite heavy, make sure you drive up close to it, dont't want to be lugging it all the way through the car park. Good luck, employee.")

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

function PondMission()
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
    ScaleformMovieMethodAddParamPlayerNameString("GOING FISHING")
    ScaleformMovieMethodAddParamPlayerNameString("Dispose of the evidence")
    EndScaleformMovieMethod()

    spawnDeidMan(1094.038940, -638.702026, 0.0)

    Mission3Active = true

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-- Spawning dead bodies

-- Tutorial Body: 877.344788, -2380.534180, 27.957920 Easy as intended
-- Second Mission: -327.710754, -1743.347656, 1.44066 Hard but not necessarily in a fun wy
-- Third Mission (Pond): 1094.038940, -638.702026, 0.0

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
        dropOffBlip = AddBlipForCoord(dropzone.x, dropzone.y, dropzone.z)
    end
end, false)

CreateThread(function()
    while true do
        if IsEntityAtCoord(GetPlayerPed(-1), dropzone.x, dropzone.y, dropzone.z, 5, 5, 5, true, false, 1) and bodyFound == true then
            bodyFound = false
            RemoveBlip(dropOffBlip)
            if TutorialActive then
                TutorialActive = false
                SecondMission()
                NetworkEarnFromPickup(500)
            elseif Mission2Active then
                Mission2Active = false
                PondMission()
                NetworkEarnFromPickup(750)
            elseif Mission3Active then
                Mission3Active = false
                NetworkEarnFromPickup(1000)
            end
        end
        if bodyFound then
            SetPedMoveRateOverride(GetPlayerPed(-1), 0.67)
            movementFucked = true
            -- Disabling sprinting and jumping
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
        elseif movementFucked then
            SetPedMoveRateOverride(GetPlayerPed(-1), 1.0)
            movementFucked = false
        end
        Wait(5)
    end
end)

-- Still need to test slowing down with bags