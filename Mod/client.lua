-- Spawning dead bodies

function spawnDeidMan(x, y, z)
	RequestModel(GetHashKey("a_m_m_beach_02"))
    unfortunate_soul = CreatePed(0, GetHashKey("a_m_m_beach_02"), x, y, z, 180.0, false, false)
	SetEntityHealth(unfortunate_soul, 0)
	AddBlipForEntity(unfortunate_soul)
    bodyFound = false
end

function findBodyLoc()
    repeat
        ranX = math.random(-4000.0,6000.0)
        ranY = math.random(-4000.0,8000.0)
    until GetSafeCoordForPed(ranX,ranY,0.0,true,2)
    return ranX,ranY
end

bodyPosX, bodyPosY = findBodyLoc()
spawnDeidMan(bodyPosX, bodyPosY, 0.0)

RegisterKeyMapping("BagUp","Bag up 'trash'","keyboard","b")

RegisterCommand("BagUp", function()
    playerCoord = GetEntityCoords(GetPlayerPed(-1))
	targetCoord = GetEntityCoords(unfortunate_soul)
    if GetDistanceBetweenCoords(playerCoord.x, playerCoord.y, playerCoord.z, targetCoord.x, targetCoord.y, targetCoord.z, true) < 5 then
        DeleteEntity(unfortunate_soul)
        RequestModel(GetHashKey("p_binbag_01_s"))
        -- Hash for a custom pickup
        binbag = CreatePickup(738282662, targetCoord.x, targetCoord.y, targetCoord.z,1,1,true,GetHashKey("p_binbag_01_s"))
        bodyFound = true
        dropOffBlip = AddBlipForCoord(143.5,-2450.0)
    end
end, false)

CreateThread(function()
    while true do
        if IsEntityAtCoord(GetPlayerPed(-1),143.5,-2450.0,5.0,5,5,5,true,false,1) and bodyFound == true then
            bodyFound = false
            print("Drop off successful")
            bodyPosX, bodyPosY = findBodyLoc()
            spawnDeidMan(bodyPosX, bodyPosY, 0.0)
            RemoveBlip(dropOffBlip)
        end
        Wait()
    end
end)