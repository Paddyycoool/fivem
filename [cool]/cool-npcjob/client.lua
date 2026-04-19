CreateThread(function()
    Wait(1000) -- 🆕 ensure player + xp loaded

    local src = PlayerId()

    -- ================================
    -- 🧠 REQUEST PLAYER SKILLS
    -- ================================
    local skillData = lib.callback.await('cool-xp:getXP', false) -- 🆕 USE CALLBACK

    print("[NPC DEBUG] Player Skills:", json.encode(skillData or {})) -- 🆕 DEBUG

    for _, npcData in pairs(Config.NPCs) do

        -- ================================
        -- 🔒 CHECK LEVEL REQUIREMENT
        -- ================================
        local level = 1

        if skillData and skillData[npcData.type] then
            level = skillData[npcData.type].level or 1
        end

        local requiredLevel = npcData.requiredLevel or 1

        if level < requiredLevel then
            print("[NPC HIDDEN] ", npcData.id, "| Required:", requiredLevel, "| Player:", level)
            goto continue -- 🆕 skip spawning
        end

        -- ================================
        -- 🧠 SPAWN NPC
        -- ================================
        local model = npcData.model

        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local ped = CreatePed(0, model, npcData.coords.xyz, npcData.coords.w, false, true)

        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        SetEntityAsMissionEntity(ped, true, true)
        SetPedCanRagdoll(ped, false)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanPlayAmbientBaseAnims(ped, true)
        SetPedCanBeTargetted(ped, false)

        SetPedFleeAttributes(ped, 0, false)
        SetPedCombatAttributes(ped, 46, true)
        SetPedSeeingRange(ped, 0.0)
        SetPedHearingRange(ped, 0.0)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = npcData.id,
                label = 'Talk',
                icon = 'fa-solid fa-user',
                onSelect = function()
                    TriggerServerEvent('cool-npcjob:interact', npcData.id)
                end
            }
        })

        print("[NPC SPAWNED]", npcData.id) -- 🆕 DEBUG

        ::continue::
    end
end)