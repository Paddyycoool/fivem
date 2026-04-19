local QBCore = exports['qb-core']:GetCoreObject()
local cooldowns = {}

-- ================================
-- 🧠 GET NPC FUNCTION
-- ================================
local function getNPC(id)
    for _, npc in pairs(Config.NPCs) do
        if npc.id == id then
            return npc
        end
    end
    return nil
end

-- ================================
-- 🎯 MAIN INTERACTION
-- ================================
RegisterNetEvent('cool-npcjob:interact', function(npcId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local time = os.time()

    -- ================================
    -- 🔧 COOLDOWN SYSTEM
    -- ================================
    cooldowns[src] = cooldowns[src] or {}

    if type(cooldowns[src]) ~= "table" then
        cooldowns[src] = {}
    end

    if cooldowns[src][npcId] and time < cooldowns[src][npcId] then
        exports['cool-core']:Notify(src, "Wait", "Come back later", "error")
        return
    end

    -- ================================
    -- 🧠 GET NPC DATA
    -- ================================
    local npc = getNPC(npcId)
    if not npc then
        print("[ERROR] NPC NOT FOUND: " .. tostring(npcId))
        return
    end

    -- ================================
    -- 🧠 GET NPC TYPE
    -- ================================
    local npcType = Config.Types[npc.type]
    if not npcType then
        print("[ERROR] NPC TYPE NOT FOUND: " .. tostring(npc.type))
        return
    end

    -- ================================
    -- 🆕 GET PLAYER SKILL LEVEL (NEW)
    -- ================================
    local skillData = exports['cool-xp']:GetXP(src)
    local level = 1

    if skillData and skillData[npc.type] and skillData[npc.type].level then
        level = skillData[npc.type].level
    end
    
    print("[LEVEL CHECK] Player:", src, "| Skill:", npc.type, "| Level:", level)
    
    -- ================================
    -- 🔒 LEVEL LOCK CHECK (NEW)
    -- ================================
    local requiredLevel = npc.requiredLevel or 1

    if level < requiredLevel then
        print("[LOCKED] Player:", src, "| Skill:", npc.type, "| Required:", requiredLevel, "| Current:", level)

        exports['cool-core']:Notify(
            src,
            "Locked",
            "You need level " .. requiredLevel .. " to use this",
            "error"
    )

    return
end

    -- ================================
    -- 🆕 CALCULATE REWARD (NEW)
    -- ================================
    local reward = npcType.baseReward or 0 -- 🔧 CHANGED (was npcType.reward)
    local multiplier = 1.0

    for lvl, data in pairs(npcType.levels or {}) do -- 🔧 CHANGED (safe loop)
        if level >= lvl then
            multiplier = data.multiplier or multiplier 
        end
    end

    reward = math.floor(reward * multiplier)

    print("[REWARD DEBUG] Player:", src, "| Skill:", npc.type, "| Level:", level, "| Reward:", reward) -- 🆕 DEBUG

    -- ================================
    -- 🔓 UNLOCK SYSTEM (NEW)
    -- ================================
    local unlocked = nil

    for lvl, data in pairs(npcType.levels or {}) do
        if level == lvl and data.unlock then
            unlocked = data.unlock
        end
    end

    if unlocked then
        print("[UNLOCK] Player:", src, "| Skill:", npc.type, "| Unlocked:", unlocked)

        exports['cool-core']:Notify(
            src,
            "Unlocked!",
            "You unlocked: " .. unlocked,
            "success"
        )
    end
    
    -- ================================
    -- 🔧 SET COOLDOWN
    -- ================================
    cooldowns[src][npcId] = time + Config.Cooldown

    -- ================================
    -- 💰 GIVE REWARD (UPDATED TO CORE)
    -- ================================
    exports['cool-core']:AddMoney(src, 'cash', reward) -- 🔧 CHANGED

    -- ================================
    -- 🧠 ADD XP (UPDATED TO CORE)
    -- ================================
    exports['cool-core']:AddXP(src, npc.type, 25) -- 🔧 CHANGED

    -- ================================
    -- 📢 NOTIFY (UPDATED)
    -- ================================
    exports['cool-core']:Notify(
        src,
        "Job",
        "You got paid $" .. reward .. " (Level " .. level .. ")", -- 🔧 CHANGED
        "success"
    )

    print("[SUCCESS] Player " .. src .. " used NPC: " .. npcId .. " | Type: " .. npc.type)
end)

-- ================================
-- 🧹 CLEANUP
-- ================================
AddEventHandler('playerDropped', function()
    local src = source
    cooldowns[src] = nil
end)