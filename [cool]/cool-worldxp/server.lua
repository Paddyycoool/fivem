RegisterNetEvent('cool-worldxp:reward', function(id)
    local src = source

    for _, loc in pairs(Config.Locations) do
        if loc.id == id then

            -- ================================
            -- 🧠 GIVE XP
            -- ================================
            exports['cool-core']:AddXP(src, loc.skill, loc.xp)

            -- ================================
            -- 📢 NOTIFY
            -- ================================
            exports['cool-core']:Notify(
                src,
                "Scavenging",
                "+" .. loc.xp .. " XP",
                "success"
            )

            print("[WORLD XP] Player:", src, "| Skill:", loc.skill, "| XP:", loc.xp)

            return
        end
    end
end)