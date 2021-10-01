Inventory = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

RegisterServerEvent("scf_bankrobbery:payout")
AddEventHandler("scf_bankrobbery:payout", function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter         
    Inventory.subItem(_source, "lockpick", 1)
    local r = math.random(1,10)
    if r < 3 then 
        Inventory.addItem(_source, "value_paper", math.random(1,3)) 
    else
    Inventory.addItem(_source, "goldbar", math.random(2,5)) 
    end

end)


RegisterServerEvent('scf_bankrobbery:lockpick')
AddEventHandler('scf_bankrobbery:lockpick', function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter 
    local count = Inventory.getItemCount(_source, "lockpick")

    if count >= 1 then
        TriggerClientEvent("scf_bankrobbery:StartRobbing", _source)	
    else
        TriggerClientEvent("vorp:Tip", _source, 'How do you think you rob a bank without tools?', 5000)
    end     
   
end)
 
RegisterServerEvent("scf_bankrobbery:policecheck")
AddEventHandler("scf_bankrobbery:policecheck", function(players)
    local _source = source
    local Sceriffi = 0
    for k,v in pairs(players) do
        local User = VorpCore.getUser(v)
        local Character = User.getUsedCharacter
        if Character.job == "police" then 
            Sceriffi = Sceriffi + 1
            
        end

        
    end

    if Sceriffi >= 1 then
        TriggerClientEvent("scf_bankrobbery:checkLockpick",_source)
    else
        TriggerClientEvent("vorp:Tip", _source, 'There arent enough Sheriffs', 5000)
    end

end)

RegisterNetEvent("scf_bankrobbery:policenotify")
AddEventHandler("scf_bankrobbery:policenotify", function(players, coords)
    for each, player in ipairs(players) do
        local Character = VorpCore.getUser(player).getUsedCharacter
        if Character ~= nil then

			if Character.job == 'police' then
				TriggerClientEvent("scf_bankrobbery:witness", player, coords)
			end
        end
    end
end)