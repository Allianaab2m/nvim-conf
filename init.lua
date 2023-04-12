vim.api.nvim_set_keymap("i", "jj", "<Esc>", {})
local util = require('util')
local assign = util.assign

assign(vim.g) {
  belloff = 'all',
  did_install_default_menus = 1,
  did_install_syntax_menu = 1,
  skip_loading_mswin = 1,
  loaded_2html_plugin = 1,
  loaded_gzip = 1,
  loaded_man = 1,
  loaded_netrwPlugin = 1,
  loaded_remote_plugins = 1,
  loaded_spellfile_plugin = 1,
  loaded_tarPlugin = 1,
  loaded_tutor_mode_plugin = 1,
  loaded_zipPlugin = 1,
}

assign(vim.opt) {
  cmdheight = 0,
  encoding = 'utf-8',
  fileencodings = 'iso-2022-jp,euc-jp,sjis,utf-8',
  fileformats = 'unix,dos,mac',
  list = true,
  listchars = 'tab:^  ,trail:-',
  mouse = '',
  number = true,
  expandtab = true,
  tabstop = 2,
  shiftwidth = 2,
  scrolloff = 2,
  termguicolors = true,
  completeopt = 'menu,menuone,noselect',
}

require('lazy-init') {
  --{{{ Appearance
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  },
  {
    'arzg/vim-colors-xcode',
    init = function()
      vim.cmd [[colorscheme xcodedark]]
    end
  },
  -- }}}

  -- {{{ Color picker
  {
    'ziontee113/color-picker.nvim',
    config = function()
      require("color-picker").setup()
    end
  },
  -- }}}

  -- {{{ File explorer
  { 'lambdalisue/fern.vim' },
  -- }}}

  -- {{{ Fugitive
  { 'tpope/vim-fugitive' },
  -- }}}

  -- {{{ Icon
  { 'nvim-tree/nvim-web-devicons' },
  -- }}}


  -- {{{ LSP
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      "folke/neodev.nvim", -- for nvim api completion
      "folke/lsp-colors.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("mason").setup()
      require("neodev").setup()

      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { text_hl = sign.name, numhl = sign.name, text = sign.text })
      end

      local function lsp_keymaps(bufnr)
        local opts = { noremap = true, silient = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap(bufnr, "n", "gl", "<cmd>lua vim.lsp.diagnostic.open_float()<CR>", opts)
        keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
        keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<CR>", opts)
        keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer = 0, float = false})<CR>", opts)
        keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer = 0, float = false})<CR>", opts)
        keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        keymap(bufnr, "n", "<leader>lq", "<cmd>TroubleToggle document_diagnostics<CR>", opts)
      end

      local lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local server_configs = {
        sumneko_lua = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace"
              }
            }
          }
        }
      }

      require("mason-lspconfig").setup_handlers({
        function(name)
          local config = server_configs[name] or {}
          config.capabilities = capabilities
          config.on_attach = function(client, bufnr)
            lsp_keymaps(bufnr)
          end

          lsp[name].setup(config)
        end
      })

    end
  },
  -- }}}

  -- {{{ CMP
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
    },
    config = function()
      local has_word_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      local cmp = require("cmp")
      local context = require("cmp.config.context")

      cmp.setup({
        enabled = function()
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
            border = "single"
          },
          documentation = cmp.config.window.bordered({ border = "single" })
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function (entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", max_width = 50})(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", {trimempty = true})
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "    (" .. strings[2] .. ")"

            return kind
          end
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_word_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {"i", "s"}),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true })
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer", max_item_count = 10 },
        }),
        experimental = {
          ghost_text = true
        }
      })

      --cmp.setting.cmdline(":", {
       -- mapping = cmp.mapping.preset.cmdline(),
        --sources = cmp.config.sources({
         -- { name = "path" },
          --{ name = "cmdline"},
       -- })
     -- })

      --cmp.setting.cmdline("/", {
       -- mapping = cmp.mapping.preset.cmdline(),
        --source = cmp.config.souces({
         -- { name = "buffer" }
        --})
     -- })

      end
},
  -- }}}

  -- {{{ Notification
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup {}
    end
  },
  -- }}}

  -- {{{ Scrollbar
  {
    'petertriho/nvim-scrollbar',
    event = {
      'BufRead',
      'BufNewFile'
    },
    config = function()
      require('scrollbar').setup {}
    end
  },
  -- }}}

  -- {{{ Smooth scroll
  {
    'psliwka/vim-smoothie',
    config = function()
      local g = require('util').assign(vim.g)

      g {
        smoothie_experimental_mapping = false,
        smoothie_update_interval = 16,
        smoothie_speed_constant_factor = 16,
        smoothie_speed_exponentiiationi_factor = 16,
      }
    end
  },
  -- }}}

  -- {{{ Statusbar
  {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    event = {
      'BufRead',
      'BufNewFile'
    },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },
  -- }}}

  -- {{{ Tab bar (barbar)
  {
    'romgrk/barbar.nvim',
    event = {
      'BufRead',
      'BufNewFile'
    },
    dependencies = 'nvim-tree/nvim-web-devicons'
  }
  -- }}}
}
---- Key bindings ----

-- {{{ Set leader key
local opts = { silent = true }
vim.keymap.set("", "<Space>", "<nop>", opts)
vim.g.mapleader = " "
-- }}}

-- {{{ Disable F1 (Help) key
vim.keymap.set('', '<F1>', '<NOP>')
-- }}}

-- {{{ Disable Delete key
vim.keymap.set('', '<Delete>', '<NOP>')
-- }}}

-- {{{ Disable Arrow key
vim.keymap.set('', '<F1>', '<NOP>')
-- }}}

---- Tab ----

-- {{{ New tab
vim.keymap.set('', '<A-t>', ':enew<CR>')
-- }}}

-- {{{ Switch tab
vim.keymap.set('', '<A-,>', ':BufferPrevious<CR>')
vim.keymap.set('', '<A-.>', ':BufferNext<CR>')
-- }}}

-- {{{ Swap tab
vim.keymap.set('', '<A-<>', ':BufferMovePrevious<CR>')
vim.keymap.set('', '<A->>', ':BufferMoveNext<CR>')
-- }}}

-- {{{ Close tab
vim.keymap.set('', '<A-w>', ':BufferClose<CR>')
-- }}}

-- {{{ Kill tab
vim.keymap.set('', '<A-q>', ':BufferClose!<CR>')
-- }}}

-- {{{ Toggle explorer pane
vim.keymap.set('', '<A-S-f>', ':Fern . -drawer -toggle <CR>')
-- }}}

-- vim:se fdm=marker:
