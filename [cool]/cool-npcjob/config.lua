Config = {}

Config.Cooldown = 60

-- ================================
-- 🧠 NPC DEFINITIONS
-- ================================

Config.NPCs = {
    {
        id = "npc_1",
        coords = vec4(-267.0, -956.0, 31.2, 200.0),
        model = 'a_m_m_business_01',
        type = "worker",
        requiredLevel = 1 -- 🆕 ADDED
    },
    {
        id = "npc_2",
        coords = vec4(215.0, -810.0, 30.7, 160.0),
        model = 'a_m_m_skater_01',
        type = "scavenger",
        requiredLevel = 3 -- 🆕 ADDED (LOCKED)
    }
}

-- ================================
-- 🧠 TYPE CONFIG WITH SCALING & UNLOCKS
-- ================================
Config.Types = {
    worker = {
        baseReward = 100,

        levels = {
            [2] = { multiplier = 1.2 }, -- keep your test if needed
            [5] = { multiplier = 1.2, unlock = "better_jobs" },
            [10] = { multiplier = 1.5, unlock = "high_end_jobs" }
        }
    },

    scavenger = {
        baseReward = 150,

        levels = {
            [2] = { multiplier = 1.25 },
            [5] = { multiplier = 1.3, unlock = "rare_loot" },
            [10] = { multiplier = 1.6, unlock = "elite_scavenging" }
        }
    }
}
