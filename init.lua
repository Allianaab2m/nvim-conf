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
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
      require('mason').setup {}
      require('mason-lspconfig').setup {}
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
        }, {
          { name = 'buffer' },
        })
      }
    end
  },
  -- }}}

  -- {{{ CMP

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
