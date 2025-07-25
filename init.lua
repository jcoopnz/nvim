local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local global = vim.g
local option = vim.opt
local map = vim.keymap

global.mapleader = " "
global.maplocalleader = " "
global.have_nerd_font = true

-- behavioural
option.autoread = true
option.mouse = "a"
option.undofile = true
option.ignorecase = true
option.smartcase = true
option.splitright = true
option.splitbelow = false
option.inccommand = "nosplit"
option.confirm = true
option.smartindent = true
option.updatetime = 50
option.timeoutlen = 500
option.hidden = true

-- visual
option.wrap = true
option.breakindent = true
option.showmode = false
option.laststatus = 0
option.cursorline = true
option.list = true
option.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
option.number = true
option.relativenumber = true
option.hlsearch = true
option.incsearch = true
option.termguicolors = true
option.tabstop = 2
option.softtabstop = 2
option.shiftwidth = 2
option.expandtab = true
option.scrolloff = 8

map.set("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "Clear search highlight" })
map.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
map.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })
map.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
map.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })
map.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map.set("n", "J", "mzJ`z", { desc = "Append line below" })
map.set("x", "<LEADER>p", "\"_dP", { desc = "Special paste" })
map.set("n", "<LEADER>d", "\"_d", { desc = "Special delete" })
map.set("v", "<LEADER>d", "\"_d", { desc = "Special delete" })
map.set("n", "<LEADER>ul", ":Lazy<CR>", { desc = "Lazy" })
map.set("n", "<LEADER>um", ":Mason<CR>", { desc = "Mason" })
map.set("n", "<LEADER>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<LEFT><LEFT><LEFT>", { desc = "Substitute cursor word" })
map.set("n", "<LEADER>z", ":let @+=fnamemodify(expand(\"%:p\"), \":.\")<CR>", { desc = "Yank relative file name" })
map.set("n", "<LEADER>|", ":vs<CR>", { desc = "Vertical split" })
map.set("n", "D", ":lua vim.diagnostic.open_float(nil, {border='rounded',source=true})<CR>", { desc = "Show diagnostic" })
map.set("n", "q", "<Nop>", { noremap = true, silent = true })
map.set("n", "Q", "q", { noremap = true, silent = true })

-- scheduled to improve load
vim.schedule(function()
  option.clipboard = "unnamedplus"
end)

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})

require("lazy").setup({
  spec = {
    {
      "catppuccin/nvim",
      lazy = false, priority = 1001,
      name = "catppuccin",
      opts = function()
        vim.cmd([[colorscheme catppuccin-mocha]])
      end,
    },

    {
      "folke/snacks.nvim",
      lazy = false, priority = 1000,
      opts = {
        dashboard = {
          preset = {
            keys = {
              { icon = "🗒️ ", key = "n", desc = "New file", action = ":ene | startinsert" },
              { icon = "🔍 ", key = "f", desc = "Find file", action = ":lua Snacks.picker.smart()" },
              { icon = "🔬 ", key = "/", desc = "Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = "🗃️ ", key = ".", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
              { icon = "🛋️ ", key = "s", desc = "Restore session", section = "session" },
              { icon = "🪾 ", key = "g", desc = "Lazygit", action = ":lua Snacks.lazygit()" },
              { icon = "📦 ", key = "m", desc = "Mason", action = ":Mason" },
              { icon = "😴 ", key = "l", desc = "Lazy", action = ":Lazy" },
              { icon = "🚪 ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          formats = {
            header = { "%s", align = "center" },
            footer = { "%s", align = "center" },
          },
          sections = {
            { section = "header" },
            { section = "keys", padding = 1.5 },
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1.5 },
            { section = "startup" },
          },
        },
        bufdelete = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        image = { enabled = true },
        input = { enabled = true },
        lazygit = { enable = true },
        notifier = { enable = true },
        notify = { enable = true },
        picker = { enabled = true },
        scope = { enabled = true },
        scroll = { enable = true },
        words = { enabled = true },
      },
      keys = {
        -- @module "snacks"

        -- Find Files
        { "<LEADER><LEADER>", function() Snacks.picker.smart() end, desc = "Smart find files" },
        { "<LEADER>ff", function() Snacks.picker.git_files() end, desc = "Git files" },
        { "<LEADER>.", function() Snacks.picker.recent() end, desc = "Find recent files" },
        { "<LEADER>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config file" },

        -- Search Grep
        { "<LEADER>/",  function() Snacks.picker.grep() end, desc = "Search grep" },
        { "<LEADER>*", function() Snacks.picker.grep_word() end, desc = "Grep cursor word/selection", mode = { "n", "x" } },

        -- Find/Search Other
        { "<LEADER>sr", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<LEADER>sh", function() Snacks.picker.help() end, desc = "Help pages" },
        { "<LEADER>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },

        -- Git
        { "<LEADER>g", function() Snacks.lazygit() end, desc = "Lazygit" },

        -- LSP
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition" },
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "Goto references" },
        { "<LEADER>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
        { "<LEADER>uL", function() Snacks.picker.lsp_config() end, desc = "LSP config" },

        -- Buffers
        { "<LEADER>bd", function() Snacks.bufdelete() end, desc = "Delete" },
        { "<LEADER>bo", function() Snacks.bufdelete.other() end, desc = "Delete others" },
        { "<LEADER>,",  function() Snacks.picker.buffers() end, desc = "Search buffers" },
        { "<LEADER>sb", function() Snacks.picker.grep_buffers() end, desc = "Open buffers" },

        -- Others
        { "<LEADER>e",  function() Snacks.explorer() end, desc = "File explorer" },
        { "<LEADER>nh",  function() Snacks.notifier.show_history() end, desc = "History" },
        { "<LEADER>nd", function() Snacks.notifier.hide() end, desc = "Dismiss all" },
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
        { "<LEADER>rf", function() Snacks.rename.rename_file() end, desc = "Rename file" },
      },
      init = function()
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
              Snacks.debug.inspect(...)
            end
            _G.bt = function()
              Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            -- Toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<LEADER>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<LEADER>uw")
            Snacks.toggle.diagnostics():map("<LEADER>ud")
            Snacks.toggle.inlay_hints():map("<LEADER>uh")
          end,
        })
      end,
    },

    {
      -- NOTE: moving to the new "main" branch is buggy in angular component files
      "nvim-treesitter/nvim-treesitter", branch = "master",
      lazy = vim.fn.argc(-1) == 0, -- load early when opening file from cli
      event = "BufReadPre",
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      build = ":TSUpdate",
      opts = {
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        -- FIX: ensure_installed doesn't seem to ensure they're installed
        -- ensure_installed = {
        --   "angular",
        --   "bash",
        --   "css",
        --   "git_config",
        --   "gitignore",
        --   "go",
        --   "html",
        --   "http",
        --   "javascript",
        --   "json",
        --   "lua",
        --   "markdown",
        --   "markdown_inline",
        --   "pug",
        --   "regex",
        --   "scss",
        --   "svelte",
        --   "typescript",
        --   "vim",
        --   "yaml"
        -- },
      },
    },

    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      opts = {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        messages = {
          view_search = false,
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        routes = {
          {
            view = "notify",
            filter = { event = "msg_showmode" },
          },
        },
      },
    },

    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        preset = "helix",
        defaults = {},
        spec = {
          {
            mode = { "n", "v" },
            { "<LEADER>b", group = "Buffer" },
            { "<LEADER>x", group = "Diagnostics" },
            { "<LEADER>f", group = "Find" },
            { "<LEADER>n", group = "Notification" },
            { "<LEADER>r", group = "Rename" },
            { "<LEADER>s", group = "Search" },
            { "<LEADER>u", group = "User settings" },
          },
        },
      },
    },

    {
      "mason-org/mason-lspconfig.nvim",
      event = "VeryLazy",
      dependencies = {
        {
          "mason-org/mason.nvim",
          lazy = true,
          opts = {},
        },
        {
          "neovim/nvim-lspconfig",
          lazy = true,
          config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function()
                map.set("n", "<LEADER>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
              end
            })
          end,
        },
      },
      opts = {
        ensure_installed = {
          "ast_grep",
          "lua_ls",
          "ts_ls"
        },
      },
    },

    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
    },

    {
      "tpope/vim-repeat",
      event = "VeryLazy",
    },

    {
      "akinsho/bufferline.nvim", version = "*",
      event = "BufReadPre",
      opts = {
        options = {
          color_icons = true,
          sort_by = "relative_directory",
          truncate_names = false,
        },
      },
      keys = {
        { "L", ":BufferLineCycleNext<CR>", desc = "Next buffer", silent = true },
        { "H", ":BufferLineCyclePrev<CR>", desc = "Previous buffer", silent = true },
        { "<D-L>", ":BufferLineMoveNext<CR>", desc = "Move buffer forwards", silent = true },
        { "<D-H>", ":BufferLineMovePrev<CR>", desc = "Move buffer backwards", silent = true },
      },
    },

    {
      "folke/todo-comments.nvim",
      event = "BufReadPre",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
    },

    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      opts = {},
    },

    {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      opts = {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "~/-" },
          untracked = { text = "▎" },
        },
        signs_staged = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "~/-" },
        },
        numhl = true,
      },
    },

    {
      "nvim-lualine/lualine.nvim",
      event = "BufReadPre",
      opts = function()
        local noice = require("noice")
        return {
          options = {
            icons_enabled = true,
            theme = "auto",
            globalstatus = true,
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
            component_separators = { left = "", right = ""},
            section_separators = { left = "", right = ""},
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "diff", "diagnostics" },
            lualine_c = { "", { "filename", path = 1, shorting_target = 60 } },
            lualine_x = {
              {
                noice.api.status.command.get,
                cond = noice.api.status.command.has,
                color = { fg = "#ff9e64" },
              },
              "searchcount",
              "selectioncount",
              "lsp_status"
            },
            lualine_z = { "location" },
          },
        }
      end,
    },

    {
      "saghen/blink.cmp", version = "1.*",
      event = "BufReadPre",
      dependencies = {
        { "rafamadriz/friendly-snippets", lazy = true },
      },
      opts = {
        keymap = { preset = "default" },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust" },
      },
    },

    {
      "echasnovski/mini.pairs",
      event = "BufReadPost",
      opts = {
        modes = { insert = true, command = true, terminal = false },
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        skip_ts = { "string" },
        skip_unbalanced = true,
        markdown = true,
      },
    },

    {
      "nvim-treesitter/nvim-treesitter-context",
      event = "BufReadPost",
      opts = {},
    },

    {
      "tpope/vim-surround",
      event = "BufReadPost",
    },

    {
      "MagicDuck/grug-far.nvim",
      cmd = "GrugFar",
      opts = { headerMaxWidth = 80 },
      keys = {
        {
          "<LEADER>sR",
          function()
            local grug = require("grug-far")
            local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
            grug.open({
              transient = true,
              prefills = {
                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
              },
            })
          end,
          mode = { "n", "v" },
          desc = "Search and replace",
        },
      },
    },

    {
      "folke/trouble.nvim",
      cmd = "Trouble",
      opts = {
        focus = true,
        auto_close = true,
      },
      keys = {
        {
          "<LEADER>x",
          "<CMD>Trouble diagnostics toggle filter.buf=0<CR>",
          desc = "Diagnostics list",
        },
        {
          "<LEADER>X",
          "<CMD>Trouble todo toggle filter.buf=0<CR>",
          desc = "Todos list",
        },
      },
    },

    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },

  checker = { enabled = true },
})
