StartRobbing = {}
local bankrobbing = false
local cooldown = 0
RegisterNetEvent("scf_bankrobbery:witness")
AddEventHandler("scf_bankrobbery:witness", function(coords)
--	print('store name '..tostring(alert))
	TriggerEvent("vorp:TipBottom", 'Telegram of Robbery in Progress at Valentine bank', 15000)
	local blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 50.0)
	Wait(90000)--Time till notify blips dispears, 1 min
	RemoveBlip(blip)
end)
RegisterNetEvent('scf_bankrobbery:StartRobbing')
AddEventHandler('scf_bankrobbery:StartRobbing', function()	
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
		if bankrobbing == false then
			
            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
			bankrobbing = true
		   --TriggerEvent("redemrp_notification:start", "You have started to rob this bank!", 5)
		   exports['progressBars']:startUI(35000, "You're robbing the bank")
		   TriggerServerEvent("scf_bankrobbery:policenotify", GetPlayers(), coords)
            Citizen.Wait(35000)
            ClearPedTasksImmediately(PlayerPedId())
			ClearPedSecondaryTask(PlayerPedId())
			bankrobbing = false
			TriggerServerEvent("scf_bankrobbery:payout")
			RunCooldown()

		end
end)
RegisterNetEvent('scf_bankrobbery:checkLockpick')
AddEventHandler('scf_bankrobbery:checkLockpick',function()
	if cooldown == 0 then 
	TriggerServerEvent('scf_bankrobbery:lockpick')
	else
		TriggerEvent("vorp:TipBottom", "Nothing to steal", 6000)
	end
end)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

-- bank 1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local betweencoords = GetDistanceBetweenCoords(coords, -308.85, 765.11, 118.7, true) --val
		if betweencoords < 2.0 then
			DrawTxt("Press enter to start", 0.50, 0.90, 0.7, 0.7, true, 255, 255, 255, 255, true)
			if IsControlJustReleased(0, 0xC7B5340A) then		
				TriggerServerEvent("scf_bankrobbery:policecheck",GetPlayers())	
			end
		end
	end
end)

-- bank 2
--[[Citizen.CreateThread(function()
	print("hi")
while true do
	Citizen.Wait(0)
local playerPed = PlayerPedId()
local coords = GetEntityCoords(playerPed)
		local betweencoords = GetDistanceBetweenCoords(coords, -820.85, -1274.33, 43.65, true) --blackwater
		if betweencoords < 2.0 then
			DrawTxt("Pss nt to stat", 0.50, 0.90, 0.7, 0.7, true, 255, 255, 255, 255, true)
			if IsControlJustReleased(0, 0xC7B5340A) then
			TriggerServerEvent("lockpick", function() --check/del lockpick
				end) 
				
			end
		end
	end
end)
--]]
-- bank 3

--[[
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local betweencoords = GetDistanceBetweenCoords(coords, -813.12, -1277.52, 43.64, true)
		if betweencoords < 2.0 then
			DrawTxt(Config.Robbank3, 0.50, 0.90, 0.7, 0.7, true, 255, 255, 255, 255, true)
			if IsControlJustReleased(0, 0xC7B5340A) then
			TriggerServerEvent("lockpick", function()   --check/del lockpick
				end) 
				
			end
		end
	end
end)

--]]

-- Get players
function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end

-- Cooldown
function RunCooldown()
    cooldown = 3600000        
    while cooldown > 0 do
        Wait(0)
        cooldown = cooldown - 1
    end
end