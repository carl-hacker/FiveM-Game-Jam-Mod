exports.spawnmanager:setAutoSpawn(true)

local spawnpoint = vector3(143.5, -2450, 5)
dropzone = vector3(172, -2388, 5)
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

TutorialActive = true

--Spawn Player in Vehicle:
AddEventHandler("playerSpawned", function()
    Utils.RemoveVehicle(Vhc)
    print("spawned")
    Utils.SpawnVehicle("trash", 300)
    if DoesEntityExist(Unfortunate_Soul) then
        DeleteEntity(Unfortunate_Soul)
    end
    if DoesEntityExist(Angry_farmer) then
        DeleteEntity(Angry_farmer)
    end
    if DoesBlipExist(DropOffBlip) then
        RemoveBlip(DropOffBlip)
    end
    BodyFound = false
    if TutorialActive then
        TutorialMission()
    elseif Mission2Active then
        SecondMission()
    elseif Mission3Active then
        PondMission()
    elseif Mission4Active then
        FarmMission()
    elseif Mission5Active then
        IslandMission()
    end
end)

--Missions:
function TutorialMission()
    Utils.GenericMission("FIRST ASSIGNMENT","Take out the trash","Congrats on the new job, theres been an unfortunate accident by the old warehouse, we need you to... take care of it. The trash is quite heavy, make sure you drive up close to it, dont't want to be lugging it all the way through the car park. Good luck, employee.",877.344788, -2380.534180, 27.957920)

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function SecondMission()
    Utils.GenericMission("GETTING STARTED","Retrieve the latest body","",-327.710754, -1743.347656, 1.44066)

    Mission2Active = true

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function PondMission()
    Utils.GenericMission("GOING FISHING","Dispose of the evidence","",1076.769897, -664.004272, 55.736099)

    Mission3Active = true

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function FarmMission()
    Utils.GenericMission("BE READY TO FIGHT","Dispose of the evidence","",1461.521484, 1043.320557, 114.334076)
    
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL"),50,false,true)
    
    -- Guard

    RequestModel(GetHashKey("a_m_m_farmer_01"))
    while not HasModelLoaded(GetHashKey("a_m_m_farmer_01")) do
        Wait(0)
    end
    Angry_farmer = CreatePed(0, GetHashKey("a_m_m_farmer_01"), 1462.231567, 1046.813354, 114.334061, 180.0, false, false)
    GiveWeaponToPed(Angry_farmer, GetHashKey("WEAPON_VINTAGEPISTOL"),100,false,true)
    TaskCombatPed(Angry_farmer, GetPlayerPed(-1), 0, 16)
    AddBlipForEntity(Angry_farmer)

    Mission4Active = true

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function IslandMission()
    Utils.GenericMission("SMOOTH SAILING","Rescue the stranded body","",1576.933716, -2808.588135, 2.952167)

    RequestModel(GetHashKey("dinghy"))
    while not HasModelLoaded(GetHashKey("dinghy")) do
        Wait(0)
    end
    CreateVehicle(GetHashKey("dinghy"),76.839218, -2420.331055, -0.573767,0,false,false)

    Mission5Active = true

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-- Tutorial Body: 877.344788, -2380.534180, 27.957920 Easy as intended
-- Second Mission: -327.710754, -1743.347656, 1.44066 Hard but not necessarily in a fun wy
-- Third Mission (Pond): 1076.769897, -664.004272, 55.736099
-- Fourth Mission (Farm): 1461.521484, 1043.320557, 114.334076 Difficult, possibly too much so
-- Fifth Mission (Island): 1576.933716, -2808.588135, 2.952167

CreateThread(function()
    while true do
        if IsEntityAtCoord(GetPlayerPed(-1), dropzone.x, dropzone.y, dropzone.z, 5, 5, 5, true, false, 1) and BodyFound == true then
            BodyFound = false
            RemoveBlip(DropOffBlip)
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
                FarmMission()
                NetworkEarnFromPickup(1000)
            elseif Mission4Active then
                Mission4Active = false
                IslandMission()
                NetworkEarnFromPickup(1500)
            elseif Mission5Active then
                Mission5Active = false
                NetworkEarnFromPickup(2000)
            end
        end
        if BodyFound then
            SetPedMoveRateOverride(GetPlayerPed(-1), 0.67)
            MovementFucked = true
            -- Disabling sprinting and jumping
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
        elseif MovementFucked then
            SetPedMoveRateOverride(GetPlayerPed(-1), 1.0)
            MovementFucked = false
        end
        Wait(5)
    end
end)