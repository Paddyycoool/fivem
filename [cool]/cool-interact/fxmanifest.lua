fx_version 'cerulean'
game 'gta5'

name 'cool-interact'

-- ================================
-- 🧠 SHARED
-- ================================
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

-- ================================
-- 💻 CLIENT
-- ================================
client_scripts {
    'client/target.lua',
    'client/action.lua'
}

-- ================================
-- 🖥️ SERVER
-- ================================
server_scripts {
    'server/server.lua'
}