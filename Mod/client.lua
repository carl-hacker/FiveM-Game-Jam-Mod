-- Spawning dead bodies

function spawnDeidMan(x, y, z)
	RequestModel(GetHashKey("a_m_m_beach_02"))
    unfortunate_soul = CreatePed(0, GetHashKey("a_m_m_beach_02"), x, y, z, 180.0, false, false)
	SetEntityHealth(unfortunate_soul, 0)
	AddBlipForEntity(unfortunate_soul)
end

spawnDeidMan(100.0, 100.0, 0.0)

RegisterKeyMapping("BagUp","Bag up 'trash'","keyboard","b")

RegisterCommand("BagUp", function()
    playerCoord = GetEntityCoords(GetPlayerPed(-1))
	targetCoord = GetEntityCoords(unfortunate_soul)
    if GetDistanceBetweenCoords(playerCoord.x, playerCoord.y, playerCoord.z, targetCoord.x, targetCoord.y, targetCoord.z, true) < 5 then
        print("Body found")
    else
        print("Body not found")
    end
end, false)