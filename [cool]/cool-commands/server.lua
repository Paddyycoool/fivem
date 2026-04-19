RegisterCommand('giveitem', function(source, args)

    local target = tonumber(args[1])
    local item = args[2]
    local amount = tonumber(args[3]) or 1

    if not target or not item then
        print("Usage: /giveitem [id] [item] [amount]")
        return
    end

    if GetPlayerPed(target) == 0 then
        print("Player not found")
        return
    end

    local success = exports.ox_inventory:AddItem(target, item, amount)

    if success then
        print("SUCCESS: gave " .. item)
    else
        print("FAILED to give item")
    end

end, true)