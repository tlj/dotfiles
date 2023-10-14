-- https://github.com/goolord/alpha-nvim/discussions/16
-- https://github.com/freddiehaddad/nvim/blob/main/lua/plugins/alpha.lua

local razor1911 = {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function() require('lazy').show() end,
      })
    end

    require('alpha').setup(dashboard.opts)

		vim.api.nvim_create_autocmd('User', {
			pattern = 'LazyVimStarted',
			callback = function()
				local stats = require('lazy').stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = '󱐋 ' .. stats.count .. ' plugins loaded in ' .. ms .. 'ms'
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

    vim.api.nvim_create_autocmd('VimEnter', {
      once = true,
      callback = function () 
        math.randomseed(os.time())
        local fg_color = tostring(math.random(0,12))
        local hi_setter = "hi AlphaHeader ctermfg="
        vim.cmd(hi_setter .. fg_color)
      end
    })
  end,
  opts = function()
    local dashboard = require('alpha.themes.dashboard')
    local header = {
      '                                      ▄▀                                       ',
      '                         ░     ░░  ▄█▓▌ ░░ ░   ░                               ',
      '▄▄    ▀▀▓▓█▄▄▄   ▄▄███▄          ▄▓████▄                   ▄▄    ▀▀▓▓▄▄▄       ',
      ' ▀▓▓▓▄▄  ▀▓███▓▓▄ ▀██▓▓█▄▄▄    ▄▓▓▓▓█████▄▄    ▄ ■▄▓▄▄      ▀▓▓▓▄▄   ▀███▓▓▄   ',
      '  ▐▓████▓▄  ▀███▓▓▄ ██▓▌  ▀▓██▄ ▀▀▀████▓▀▀███▄▄▄   ▀████▄▄   ▐▓████▓▓▄ ▀███▓▓▄ ',
      '   ████▓▓▌   ▐███▓▓▌ ▀▀▀■  ▐█████▓▄ ▀ ▄▄▄████▓▀ ▄▀   █▓███▓▄  ████▓▓▌   ▐███▓▓▌',
      '   ▐████▓   ▄████▓▀ ▄▓▓▄    ███▓█▌ ▄██████▓▀▀ ▄▓▌    ▐▓████▓▓▄ ▀███▓   ▄████▓▀ ',
      '    ████▓ ▀▀▀▀▀▀ ▄▄███▀██▄▄ ▐█▓▓▓ ████▓▀▀  ▄██▓▓▌     █▀▓▀██▓▓▌ ███▓■▀██▀▀▀    ',
      '    ███▓▓▌■▀▓██▄▄ ▀██▄▓▄██▀▀■██▓▌  ▀██▄█▓▄▄ ▀▀█▓▓     ▐█▄███▓▓▌ ██▓▓  ▐███▄▄   ',
      '   ▐██▓▓▓▓  ▐███▓▓▄ ▀███▀    ██▓▓    ▀█████▓▓▄▄▄      ▐█████▓▓ ▐█▓▓▓   ▓███▓▓▄ ',
      '  ▄█████▓▓▓▄ ████▓▓▌ ██▓▌   ▐███▓▓     ▀██████▓▓▓▓▀  ▄█████▓▀ ▄████▓▌  ▐████▓▓▌',
      '■▀▀▀   ▀▀▓▀ ▐█████▓▓ ▐▓▓▓▓▄▄▓████▓▓      ▀███▓▓▀  ■▄▓██▓▓▀▀ ▄█▀   ▀▀▀  ▀▀▀███▓▓',
      '          ▄▓▓▓███▓▓▓▌ ▀▓▓▀▀     ▀█▓▓       ▓▓▀      ▀▀▀    ▄▀               ▀▀▓',
      '                ▀▀▀▓▓▄            ▀▓▓▄      ▀▄           ▄                     ',
      ' <cH!RiGOR>          ▀▓             ▀▓▌        ▀ ■ ▄ ■ ▀     1 9 1 1           ',
      '                      ▀▄             ▐▌                                        ',
      '                                                                               ',
    }
    local footer = {
      '__|_____ ___________________________________________________________________|__',
      '  |                                                                        .|  ',
      '  :     _ ___ _________                        -  N  E  O  V  i  M  -    .::|  ',
      '__|___________________________________________________________________ _____|__',
      '  |                                                                         |  ',
    }
    dashboard.section.header.val = header
    dashboard.section.footer.val = footer
    dashboard.section.terminal.width = 100
    dashboard.section.terminal.height = 45
    dashboard.section.terminal.opts.redraw = true
    dashboard.section.buttons.val = {
      dashboard.button('s', ' ' .. ' Restore Session', ':lua require("persistence").load() <cr>'),
      dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files <CR>'),
      dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
      dashboard.button('g', ' ' .. ' Find text', ':Telescope live_grep <CR>'),
      dashboard.button('l', '󰒲 ' .. ' Lazy', ':Lazy<CR>'),
      dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'AlphaHeader'
      button.opts.hl_shortcut = 'AlphaHeader'
    end
    dashboard.section.header.opts.hl = 'AlphaHeader'
    dashboard.section.buttons.opts.hl = 'AlphaButtons'
    dashboard.section.footer.opts.hl = 'AlphaFooter'
    dashboard.opts.layout[1].val = 2
    return dashboard
  end,
};

return razor1911;
