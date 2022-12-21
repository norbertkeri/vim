return {
    'klen/nvim-config-local',
    config = function()
        require('config-local').setup {
            config_files = { ".vimrc.lua", ".vimrc" },  -- Config file patterns to load (lua supported)
            hashfile = vim.fn.stdpath("data") .. "/config-local", -- Where the plugin keeps files data
            autocommands_create = true,                 -- Create autocommands (VimEnter, DirectoryChanged)
            commands_create = true,                     -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
            silent = false,                             -- Disable plugin messages (Config loaded/ignored)
            lookup_parents = true,                     -- Lookup config files in parent directories
        }
    end
}
