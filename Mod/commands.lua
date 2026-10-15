--Coords:
RegisterCommand("coords", function()
    local ped = PlayerPedId()
    local coordinates = GetEntityCoords(ped, false)
    print(coordinates)
end, false)

RegisterKeyMapping("BagUp", "Bag up 'trash'", "keyboard", "b")

RegisterCommand("BagUp", function()
    PlayerCoord = GetEntityCoords(GetPlayerPed(-1))
    TargetCoord = GetEntityCoords(UnfortunateSoul)
    if GetDistanceBetweenCoords(PlayerCoord.x, PlayerCoord.y, PlayerCoord.z, TargetCoord.x, TargetCoord.y, TargetCoord.z, true) < 5 then
        DeleteEntity(UnfortunateSoul)
        RequestModel(GetHashKey("p_Binbag_01_s"))
        -- Hash for a custom pickup
        Binbag = CreatePickup(738282662, TargetCoord.x, TargetCoord.y, TargetCoord.z, 1, 1, true,
            GetHashKey("p_Binbag_01_s"))
        BodyFound = true
        DropOffBlip = AddBlipForCoord(143.5, -2450.0, 5.0)
    end
end, false)

RegisterCommand("kill", function()
    SetEntityHealth(PlayerPedId(), 0)
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
    Mission4Active = false
    Mission5Active = false
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)

RegisterCommand("trigger_mission2", function()
    TutorialActive = false
    Mission2Active = true
    Mission3Active = false
    Mission4Active = false
    Mission5Active = false
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)

RegisterCommand("trigger_mission3", function()
    TutorialActive = false
    Mission2Active = false
    Mission3Active = true
    Mission4Active = false
    Mission5Active = false
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)

RegisterCommand("trigger_mission4", function()
    TutorialActive = false
    Mission2Active = false
    Mission3Active = false
    Mission4Active = true
    Mission5Active = false
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)

RegisterCommand("trigger_mission5", function()
    TutorialActive = false
    Mission2Active = false
    Mission3Active = false
    Mission4Active = false
    Mission5Active = true
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)
