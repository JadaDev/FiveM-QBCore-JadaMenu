local menu = nil
QBCore = nil

local lastSpawnTime = 0 -- Keep it 0
local cooldownRegular = 2 -- Normal Cars Cooldown before spawning another car
local cooldownAddon = 10 -- Addon Cars Cooldown before spawning another car

Citizen.CreateThread(function() 
  while true do
    Citizen.Wait(1)
    if QBCore == nil then
      TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end) 
      Citizen.Wait(100)
    end
  end
end)
local vehicles = {
    ["Fancy"] = {
        {model = "formula", name = "formula"},
        {model = "formula2", name = "formula2"},
        {model = "openwheel1", name = "openwheel1"},
		{model = "openwheel2", name = "openwheel2"},
		{model = "alphaz1", name = "alphaz1"},
		{model = "frogger", name = "frogger"},
		{model = "cutter", name = "cutter"},
		{model = "guardian", name = "guardian"},
		{model = "chernobog", name = "chernobog"},
		{model = "thruster", name = "thruster"},
    },
    ["Class S"] = {
        {model = "GP1", name = "GP1"},
        {model = "OSIRIS", name = "OSIRIS"},
		{model = "T20", name = "T20"},
		{model = "Tyrus", name = "Tyrus"},
		{model = "LM87", name = "LM87"},
		{model = "SC1", name = "SC1"},
		{model = "Cheetah", name = "Cheetah"},
		{model = "Zeno", name = "Zeno"},
		{model = "Ignus", name = "Ignus"},
		{model = "Infernus", name = "Infernus"},
        {model = "zentorno", name = "zentorno"},
    },
    ["Class B"] = {
        {model = "Komoda", name = "Komoda"},
        {model = "Kuruma", name = "Kuruma"},
        {model = "elegy", name = "elegy"},
		{model = "sultan", name = "sultan"},
		{model = "sultanrs", name = "sultanrs"},
		{model = "Growler", name = "Growler"},
		{model = "Comet6", name = "Comet S2"},
		{model = "Jugular", name = "Jugular"},  
		{model = "Kuruma2", name = "Kuruma2"},
		{model = "vectre", name = "vectre"},
		{model = "sultan3", name = "sultan3"},
		{model = "calico", name = "calico"},
		{model = "sentinel3", name = "sentinel3"},
		{model = "dominator7", name = "dominator7"},
		{model = "elegy2", name = "elegy2"},
		{model = "gb200", name = "gb200"},
		{model = "sugoi", name = "sugoi"},
    },
    ["Addon"] = {
		-- Addon Cars goes here ( Change MODEL with the Vehicle Model Name and Name it whatever you want - copy this example : ) : {model = "MODEL", name = "JUST A NAME"}, 
				
    },
    ["Motorcycle"] = {
        {model = "bati2", name = "bati2"},
		{model = "diablous2", name = "diablous2"},
		{model = "deathbike2", name = "deathbike2"},
		{model = "bf400", name = "bf400"},
		{model = "manchez3", name = "manchez3"},
		{model = "sanchez2", name = "sanchez2"},
		{model = "vortex", name = "vortex"},
		{model = "sanctus", name = "sanctus"},
		{model = "shotaro", name = "shotaro"},
		{model = "carbonrs", name = "carbonrs"},
		{model = "double", name = "double"},
		{model = "enduro", name = "enduro"},
    },
}

local selectedCategory = nil
local selectedVehicle = nil
local spawnedVehicle = nil

function InitMenu()
    menu = MenuV:CreateMenu("Jada Menu", "Select a category", "left", 0, 255, 255, "size-125", "default", "menuv", generate_random_letters())

    local carsSubmenu = MenuV:CreateMenu("Cars", "Select a category", "left", 0, 255, 255, "size-125", "default", "menuv", generate_random_letters())
    for category, _ in pairs(vehicles) do
        local categoryButton = carsSubmenu:AddButton({icon = "🚗", label = category, value = category, description = "Spawn a vehicle from this category"})
        categoryButton:On("select", function(item)
            selectedCategory = item.Value
            OpenSubmenu(selectedCategory)
        end)
    end
    menu:AddButton({icon = "🚗", label = "Cars List", value = "Cars", description = "Select a car category"}):On("select", function()
        carsSubmenu:Open()
    end)
	
	menu:AddButton({icon = "✔", label = "Spawn Vehicle", description = "Write the Code"}):On("select", function()
		SpawnCarCode()
    end)

    -- Add additional buttons for other options
    menu:AddButton({icon = "🔧", label = "Fix Vehicle", description = "Fix your vehicle"}):On("select", function()
        FixCar()
    end)
	
	menu:AddButton({icon = "⚡️", label = "Max Car Mods", description = "Maximize Your Vehicle Options"}):On("select", function()
    MaxMods()
    end)
	
	menu:AddButton({icon = "🔥", label = "Depot", description = "Despawn the vehicle you are in"}):On("select", function()
    DespawnVehicle()
    end)

    menu:AddButton({icon = "👻", label = "Revive", description = "Revive yourself"}):On("select", function()
        RevivePlayer()
    end)
	
	TeleportMenu = MenuV:CreateMenu("Teleports", "More Info", "left", 255, 255, 255, "size-125", "default", "menuv", generate_random_letters())

    TeleportMenu:AddButton({icon = "🚓", label = "Race [1]", description = "Teleport to the race"}):On("select", function()
	TeleportToRace1()
    end)
	
    TeleportMenu:AddButton({icon = "🏩", label = "Garage Central", description = "Teleport to the GC"}):On("select", function()
	TeleportToGC()
    end)
		
    TeleportMenu:AddButton({icon = "🗺", label = "North", description = "Teleport to the North"}):On("select", function()
	TeleportToNorth()
    end)

    TeleportMenu:AddButton({icon = "✈", label = "Airport", description = "Teleport to the City Airport"}):On("select", function()
	TeleportToAirport()
    end)

    TeleportMenu:AddButton({icon = "🚀", label = "Mechanic [1]", description = "Teleport to the Mechanic"}):On("select", function()
	TeleportToMechanic1()
    end)
	
    TeleportMenu:AddButton({icon = "🚀", label = "Mechanic [2]", description = "Teleport to the Mechanic"}):On("select", function()
	TeleportToMechanic2()
    end)
	
    menu:AddButton({icon = "🎯", label = "Teleports", description = "Locations"}):On("select", function()
        TeleportMenu:Open()
    end)
	
	menu:AddButton({icon = "👕", label = "Give Clothing Menu", description = "Gives you the Clothing Menu"}):On("select", function()
	GiveClothingMenu()
    end)
	
    anotherMenu = MenuV:CreateMenu("Credits", "List of Credits", "left", 255, 255, 255, "size-125", "default", "menuv", generate_random_letters())

    anotherMenu:AddButton({icon = "👨‍🍳", label = "This was made by JadaDev", description = "Made JadaMenu with ❤"}):On("select", function()
    end)

    menu:AddButton({icon = "❤", label = "Credits", description = "List of Credits"}):On("select", function()
        anotherMenu:Open()
    end)
	

end


function OpenSubmenu(category)
    if selectedCategory then
        local submenu = MenuV:CreateMenu("JMenu - " .. category, "Select a vehicle", "left", 0, 255, 255, "size-125", "default", "menuv", generate_random_letters())
        for i = 1, #vehicles[category] do
            local vehicleModel = vehicles[category][i].model
            local vehicleName = vehicles[category][i].name
            local vehicleButton = submenu:AddButton({icon = "🚗", label = vehicleName, value = vehicleModel, description = "Spawn this vehicle"})
            vehicleButton:On("select", function(item)
                selectedVehicle = item.Value
                SpawnVehicle()
            end)
        end
        submenu:Open()
    end
end

function notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(true, false)
end

function SpawnVehicle()
    if selectedVehicle then
        local currentTime = GetGameTimer()
        local cooldown = cooldownRegular

        if selectedCategory == "Addon" then
            cooldown = cooldownAddon
        end

        if currentTime - lastSpawnTime >= cooldown * 1000 then
            lastSpawnTime = currentTime
			 local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
            
            RequestModel(selectedVehicle)
            while not HasModelLoaded(selectedVehicle) do
                Wait(0)
            end
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local playerHeading = GetEntityHeading(playerPed)
            local vehicle = CreateVehicle(selectedVehicle, playerCoords, playerHeading, true, false)
			
			
			SetEntityHeading(spawnedVehicle, GetEntityHeading(playerPed))
            SetVehicleOnGroundProperly(spawnedVehicle)		
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            SetVehicleNumberPlateText(vehicle, "JMenu")
            SetEntityAsMissionEntity(vehicle, true, true)
            spawnedVehicle = vehicle
        else
            notify("Please wait before spawning another vehicle.")
        end
    end
end

function SpawnCarCode()
    local carName = KeyboardInput("Enter Vehicle Name", "", 32)

    if carName then
        local model = GetHashKey(carName)
        if IsModelValid(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            local spawnCoords = GetEntityCoords(PlayerPedId())
            local playerPed = PlayerPedId()
            local existingVehicle = GetVehiclePedIsIn(playerPed, false)

            if DoesEntityExist(existingVehicle) then
                DeleteVehicle(existingVehicle) 
                Wait(100) 
            end

            local spawnedVehicle = CreateVehicle(model, spawnCoords, 0.0, true, false)
            SetEntityHeading(spawnedVehicle, GetEntityHeading(playerPed))
            SetVehicleOnGroundProperly(spawnedVehicle)

            TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)

            local vehicleNameHash = GetDisplayNameFromVehicleModel(model)
            local vehicleKey = GetLabelText(vehicleNameHash)

            notify("Spawned " .. carName .. " (Key: " .. vehicleKey .. ")")
        else
            notify("Invalid vehicle name: " .. carName)
        end
    else
        notify("Invalid input or cancelled.")
    end
end



function RevivePlayer()
    TriggerEvent("hospital:client:Revive")
    StopScreenEffect('DeathFailOut')
	        SetEntityMaxHealth(ped, 2000)
        SetEntityHealth(ped, 2000)
    notify("You have been revived.")
end


function MaxMods()
	local performanceModIndices = {11, 12, 13, 15, 16}
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	customWheels = customWheels or false
    local max
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        SetVehicleModKit(vehicle, 0)
        for _, modType in ipairs(performanceModIndices) do
            max = GetNumVehicleMods(vehicle, tonumber(modType)) - 1
            SetVehicleMod(vehicle, modType, max, customWheels)
        end
        ToggleVehicleMod(vehicle, 18, true) -- Turbo
        SetVehicleFixed(vehicle)
    end
    notify("Your Car Has Maximized Mods!.")
end

function FixCar()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, false)
        notify("Your vehicle has been fixed.")
    else
        notify("You are not in a vehicle.")
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength, true)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

RegisterNetEvent('GiveClothingMenu')

AddEventHandler('GiveClothingMenu', function()
    TriggerEvent('qb-clothing:client:openMenu')
end)

function GiveClothingMenu()
    TriggerEvent('GiveClothingMenu')
end



function TeleportToRace1()
    
                local playerPed = PlayerPedId()
                local targetCoords = GetEntityCoords(targetPlayerPed)
                SetEntityCoords(playerPed, -308.67, -2658.36, 5.53 + 1.0, false, false, false, false) 
                notify("You Have been Teleported")

end

function TeleportToGC()
    
                local playerPed = PlayerPedId()
                local targetCoords = GetEntityCoords(targetPlayerPed)
                SetEntityCoords(playerPed, 216.49, -820.03, 30.45 + 1.0, false, false, false, false) 
                notify("You Have been Teleported")

end

function TeleportToNorth()
    
                local playerPed = PlayerPedId()
                local targetCoords = GetEntityCoords(targetPlayerPed)
                SetEntityCoords(playerPed, -405.15, 5987.69, 31.87 + 1.0, false, false, false, false) 
                notify("You Have been Teleported")

end

function TeleportToAirport()
    
                local playerPed = PlayerPedId()
                local targetCoords = GetEntityCoords(targetPlayerPed)
                SetEntityCoords(playerPed, -1262.1744, -3359.0383, 13.9450 + 1.0, false, false, false, false) 
                notify("You Have been Teleported")

end

function TeleportToMechanic1()

                local playerPed = PlayerPedId()
                local targetCoords = GetEntityCoords(targetPlayerPed)
                SetEntityCoords(playerPed, -212.55, -1320.56, 31.0 + 1.0, false, false, false, false) 
                notify("You Have been Teleported")
end


function TeleportToMechanic2()
    
                local playerPed = PlayerPedId()
                local targetCoords = GetEntityCoords(targetPlayerPed)
                SetEntityCoords(playerPed, -222.47, -1329.73, 31.0 + 1.0, false, false, false, false) 
                notify("You Have been Teleported")

end

function DespawnVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        notify("Vehicle despawned.")
    else
        notify("You are not in a vehicle.")
    end
end

RegisterKeyMapping('JMenu', 'Open Jada Menu', 'keyboard', 'F2')

RegisterCommand('JMenu', function()
    InitMenu()
    Wait(100)
    menu:Open()
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 121) then -- F2
            InitMenu()
            Wait(100)
            menu:Open()
        end
    end
end)

function generate_random_letters()
    local letters = "abcdefghijklmnopqrstuvwxyz"
    local result = ""
    for i = 1, 10 do
        local random_index = math.random(1, #letters)
        result = result .. string.sub(letters, random_index, random_index)
    end
    return result
end
