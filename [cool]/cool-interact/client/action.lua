CoolInteract = CoolInteract or {}

-- ================================
-- ⚙️ START ACTION
-- ================================
CoolInteract.StartAction = function(data)

    local duration = data.duration or 5000
    local label = data.label or "Working..."
    local anim = data.anim or nil -- 🆕 ADDED

    local ped = PlayerPedId()

    if Config.Debug then
        print("[INTERACT] Action started:", label, "| Duration:", duration)
    end

    -- ================================
    -- 🎭 PLAY ANIMATION
    -- ================================
    if anim then  -- 🆕 ADDED
        RequestAnimDict(anim.dict)
        while not HasAnimDictLoaded(anim.dict) do Wait(0) end

        TaskPlayAnim(  
            ped,
            anim.dict,
            anim.clip,
            8.0,
            -8.0,
            duration,
            anim.flag or 1,
            0,
            false,
            false,
            false
        )

        if Config.Debug then
            print("[INTERACT] Playing animation:", anim.dict, anim.clip)
        end
    end

    -- ================================
    -- 🧠 PROGRESS BAR
    -- ================================
    local success = lib.progressBar({
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })

    -- ================================
    -- 🧠 CLEAR ANIMATION
    -- ================================
    ClearPedTasks(ped) -- 🆕 ADDED

    -- ================================
    -- 🧠 RESULT
    -- ================================
    if success then
        if Config.Debug then
            print("[INTERACT] Action SUCCESS")
        end

        if data.onFinish then
            data.onFinish()
        end
    else
        if Config.Debug then
            print("[INTERACT] Action CANCELLED")
        end

        if data.onCancel then
            data.onCancel()
        end
    end
end

-- ================================
-- 📤 EXPORT
-- ================================
exports('StartAction', CoolInteract.StartAction)