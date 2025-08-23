local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
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
option.confirm = true
option.smartindent = true
option.updatetime = 50
option.timeoutlen = 500

-- visual
option.wrap = true
option.breakindent = true
option.signcolumn = 'yes'
option.showmode = false
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

map.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left", silent = true })
map.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right", silent = true })
map.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down", silent = true })
map.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up", silent = true })
map.set("n", "<LEADER>w", ":write<CR>", { desc = "Write file", silent = true })
map.set("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "Clear search highlight", silent = true })
map.set("n", "<LEADER>ul", ":Lazy<CR>", { desc = "Lazy", silent = true })
map.set("n", "<LEADER>um", ":Mason<CR>", { desc = "Mason", silent = true })
map.set("n", "Q", "q", { noremap = true, silent = true })
map.set("n", "q", "<Nop>", { noremap = true, silent = true })
map.set("n", "<LEADER>|", ":vs<CR>", { desc = "Vertical split", silent = true })
map.set("n", "J", "mzJ`z", { desc = "Append line below", silent = true })
map.set("x", "<LEADER>p", "\"_dP", { desc = "Special paste", silent = true })
map.set({ "n", "v" }, "<LEADER>d", "\"_d", { desc = "Special delete", silent = true })
map.set(
  "n", "<LEADER>z",
  ":let @+=fnamemodify(expand(\"%:p\"), \":.\")<CR>",
  { desc = "Yank relative file name", silent = true }
)
map.set(
  "n", "D",
  ":lua vim.diagnostic.open_float(nil, {border='rounded',source=true})<CR>",
  { desc = "Show diagnostic", silent = true }
)
map.set(
  "n", "<LEADER>S",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<LEFT><LEFT><LEFT>",
  { desc = "Substitute cursor word" }
)

-- scheduled to improve load
vim.schedule(function()
  option.clipboard = "unnamedplus"
end)

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- enable Copilot only in certain directories
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local copilot_dirs = {
      "~/Documents/personal/webdev/", -- work mac
      "~/Documents/dev/",             -- personal mac
      "~/.config/nvim/",              -- both
    }

    local current_path = vim.fn.expand("%:p")
    local is_whitelisted = false
    for _, dir in ipairs(copilot_dirs) do
      if current_path:match("^" .. vim.fn.expand(dir)) then
        is_whitelisted = true
        break
      end
    end

    vim.g.copilot_filetypes = { ["*"] = is_whitelisted }
  end,
})

require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1001,
      opts = function()
        vim.cmd([[colorscheme tokyonight-night]])
      end,
    },

    {
      "folke/snacks.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        dashboard = {
          preset = {
            keys = {
              { icon = "🛋️ ", key = "s", desc = "Restore session", section = "session" },
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
        explorer = {
          enabled = true,
          auto_close = true,
        },
        picker = {
          enabled = true,
          layout = { cycle = false },
        },
        bufdelete = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        image = { enabled = true },
        lazygit = { enable = true },
        notifier = { enable = true },
        notify = { enable = true },
        scroll = { enable = true },
        words = { enabled = true },
      },
      keys = {
        -- Find Files
        { "<LEADER><LEADER>", function() Snacks.picker.smart() end,     desc = "Smart find files" },
        { "<LEADER>ff",       function() Snacks.picker.git_files() end, desc = "Git files" },
        { "<LEADER>.",        function() Snacks.picker.recent() end,    desc = "Find recent files" },
        {
          "<LEADER>fc",
          function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
          desc = "Config file"
        },

        -- Search Grep
        { "<LEADER>/",  function() Snacks.picker.grep() end,            desc = "Search grep" },
        {
          "<LEADER>*",
          function() Snacks.picker.grep_word() end,
          desc = "Grep cursor word/selection",
          mode = { "n", "x" }
        },

        -- Find/Search Other
        { "<LEADER>sr", function() Snacks.picker.resume() end,          desc = "Resume" },
        { "<LEADER>sh", function() Snacks.picker.help() end,            desc = "Help pages" },

        -- Git
        { "<LEADER>g",  function() Snacks.lazygit() end,                desc = "Lazygit" },

        -- LSP
        { "gd",         function() Snacks.picker.lsp_definitions() end, desc = "Goto definition" },
        { "gr",         function() Snacks.picker.lsp_references() end,  nowait = true,           desc = "Goto references" },
        { "<LEADER>ss", function() Snacks.picker.lsp_symbols() end,     desc = "LSP symbols" },
        { "<LEADER>uL", function() Snacks.picker.lsp_config() end,      desc = "LSP config" },

        -- Buffers
        { "<LEADER>bd", function() Snacks.bufdelete() end,              desc = "Delete" },
        { "<LEADER>bo", function() Snacks.bufdelete.other() end,        desc = "Delete others" },
        { "<LEADER>,",  function() Snacks.picker.buffers() end,         desc = "Search buffers" },
        { "<LEADER>sb", function() Snacks.picker.grep_buffers() end,    desc = "Open buffers" },

        -- Others
        { "<LEADER>e",  function() Snacks.explorer() end,               desc = "File explorer" },
        { "<LEADER>nh", function() Snacks.notifier.show_history() end,  desc = "History" },
        { "<LEADER>nd", function() Snacks.notifier.hide() end,          desc = "Dismiss all" },
        { "<LEADER>rf", function() Snacks.rename.rename_file() end,     desc = "Rename file" },
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
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
          auto_install = true,
          highlight = { enable = true },
          ensure_installed = {
            "angular",
            "bash",
            "css",
            "git_config",
            "git_rebase",
            "gitignore",
            "go",
            "html",
            "http",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "pug",
            "regex",
            "scss",
            "svelte",
            "tsx",
            "typescript",
            "vim",
            "yaml"
          },
        })
      end,
    },

    {
      'echasnovski/mini.nvim',
      version = false,
      event = "VeryLazy",
      config = function()
        --  Better arround & inside
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require("mini.ai").setup({
          n_lines = 200,
          silect = false,
        })

        require("mini.move").setup({
          mappings = {
            -- Move visual selection in Visual mode
            left = "{",
            right = "}",
            down = "J",
            up = "K",

            -- Move current line in Normal mode
            -- "" disables mapping
            line_left = "{",
            line_right = "}",
            line_down = "",
            line_up = "",
          }
        })

        require("mini.pairs").setup()
      end,
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
        routes = { {
          view = "notify",
          filter = { event = "msg_showmode" },
        } },
      },
    },

    {
      "folke/todo-comments.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
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
      "github/copilot.vim",
      event = "VeryLazy",
      config = function()
        map.set("i", "<C-p>", "<Plug>(copilot-suggest)", { desc = "Make Copilot suggestion" })
        map.set("i", "<C-j>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
        map.set("i", "<C-k>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })
        map.set("i", "<C-l>", "<Plug>(copilot-accept-line)", { desc = "Accept Copilot suggestion line" })
        map.set("i", "<C-h>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })
      end,
    },

    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
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
                map.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code actions", silent = true })
                map.set({ "v", "n" }, "<LEADER>=", vim.lsp.buf.format,
                  { desc = "Format visual selection", silent = true })
                map.set("n", "<LEADER>rn", vim.lsp.buf.rename, { desc = "Rename symbol", silent = true })
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
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = function()
        local noice = require("noice")
        return {
          options = {
            icons_enabled = true,
            theme = "auto",
            globalstatus = true,
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "diff", "diagnostics" },
            lualine_c = { "", { "filename", path = 1, shorting_target = 60 } },
            lualine_x = {
              {
                ---@diagnostic disable-next-line
                noice.api.status.command.get,
                ---@diagnostic disable-next-line
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

    { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },

    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "VeryLazy",
      opts = {},
    },

    {
      "saghen/blink.cmp",
      version = "1.*",
      event = "VeryLazy",
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

    { "tpope/vim-repeat",            event = "VeryLazy" },

    { "tpope/vim-surround",          event = "VeryLazy" },

    {
      "akinsho/bufferline.nvim",
      version = "*",
      event = "BufReadPre",
      opts = {
        options = {
          color_icons = true,
          sort_by = "relative_directory",
          truncate_names = false,
        },
      },
      keys = {
        { "L",     ":BufferLineCycleNext<CR>", desc = "Next buffer",           silent = true },
        { "H",     ":BufferLineCyclePrev<CR>", desc = "Previous buffer",       silent = true },
        { "<D-L>", ":BufferLineMoveNext<CR>",  desc = "Move buffer forwards",  silent = true },
        { "<D-H>", ":BufferLineMovePrev<CR>",  desc = "Move buffer backwards", silent = true },
      },
    },

    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      opts = {},
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
          "<LEADER>xx",
          "<CMD>Trouble diagnostics toggle filter.buf=0<CR>",
          desc = "Diagnostics list",
        },
        {
          "<LEADER>xt",
          "<CMD>Trouble todo toggle filter.buf=0<CR>",
          desc = "Todos list",
        },
      },
    },

    {
      'stevearc/oil.nvim',
      cmd = "Trouble",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
      keys = {
        { "-", "<CMD>Oil<CR>", desc = "Open Oil file explorer", silent = true },
      },
    },

    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim",        words = { "Snacks" } },
        },
      },
    },
  },

  checker = { enabled = true },
})
