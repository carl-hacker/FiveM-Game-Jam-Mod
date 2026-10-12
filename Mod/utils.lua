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
