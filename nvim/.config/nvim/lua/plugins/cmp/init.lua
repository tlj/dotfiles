-- ideas from https://github.com/arsham/shark/blob/v3.0.0/lua/plugins/cmp/init.lua
local kind_icons = require("config.icons").kinds

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

return {
  {
    'hrsh7th/nvim-cmp',
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      'hrsh7th/cmp-buffer', -- Buffer completions
      'hrsh7th/cmp-path', -- path competions
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'hrsh7th/cmp-nvim-lua', -- Lua completions
      'hrsh7th/cmp-cmdline', -- CommandLine completions
      'saadparwaiz1/cmp_luasnip', -- Snippet completions
      'L3MON4D3/LuaSnip', -- Snippet engine
      'rafamadriz/friendly-snippets', -- Bunch of snippets
      {
        'windwp/nvim-autopairs',
        enabled = true,
        config = function()
          require("nvim-autopairs").setup({
            check_ts = true, -- treesitter integration
            disable_filetype = { "TelescopePrompt" },
          })

          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          local cmp = require("cmp")
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
        end
      }
    },
    enabled = true,
    config = function()
      local cmp = require("cmp")
      local ls = require("luasnip")

      cmp.setup({
        performance = {
          debounce = 50,
          throttle = 10,
        },

        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },

        preselect = cmp.PreselectMode.None,

        sources = {
          { name = 'copilot', priority = 100 },
          { name = 'nvim_lsp', priority = 80 },
          { name = 'nvim_lua', priority = 70 },
          { name = 'luasnip', priority = 30 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'buffer' },
          { name = 'path' },
          {
            name = "rg",
            keyword_length = 3,
            priority = 5,
            group_index = 5,
            option = {
              additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/scripts/rgignore",
            },
          },
          { name = 'emoji', keyword_length = 1 },
          { name = 'nerdfont', keyword_length = 1 },
        },

        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, vim_item)
            local client_name = ""
            if entry.source.name == "nvim_lsp" then
              client_name = "/" .. entry.source.source.client.name
            end

            vim_item.menu = string.format("[%s%s]", ({
              buffer = "Buffer",
              nvim_lsp = "LSP",
              luasnip = "LuaSnip",
              nvim_lua = "Lua",
              path = "Path",
              rg = "RG",
              omni = "Omni",
              neorg = "ORG",
            })[entry.source.name] or entry.source.name, client_name)

            vim_item.kind = string.format("%s %-9s", kind_icons[vim_item.kind], vim_item.kind)
            vim_item.dup = {
              buffer = 1,
              path = 1,
              nvim_lsp = 0,
              luasnip = 1,
            }
            return vim_item
          end,
        },

        view = {
          max_height = 20,
        },

        window = {
          completion = cmp.config.window.bordered({
            border = require("config.icons").border_fn("CmpBorder"),
            winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
          }),
          documentation = {
            border = require("config.icons").border_fn("CmpDocBorder"),
          },
        },

        experimental = {
          ghost_text = true,
        },

        mapping = cmp.mapping.preset.insert {
          ["<C-Space>"] = cmp.mapping.complete({
            config = {
              sources = {
                { name = 'copilot', priority = 80 },
                { name = 'nvim_lsp', priority = 80 },
                { name = 'nvim_lua', priority = 80 },
                { name = 'path', priority = 40 },
                { name = 'luasnip', priority = 10 },
                { name = 'nvim_lsp_signature_help' },
              },
            },
          }),

          -- luasnip
          -- go to next placeholder in the snippet
          ["<C-d>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, {'i', 's'}),

          -- go to the previous placeholder in the snippet
          ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {'i', 's'}),

          -- Navigate items on the list
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),

          -- Scoll up and down in the completion documentation
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-5)),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(5)),

          -- toggle completion
          ["<C-e>"] = cmp.mapping(function(_)
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end),

          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<C-y>"] = cmp.mapping.confirm { select = false },

          -- when menu is visible, navigate to next item
          -- when line is empty, insert a tab character
          -- else activate completion
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
            elseif check_back_space() then
              fallback()
            else
              cmp.complete()
            end
          end, {
              "i",
              "s",
            }),

          -- when menu is visible, navigate to previous item on list
          -- else revert to default behavior
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
            else
              fallback()
            end
          end, {
              "i",
              "s",
            }),
        },

        cmp.setup.filetype("gitcommit", {
          sources = cmp.config.sources({
            { name = "git", priority = 100 },
            { name = "luasnip", priority = 80 },
            { name = "rg", priority = 50 },
            { name = "path", priority = 10 },
            { name = "emoji" },
            { name = "nerdfont" },
          })
        })
      })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    name = "nvim-cmp.commandline",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    event = { "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-j>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          },
          ["<C-k>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        }),

        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline({
            ["<C-j>"] = {
              c = function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end,
            },
            ["<C-k>"] = {
              c = function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end,
            },
          }),
          sources = cmp.config.sources({
            { name = "cmdline" },
          }, {
              { name = "path" },
            }),
        }),
      })
    end,
  },
}
