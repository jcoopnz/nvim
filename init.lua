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

-- behavioural
option.autoread = true
option.mouse = "a"
option.undofile = true
option.ignorecase = true
option.smartcase = true
option.splitright = true
option.confirm = true
option.smartindent = true
option.updatetime = 250
option.timeoutlen = 1000

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
option.scrolloff = 10

map.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left", silent = true })
map.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right", silent = true })
map.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus down", silent = true })
map.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus up", silent = true })
map.set("n", "<LEADER>w", ":w<CR>", { desc = "Write", silent = true })
map.set("n", "<ESC>", ":nohlsearch<CR>", { desc = "Clear search", silent = true })
map.set("n", "<LEADER>ul", ":Lazy<CR>", { desc = "Lazy", silent = true })
map.set("n", "<LEADER>um", ":Mason<CR>", { desc = "Mason", silent = true })
map.set("n", "n", "nzz", { desc = "Next", silent = true })
map.set("n", "N", "Nzz", { desc = "Previous", silent = true })
map.set("n", "<C-d>", "<C-d>zz", { desc = "Previous", silent = true })
map.set("n", "<C-u>", "<C-u>zz", { desc = "Previous", silent = true })
map.set("n", "<LEADER>|", ":vs<CR>", { desc = "Split", silent = true })
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
  { desc = "Substitute word" }
)

-- scheduled to improve load
vim.schedule(function()
  option.clipboard = "unnamedplus"
end)

-- Enable Treesitter highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
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
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        notify = { enabled = true },
        picker = {
          enabled = true,
          formatters = {
            file = {
              filename_first = true,
              truncate = "center"
            },
          },
          layout = {
            cycle = false,
            preset = function()
              return vim.o.columns >= 160 and "default" or "vertical"
            end,
          },
          win = {
            input = {
              keys = {
                ["<Down>"] = { "history_forward", mode = { "i", "n" } },
                ["<Up>"] = { "history_back", mode = { "i", "n" } },
              },
            },
          }
        },
        words = { enabled = true },
      },
      keys = {
        { "<LEADER><LEADER>", function() Snacks.picker.smart() end,   desc = "Smart find files" },
        { "<LEADER>/",        function() Snacks.picker.grep() end,    desc = "Search grep" },
        { "<LEADER>.",        function() Snacks.picker.recent() end,  desc = "Find recent files" },
        { "<LEADER>,",        function() Snacks.picker.buffers() end, desc = "Search buffers" },
        { "<LEADER>g",        function() Snacks.lazygit() end,        desc = "Lazygit" },
        { "<LEADER>e",        function() Snacks.explorer() end,       desc = "Explorer" },
        {
          "<LEADER>sr",
          function()
            Snacks.picker.resume({
              exclude = { "explorer", "lsp_definitions", "lsp_references", "gh_pr" }
            })
          end,
          desc = "Resume"
        },
        {
          "<LEADER>*",
          function() Snacks.picker.grep_word() end,
          desc = "Grep cursor word/selection",
          mode = { "n", "x" }
        },
        -- find
        { "<LEADER>sf", function() Snacks.picker.git_files() end,                       desc = "Git files" },
        { "<LEADER>sh", function() Snacks.picker.help() end,                            desc = "Help" },
        { "<LEADER>ss", function() Snacks.picker.lsp_symbols() end,                     desc = "Symbols" },
        { "<LEADER>sb", function() Snacks.picker.grep_buffers() end,                    desc = "Open buffers" },
        -- LSP
        { "gd",         function() Snacks.picker.lsp_definitions() end,                 desc = "Goto definition" },
        { "gr",         function() Snacks.picker.lsp_references() end,                  desc = "Goto references", nowait = true },
        { "<LEADER>uL", function() Snacks.picker.lsp_config() end,                      desc = "LSP config" },
        -- buffer
        { "<LEADER>bd", function() Snacks.bufdelete() end,                              desc = "Delete" },
        { "<LEADER>bo", function() Snacks.bufdelete.other() end,                        desc = "Delete others" },
        -- github
        { "<leader>pr", function() Snacks.picker.gh_pr({ author = 'iqfy-jordan' }) end, desc = "My PRs" },
        { "<leader>pR", function() Snacks.picker.gh_pr({ state = 'open' }) end,         desc = "All open PRs" },
        -- other
        { "<LEADER>nh", function() Snacks.notifier.show_history() end,                  desc = "History" },
        { "<LEADER>nd", function() Snacks.notifier.hide() end,                          desc = "Dismiss all" },
        { "<LEADER>rf", function() Snacks.rename.rename_file() end,                     desc = "Rename file" },
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
            -- Override print to use snacks for `:=` command
            if vim.fn.has("nvim-0.11") == 1 then
              ---@diagnostic disable-next-line
              vim._print = function(_, ...)
                dd(...)
              end
            else
              vim.print = _G.dd
            end
            -- toggles
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<LEADER>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<LEADER>uw")
            Snacks.toggle.diagnostics():map("<LEADER>ud")
            Snacks.toggle.inlay_hints():map("<LEADER>uh")
            Snacks.toggle.dim():map("<leader>uD")
          end,
        })
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").install({
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
        })
      end,
    },

    {
      "akinsho/bufferline.nvim",
      version = "*",
      event = "VeryLazy",
      opts = {
        options = {
          diagnostics = "nvim_lsp",
          persist_buffer_sort = true,
          sort_by = "insert_after_current",
          truncate_names = false,
          indicator = { style = 'underline' },
        },
      },
      keys = {
        { "L",          ":BufferLineCycleNext<CR>", desc = "Next buffer",         silent = true },
        { "H",          ":BufferLineCyclePrev<CR>", desc = "Previous buffer",     silent = true },
        { ">",          ":BufferLineMoveNext<CR>",  desc = "Move buffer forward", silent = true },
        { "<",          ":BufferLineMovePrev<CR>",  desc = "Move buffer back",    silent = true },
        { "<LEADER>bp", ":BufferLineTogglePin<CR>", desc = "Pin buffer",          silent = true },
      },
    },

    {
      'andymass/vim-matchup',
      event = "VeryLazy",
      opts = {
        treesitter = { stopline = 500 }
      }
    },

    {
      "echasnovski/mini.nvim",
      version = false,
      event = "VeryLazy",
      config = function()
        require("mini.ai").setup()
        require("mini.icons").setup()
        require("mini.move").setup({
          mappings = {
            -- visual
            left = "{",
            right = "}",
            down = "J",
            up = "K",
            -- line
            line_left = "{",
            line_right = "}",
            line_down = "",
            line_up = "",
          }
        })
        require("mini.pairs").setup()
        require("mini.surround").setup()
      end,
    },

    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
      opts = {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          lsp_doc_border = true,
        },
        routes = { {
          view = "notify",
          filter = { event = "msg_showmode" },
        } },
      },
    },

    {
      "folke/persistence.nvim",
      event = "VeryLazy",
      opts = {},
    },

    {
      "folke/sidekick.nvim",
      event = "VeryLazy",
      opts = {
        nes = {
          enabled = true,
          debounce = 100,
        },
        cli = {
          watch = true,
          mux = {
            enabled = false,
            backend = "tmux",
          },
        },
      },
      keys = {
        {
          "<Tab>",
          function()
            if not require("sidekick").nes_jump_or_apply() then
              return "<Tab>"
            end
          end,
          expr = true,
          desc = "Jump to or apply next edit suggestion",
        },
        { "<LEADER>aa", function() require("sidekick.cli").toggle({ name = "copilot" }) end, desc = "Toggle AI CLI" },
        {
          "<LEADER>af",
          function() require("sidekick.cli").send({ msg = "{file}" }) end,
          desc = "Send file to AI",
          mode = "n"
        },
        {
          "<LEADER>av",
          function() require("sidekick.cli").send({ msg = "{selection}" }) end,
          desc = "Send selection to AI",
          mode = "x"
        },
        {
          "<LEADER>ap",
          function() require("sidekick.cli").prompt() end,
          desc = "Select AI prompt",
          mode = { "n", "x" }
        },
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
            { "<LEADER>n", group = "Notification" },
            { "<LEADER>r", group = "Rename" },
            { "<LEADER>p", group = "GitHub PR" },
            { "<LEADER>s", group = "Search" },
            { "<LEADER>u", group = "User settings" },
            { "<LEADER>x", group = "Diagnostics" },
          },
        },
      },
    },

    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
      opts = {
        numhl = true,
        current_line_blame = true,
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        current_line_blame_opts = {
          virt_text_pos = "right_align",
          delay = 700,
        },
      },
      keys = {
        { "<LEADER>ub", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle blame",  silent = true },
        { "]h",         ":Gitsigns next_hunk<CR>",                 desc = "Next hunk",     silent = true },
        { "[h",         ":Gitsigns prev_hunk<CR>",                 desc = "Previous hunk", silent = true },
      }
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
                map.set({ "v", "n" }, "<LEADER>=", vim.lsp.buf.format, { desc = "Format", silent = true })
                map.set("n", "<LEADER>rn", vim.lsp.buf.rename, { desc = "Rename symbol", silent = true })
              end
            })
          end,
        },
      },
      opts = {
        ensure_installed = { "ast_grep", "lua_ls", "ts_ls", "svelte", "angularls", "copilot" },
      },
    },

    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPost", "BufWritePost", "BufNewFile" },
      config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
          javascript = { "eslint" },
          typescript = { "eslint" },
        }
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      end,
    },

    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = function()
        local noice = require("noice")
        return {
          options = {
            theme = 'tokyonight',
            globalstatus = true,
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
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
              "lsp_status"
            },
            lualine_z = { "location" },
          },
        }
      end,
    },

    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "VeryLazy",
      opts = {
        options = {
          multilines = {
            enabled = true,
            severity = {
              vim.diagnostic.severity.WARN,
              vim.diagnostic.severity.ERROR,
            },
          }
        }
      },
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
        fuzzy = { implementation = "prefer_rust" },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
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
        { "<LEADER>xx", ":Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostic list" },
        { "<LEADER>xt", ":Trouble todo toggle filter.buf=0<CR>",        desc = "Todo list" },
      },
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
      "ThePrimeagen/vim-be-good",
      cmd = "VimBeGood",
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
