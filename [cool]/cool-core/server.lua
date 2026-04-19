local QBCore = exports['qb-core']:GetCoreObject()

-- ================================
-- 🧠 CORE INIT
-- ================================
print("===== COOL CORE STARTED =====")

-- ================================
-- 🆕 CORE TABLE
-- ================================
CoolCore = {} -- 🔧 ADDED (central system table)

-- ================================
-- 🆕 DEBUG SYSTEM
-- ================================
CoolCore.Debug = function(module, message) -- 🔧 ADDED
    print("[COOL-" .. module .. "] " .. message)
end

-- ================================
-- 🆕 PLAYER HELPER
-- ================================
CoolCore.GetPlayer = function(src) -- 🔧 ADDED
    return QBCore.Functions.GetPlayer(src)
end

-- ================================
-- 🆕 GET CITIZEN ID
-- ================================
CoolCore.GetCitizenId = function(src) -- 🔧 ADDED
    local Player = CoolCore.GetPlayer(src)
    if not Player then return nil end

    return Player.PlayerData.citizenid
end

-- ================================
-- 🆕 SAFE MONEY ADD
-- ================================
CoolCore.AddMoney = function(src, account, amount) -- 🔧 ADDED
    local Player = CoolCore.GetPlayer(src)
    if not Player then return end

    Player.Functions.AddMoney(account, amount)

    CoolCore.Debug("MONEY", "Gave $" .. amount .. " to player " .. src)
end

-- ================================
-- 🔥 UPDATED NOTIFY (NO MORE OX_LIB)
-- ================================
CoolCore.Notify = function(src, title, message, type)

    -- 🆕 SEND TO YOUR UI SYSTEM
    TriggerClientEvent('cool-ui:notify', src, title, message, type)

    -- 🧠 DEBUG
    CoolCore.Debug("NOTIFY", title .. " | " .. message)

end

-- ================================
-- 🆕 XP WRAPPER (IMPORTANT)
-- ================================
CoolCore.AddXP = function(src, skill, amount) -- 🔧 ADDED
    exports['cool-xp']:AddXP(src, skill, amount)

    CoolCore.Debug("XP", "Added " .. amount .. " XP to " .. skill .. " for player " .. src)
end

-- ================================
-- 🔹 UI TOGGLE COMMANDS (NEW SECTION)
-- ================================
-- Toggle the visibility of the small UI
RegisterCommand("showSmallUI", function(source)
    TriggerClientEvent('toggleSmallUI', source, { show = true })
    CoolCore.Debug("UI", "Showing Small UI for player " .. source)
end)

RegisterCommand("hideSmallUI", function(source)
    TriggerClientEvent('toggleSmallUI', source, { show = false })
    CoolCore.Debug("UI", "Hiding Small UI for player " .. source)
end)

-- Similarly, for medium and large UI:
RegisterCommand("showMediumUI", function(source)
    TriggerClientEvent('toggleMediumUI', source, { show = true })
    CoolCore.Debug("UI", "Showing Medium UI for player " .. source)
end)

RegisterCommand("hideMediumUI", function(source)
    TriggerClientEvent('toggleMediumUI', source, { show = false })
    CoolCore.Debug("UI", "Hiding Medium UI for player " .. source)
end)

RegisterCommand("showLargeUI", function(source)
    TriggerClientEvent('toggleLargeUI', source, { show = true })
    CoolCore.Debug("UI", "Showing Large UI for player " .. source)
end)

RegisterCommand("hideLargeUI", function(source)
    TriggerClientEvent('toggleLargeUI', source, { show = false })
    CoolCore.Debug("UI", "Hiding Large UI for player " .. source)
end)

-- ================================
-- 📤 EXPORTS (CORE API)
-- ================================
exports('GetPlayer', CoolCore.GetPlayer) -- 🔧 ADDED
exports('GetCitizenId', CoolCore.GetCitizenId) -- 🔧 ADDED
exports('AddMoney', CoolCore.AddMoney) -- 🔧 ADDED
exports('Notify', CoolCore.Notify) -- 🔧 ADDED
exports('AddXP', CoolCore.AddXP) -- 🔧 ADDED