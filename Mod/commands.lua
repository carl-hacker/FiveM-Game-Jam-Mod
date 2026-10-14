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

RegisterCommand("trigger_tutorial", function()
    TutorialActive = true
    Mission2Active = false
    Mission3Active = false
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)

RegisterCommand("trigger_mission2", function()
    TutorialActive = false
    Mission2Active = true
    Mission3Active = false
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)

RegisterCommand("trigger_mission3", function()
    TutorialActive = false
    Mission2Active = false
    Mission3Active = true
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)