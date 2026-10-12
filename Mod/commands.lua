--Coords:
RegisterCommand("coords", function()
    local ped = PlayerPedId()
    local coordinates = GetEntityCoords(ped, false)
    print(coordinates)
end, false)

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
