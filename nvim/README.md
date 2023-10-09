## Keymaps

### Window navigation
* C-h - Go to left window
* C-j - Go to lower window
* C-k - Go to upper window
* C-l - Go to right window
* C-Up - Increase horizontal size
* C-Down - Decrease horizontal size
* C-Left - Increase vertical size
* C-Right - Increase horizontal size
* \<leader\>ww - Other window
* \<leader\>wd - Delete window
* \<leader\>w- - Split window below
* \<leader\>w| - Split window right
* \<leader\>- - Split window below
* \<leader\>| - Split window right

### Buffer navigation
* \[b - Previous buffer
* \]b - Next buffer
* \<leader\>bb - Switch to other buffer
* \<leader\>` - Switch to other buffer

### Text movement
* C-S-k - Move line/block up
* C-S-j - Move line/block down
* \<esc\> - Clear search

### Terminal
* \<leader\>lg - LazyGit
* \<leader\>ft - FloatTerm

### Folding
* zR - Open all folds
* zM - Close all folds

## Plugins

#### [auto-session](https://github.com/rmagatti/auto-session)
* When starting nvim with no arguments, auto-session will try to restore an existing session for the current cwd if one exists.
* When starting nvim . with some argument, auto-session will do nothing.
* Even after starting nvim with an argument, a session can still be manually restored by running :SessionRestore.
* Any session saving and restoration takes into consideration the current working directory cwd.
* When piping to nvim, e.g: cat myfile | nvim, auto-session behaves like #2.

#### [code_runner](https://github.com/CRAG666/code_runner.nvim)
* :RunCode: Runs based on file type, first checking if belongs to project, then if filetype mapping exists
* :RunCode <A_key_here>: Execute command from its key in current directory.
* :RunFile <mode>: Run the current file (optionally you can select an opening mode).
* :RunProject <mode>: Run the current project(If you are in a project otherwise you will not do anything,).
* :RunClose: Close runner(Doesn't work in better_term mode, use native plugin options)

#### [colorizer](https://github.com/norcalli/nvim-colorizer.lua)
* A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit.

#### [colorscheme-melange](https://github.com/savq/melange-nvim)
* Melange was designed with one idea in mind: Control flow should use warm colors and data should use cold colors; It was originally developed using Lush.nvim; and it's been inspired by many colorschemes, in particular Ayu and Gruvbox.

#### [copilot](https://github.com/zbirenbaum/copilot.lua)
* Panel can be used to preview suggestions in a split window. You can run the :Copilot panel command to open it.

Keymap:
* \<leader\>cp - Copilot panel

#### [dadbod](https://github.com/tpope/vim-dadbod)
* Dadbod is a Vim plugin for interacting with databases.
* The :DB command has a few different usages. All forms accept a URL as the first parameter, which can be omitted if a default is configured or provided by a plugin.

Commands:
* :DB

#### [dap](https://github.com/mfussenegger/nvim-dap)
* nvim-dap is a Debug Adapter Protocol client implementation for Neovim. nvim-dap allows you to:
* Launch an application to debug
* Attach to running applications and debug them
* Set breakpoints and step through code
* Inspect the state of the application

Keymap:
* F5 - Continue
* F6 - Step Over
* F7 - Step Into
* F8 - Step Out
* \<leader\>db - Toggle Breakpoint
* \<leader\>dB - Breakpoint Condition
* \<leader\>dc - Continue
* \<leader\>ds - Stop
* \<leader\>do - Step Over
* \<leader\>di - Step Into
* \<leader\>dt - Telescope Dap Commands

#### [endpoint-previewer](https://github.com/tlj/endpoint-previewer.nvim)
* A Neovim plugin to browse API endpoints directly in the editor.

Keymap:
* \<leader\>sg - Endpoints valid for text on cursor
* \<leader\>sr - Recently Opened
* \<leader\>se - List of endpoints
* \<leader\>su - Update endpoint list
* \<leader\>sa - Select an API
* \<leader\>sd - Select environment
* \<leader\>sx - Select remove environment

#### [flash](https://github.com/folke/flash.nvim)
* flash.nvim lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.

Keymap:
* s - Start search
* S - Treesitter (select blocks. ; - expands , - shrinks)

#### [git-blame-line](https://github.com/kessejones/git-blame-line.nvim)
* This plugin is inspired by vscode's Gitlens extension.

Keymap:
* \<leader\>gb - Toggle Blame line

#### [gitsigns](https://github.com/lewis6991/gitsigns.nvim)
* Super fast git decorations implemented purely in Lua.
* Signs for added, removed, and changed lines
* Asynchronous using luv
* Navigation between hunks
* Stage hunks (with undo)
* Preview diffs of hunks (with word diff)
* Customizable (signs, highlights, mappings, etc)
* Status bar integration
* Git blame a specific line using virtual text.
* Hunk text object
* Automatically follow files moved in the index.
* Live intra-line word diff
* Ability to display deleted/changed lines via virtual lines.
* Support for yadm
* Support for detached working trees.

Keymap:
* \<leader\>hs - Hunk Stage
* \<leader\>hr - Hunk Reset
* \<leader\>hS - Stage Buffer
* \<leader\>hu - Undo Stage
* \<leader\>hR - Reset Buffer
* \<leader\>hp - Preview Hunk
* \<leader\>hb - Blame Line
* \<leader\>tb - Toggle Curent Lime Blame
* \<leader\>hd - Diff This
* \<leader\>hD - Diff This ~
* \<leader\>td - Toggle Deleted

#### [lsp-zero](https://github.com/VonHeikemen/lsp-zero.nvim)
* Collection of functions that will help you setup Neovim's LSP client, so you can get IDE-like features with minimum effort.
* Out of the box it will help you integrate nvim-cmp (an autocompletion plugin) and nvim-lspconfig (a collection of configurations for various LSP servers).

#### [lualine-diagnostic-message](https://github.com/Isrothy/lualine-diagnostic-message)
* Show LSP diagnostic message on lualine

#### [lualine](https://github.com/nvim-lualine/lualine.nvim)
* A blazing fast and easy to configure Neovim statusline written in Lua.

#### [markdown-preview](https://github.com/iamcco/markdown-preview.nvim)
* Preview markdown on your modern browser with synchronised scrolling and flexible configuration

Commands:
* MarkdownPreview
* MarkdownPreviewStop
* MarkdownPreviewToggle

#### [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
* Neo-tree is a Neovim plugin to browse the file system and other tree like structures in whatever style suits you, including sidebars, floating windows, netrw split style, or all of them at once!

Keymap:
* \<leader\>tt - Open Tree in window

#### [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)
* The goal of nvim-bqf is to make Neovim's quickfix window better.
* Toggle quickfix window with magic window keep your eyes comfortable
* Extend built-in context of quickfix to build an eye friendly highlighting at preview
* Support convenient actions inside quickfix window, see Function table below
* Optimize the buffer preview under treesitter to get extreme performance
* Using signs to filter the items of quickfix window
* Integrate fzf as a picker/filter in quickfix window
* Mouse supported for preview window

#### [nvim-luaref](https://github.com/milisims/nvim-luaref)
* This 'plugin' simply adds a reference for builtin lua functions, extracting both text and formatting from the Lua 5.1 Reference Manual. 

#### [nvim-neotest](https://github.com/nvim-neotest/neotest)
* A framework for interacting with tests within NeoVim.

Keymap:
* \<leader\>tn - Run Nearest Test
* \<leader\>tf - Run Current File

#### [nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
* A search panel for neovim.
* Use regex in search
* It can filter search by path glob (filetype)
* It only searches when you leave Insert Mode, incsearch can be annoying when writing regex
* Use one buffer and you can edit or move
* A tool to replace text on project

Keymap:
* \<leader\>fr - Find/Replace in files
* \<leader\>fw - Find/Replace current word in files
* \<leader\>fc - Search in current file

#### [statuscol](https://github.com/luukvbaal/statuscol.nvim)
* Status column plugin that provides a configurable 'statuscolumn' and click handlers. 
* Status column containing a fold column without fold depth digits, a custom sign segment that will only show diagnostic signs, a number column with right aligned relativenumbers and a sign segment that is only 1 cell wide that shows all other signs.

#### [telescope](https://github.com/nvim-telescope/telescope.nvim)
* telescope.nvim is a highly extendable fuzzy finder over lists. Built on the latest awesome features from neovim core. Telescope is centered around modularity, allowing for easy customization.

Keymap:
* \<leader\>ff - Find Files
* \<leader\>fg - Live Grep
* \<leader\>* - Match current word
* \<leader\>fb - Buffers
* \<leader\>fh - Help Tags
* \<leader\>gs - Git Status
* \<leader\>td - Telescope diagnostics
* \<leader\>qf - QuickFix 
* \<leader\>u - Telescope Undo
* q: - Command history

#### [telescope-undo](https://github.com/debugloop/telescope-undo.nvim)
* Visualize your undo tree and fuzzy-search changes in it. For those days where committing early and often doesn't work out.

#### [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* The goal of nvim-treesitter is both to provide a simple and easy way to use the interface for tree-sitter in Neovim and to provide some basic functionality such as highlighting based on it.

#### [which-key](https://github.com/folke/which-key.nvim)
* WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible key bindings of the command you started typing. Heavily inspired by the original emacs-which-key and vim-which-key.

