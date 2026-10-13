--Coords:
RegisterCommand("coords", function()
    local ped = PlayerPedId()
    local coordinates = GetEntityCoords(ped, false)
    print(coordinates)
end, false)

RegisterCommand("selfsplode", function()
    local ped = PlayerPedId()
    local coordinates = GetEntityCoords(ped, false)
    AddExplosion(coordinates.x,coordinates.y,coordinates.z,81,10,true,false,10,false)
end, false)