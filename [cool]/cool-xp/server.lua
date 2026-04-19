local QBCore = exports['qb-core']:GetCoreObject()
local MySQL = exports['oxmysql'] -- 🆕 REQUIRED FIX

-- ================================
-- 🆕 MULTI SKILL STORAGE
-- ================================
local PlayerXP = {}

-- ================================
-- 🧠 XP CALCULATION
-- ================================
local function getRequiredXP(level)
    return math.floor(Config.XP.base * (Config.XP.multiplier ^ (level - 1)))
end

-- ================================
-- 🧠 GET PLAYER DATA
-- ================================
local function getPlayerData(src)
    PlayerXP[src] = PlayerXP[src] or {}
    return PlayerXP[src]
end

-- ================================
-- ➕ ADD XP (UPDATED)
-- ================================
function AddXP(src, skill, amount)
    local data = getPlayerData(src)

    data[skill] = data[skill] or { xp = 0, level = 1 }

    -- ================================
    -- ➕ ADD XP
    -- ================================
    data[skill].xp = data[skill].xp + amount

    local requiredXP = getRequiredXP(data[skill].level)

    -- ================================
    -- 🔁 LEVEL LOOP
    -- ================================
    while data[skill].xp >= requiredXP do
        data[skill].xp = data[skill].xp - requiredXP
        data[skill].level = data[skill].level + 1

        requiredXP = getRequiredXP(data[skill].level)
    end

    -- ================================
    -- 🧠 CALCULATE PROGRESS
    -- ================================
    local progress = math.floor((data[skill].xp / requiredXP) * 100)

    -- ================================
    -- 🆕 UI EVENTS
    -- ================================
    TriggerClientEvent('cool-ui:showXP', src, skill, amount, progress)
    TriggerClientEvent('cool-ui:updateXP', src, skill, progress)

    -- ================================
    -- 💾 SAVE (🔥 MOVED INSIDE FUNCTION)
    -- ================================
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local citizenid = Player.PlayerData.citizenid

        exports.oxmysql:insert('INSERT IGNORE INTO player_skills (citizenid, skill, xp, level) VALUES (?, ?, ?, ?)', {
            citizenid, skill, data[skill].xp, data[skill].level
        })

        exports.oxmysql:update('UPDATE player_skills SET xp = ?, level = ? WHERE citizenid = ? AND skill = ?', {
            data[skill].xp, data[skill].level, citizenid, skill
        })

        print("[XP] SAVED -> " .. citizenid .. " | " .. skill)
    end

    -- ================================
    -- 🧪 DEBUG
    -- ================================
    print("[XP DEBUG] Progress:", progress)
    print("[XP] " .. skill .. " | Player " .. src .. " | XP: " .. data[skill].xp .. " | Level: " .. data[skill].level)
end

-- ================================
-- 📤 EXPORTS
-- ================================
exports('AddXP', AddXP)

exports('GetXP', function(src)
    return getPlayerData(src)
end)

-- ================================
-- 🆕 LOAD PLAYER SKILLS (FIXED)
-- ================================
RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local citizenid = Player.PlayerData.citizenid

    PlayerXP[src] = {}

    exports.oxmysql:query('SELECT * FROM player_skills WHERE citizenid = ?', { citizenid }, function(results)

        if results and #results > 0 then
            for _, row in pairs(results) do
                PlayerXP[src][row.skill] = {
                    xp = row.xp,
                    level = row.level
                }
            end

            print("[XP] LOADED ALL SKILLS -> " .. citizenid)
        else
            print("[XP] NO SKILLS FOUND -> " .. citizenid)
        end

    end)
end)

-- ================================
-- 🆕 XP CALLBACK (ADD HERE)
-- ================================
lib.callback.register('cool-xp:getXP', function(source)
    return PlayerXP[source] or {}
end)

-- ================================
-- 🧹 CLEANUP
-- ================================
AddEventHandler('playerDropped', function()
    local src = source
    PlayerXP[src] = nil
end)