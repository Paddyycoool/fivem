CoolUI = {}

-- ================================
-- 🧹 FORCE CLOSE ON LOAD (CRITICAL FIX)
-- ================================
CreateThread(function()
    Wait(500) -- let everything initialize
    SendNUIMessage({
        action = "CLOSE",
        layer = "interaction"
    })
    print("[UI FIX] Forced interaction closed on load")
end)

-- ================================
-- 🧠 INTERNAL SEND
-- ================================
local function send(action, layer, data)

    print("[UI DEBUG] Action:", action, "| Layer:", layer, "| Data:", json.encode(data)) -- 🆕 DEBUG

    SendNUIMessage({
        action = action,
        layer = layer,
        data = data
    })
end

-- ================================
-- 🧠 LIVE XP UPDATE
-- ================================
RegisterNetEvent('cool-ui:updateXP', function(skill, progress)
    SendNUIMessage({
        action = "UPDATE",
        layer = "interaction",
        data = { progress = progress }
    })
end)

-- ================================
-- 🎯 XP POPUP EVENT
-- ================================
RegisterNetEvent('cool-ui:showXP', function(skill, amount, progress)
    exports['cool-ui']:ShowInteraction({
        type = skill .. " +" .. amount .. " XP",
        duration = 2000,
        progress = progress
    })
end)

-- ================================
-- 🔹 INTERACTION (FIXED SYSTEM)
-- ================================
local interactionOpen = false -- 🆕 STATE TRACK

CoolUI.ShowInteraction = function(data)
    if interactionOpen then
        send("CLOSE", "interaction", {})
        interactionOpen = false
    end

    send("OPEN", "interaction", data)
    interactionOpen = true

    print("[UI] OPEN:", data.type) -- 🆕 DEBUG

    if data.duration then
        CreateThread(function()
            local current = data.type -- track THIS instance
            Wait(data.duration)

            if interactionOpen then
                send("CLOSE", "interaction", {})
                interactionOpen = false
                print("[UI] CLOSED:", current)
            end
        end)
    end
end

-- ================================
-- 🔹 PANEL (MID UI)
-- ================================
CoolUI.OpenPanel = function(data)
    send("OPEN", "panel", data)
    SetNuiFocus(true, true)
    print("[UI] Panel opened")
end

CoolUI.ClosePanel = function()
    send("CLOSE", "panel", {})
    SetNuiFocus(false, false)
    print("[UI] Panel closed")
end

-- ================================
-- 🔹 FULLSCREEN (BIG UI)
-- ================================
CoolUI.OpenFullscreen = function(data)
    send("OPEN", "fullscreen", data)
    SetNuiFocus(true, true)
    print("[UI] Fullscreen opened")
end

CoolUI.CloseFullscreen = function()
    send("CLOSE", "fullscreen", {})
    SetNuiFocus(false, false)
    print("[UI] Fullscreen closed")
end

-- ================================
-- 🔹 UPDATE
-- ================================
CoolUI.UpdateInteraction = function(data)
    send("UPDATE", "interaction", data)
end

-- ================================
-- 🧹 UI TOGGLE (FIXED)
-- ================================
function toggleUI(elementId, action)
    -- Directly send NUI message to show/hide the popups
    if action == 'show' then
        SendNUIMessage({
            action = "OPEN",
            layer = elementId
        })
        SetNuiFocus(true, true)  -- Focus on NUI so it appears on screen
        print("[UI DEBUG] Showing " .. elementId)  -- 🆕 DEBUG
    elseif action == 'hide' then
        SendNUIMessage({
            action = "CLOSE",
            layer = elementId
        })
        SetNuiFocus(false, false)  -- Remove NUI focus
        print("[UI DEBUG] Hiding " .. elementId)  -- 🆕 DEBUG
    end
end

-- Register events to show/hide UI popups
RegisterNetEvent('toggleSmallUI')
AddEventHandler('toggleSmallUI', function(data)
    if data.show then
        toggleUI('smallUI', 'show')
        print("[UI DEBUG] Showing Small UI for player " .. source)  -- 🆕 DEBUG
    else
        toggleUI('smallUI', 'hide')
        print("[UI DEBUG] Hiding Small UI for player " .. source)  -- 🆕 DEBUG
    end
end)

RegisterNetEvent('toggleMediumUI')
AddEventHandler('toggleMediumUI', function(data)
    if data.show then
        toggleUI('mediumUI', 'show')
        print("[UI DEBUG] Showing Medium UI for player " .. source)  -- 🆕 DEBUG
    else
        toggleUI('mediumUI', 'hide')
        print("[UI DEBUG] Hiding Medium UI for player " .. source)  -- 🆕 DEBUG
    end
end)

RegisterNetEvent('toggleLargeUI')
AddEventHandler('toggleLargeUI', function(data)
    if data.show then
        toggleUI('largeUI', 'show')
        print("[UI DEBUG] Showing Large UI for player " .. source)  -- 🆕 DEBUG
    else
        toggleUI('largeUI', 'hide')
        print("[UI DEBUG] Hiding Large UI for player " .. source)  -- 🆕 DEBUG
    end
end)

-- ================================
-- 📤 EXPORTS
-- ================================
exports('ShowInteraction', CoolUI.ShowInteraction)
exports('HideInteraction', CoolUI.HideInteraction)

exports('OpenPanel', CoolUI.OpenPanel)
exports('ClosePanel', CoolUI.ClosePanel)

exports('OpenFullscreen', CoolUI.OpenFullscreen)
exports('CloseFullscreen', CoolUI.CloseFullscreen)

exports('UpdateInteraction', CoolUI.UpdateInteraction)