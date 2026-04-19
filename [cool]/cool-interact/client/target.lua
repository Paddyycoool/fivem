CoolInteract = CoolInteract or {}

-- ================================
-- 🎯 ADD ENTITY TARGET
-- ================================
CoolInteract.AddEntity = function(entity, data)

    if Config.Debug then
        print("[INTERACT] Adding entity target")
    end

    exports.ox_target:addLocalEntity(entity, {
        {
            name = data.name or "interact",
            label = data.label or "Interact",
            icon = data.icon or "fa-solid fa-hand",
            onSelect = function()
                if data.onSelect then
                    data.onSelect()
                end
            end
        }
    })
end

-- ================================
-- 🎯 ADD MODEL TARGET
-- ================================
CoolInteract.AddModel = function(models, data)

    if Config.Debug then
        print("[INTERACT] Adding model target")
    end

    exports.ox_target:addModel(models, {
        {
            name = data.name or "interact",
            label = data.label or "Interact",
            icon = data.icon or "fa-solid fa-hand",
            onSelect = function(entity)
                if data.onSelect then
                    data.onSelect(entity)
                end
            end
        }
    })
end

-- ================================
-- 📤 EXPORTS
-- ================================
exports('AddEntity', CoolInteract.AddEntity)
exports('AddModel', CoolInteract.AddModel)