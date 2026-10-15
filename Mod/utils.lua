_G.Utils = {}

--Putting Player into Vehicle function
function Utils.SpawnVehicle(name, h)
    local ped = PlayerPedId()
    local model = GetHashKey(name)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    local coords = GetEntityCoords(ped)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, h, true, false)
    print(vehicle)
    SetVehicleOnGroundProperly(vehicle)
    SetPedIntoVehicle(ped, vehicle, -1)
    Vhc = vehicle
end

function Utils.RemoveVehicle(entity)
    SetEntityAsMissionEntity(Vhc, false, false)
    DeleteVehicle(entity)
end

-- Spawning dead bodies
function Utils.SpawnDeidMan(x, y, z)
    RequestModel(GetHashKey("a_m_m_beach_02"))
    UnfortunateSoul = CreatePed(0, GetHashKey("a_m_m_beach_02"), x, y, z, 180.0, false, false)
    SetEntityHealth(UnfortunateSoul, 0)
    AddBlipForEntity(UnfortunateSoul)
    BodyFound = false
    print("Spawned man")
end

function Utils.FindBodyLoc()
    RanX = math.random(-4000.0, 6000.0)
    RanY = math.random(-4000.0, 8000.0)
    X, FoundPos = GetSafeCoordForPed(RanX, RanY, 0.0, true, 2)
    return FoundPos.x, FoundPos.y
end

--Missions:
function Utils.Mission()
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    print("mission?")

    BeginScaleformMovieMethod(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
    ScaleformMovieMethodAddParamPlayerNameString(MissionList[MissionIndex][1])
    ScaleformMovieMethodAddParamPlayerNameString(MissionList[MissionIndex][2])
    EndScaleformMovieMethod()

    local timeout = GetGameTimer() + 5000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
    Utils.SpawnDeidMan(MissionList[MissionIndex][3], MissionList[MissionIndex][4], MissionList[MissionIndex][5])
end

function Utils.GenericMission(topmsg, bottommsg, instructions, x, y, z)
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
    ScaleformMovieMethodAddParamPlayerNameString(topmsg)
    ScaleformMovieMethodAddParamPlayerNameString(bottommsg)
    EndScaleformMovieMethod()

    spawnDeidMan(x, y, z)
end