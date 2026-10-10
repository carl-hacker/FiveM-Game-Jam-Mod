-- Matthew was here

-- Initial Spawn-in

RequestModel(GetHashKey("trash"))
bin_lorry = CreateVehicle(GetHashKey("trash"), GetEntityCoords(source).x, GetEntityCoords(source).y, GetEntityCoords(source).z, 0.0, false, false)

-- Spawning dead bodies

function spawnDeidMan(x, y, z)
	RequestModel(GetHashKey("a_m_m_beach_02"))
    local unfortunate_soul = CreatePed(0, GetHashKey("a_m_m_beach_02"), x, y, z, 180.0, false, false)
	SetEntityHealth(unfortunate_soul, 0)
	AddBlipForEntity(unfortunate_soul)
end

spawnDeidMan(100.0, 100.0, 0.0)

RegisterKeyMapping("BagUp","Bag up 'trash'","keyboard","b")

RegisterCommand("BagUp", function(body)
	target =
end, false)

-- RegisterCommand("SpawnDeadBody", function(x,y,z) spawnDeidMan(x, y, z) end, False)