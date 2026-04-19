local cooldowns = {}

CreateThread(function()

    for _, loc in pairs(Config.Locations) do

        exports['cool-interact']:AddModel(loc.models, {
            label = "Search",

            onSelect = function(entity)

                exports['cool-interact']:StartAction({
                    label = "Searching...",
                    duration = 5000,

                    anim = { -- 🆕 ADDED
                        dict = "amb@prop_human_bum_bin@base",
                        clip = "base",
                        flag = 1
                    },

                    onFinish = function()
                        TriggerServerEvent('cool-worldxp:reward', loc.id)
                    end
                })

            end
        })

        print("[WORLD XP] Target added for:", loc.id)
    end

end)

-- ================================
-- 🧠 SIMPLE 3D TEXT
-- ================================
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end