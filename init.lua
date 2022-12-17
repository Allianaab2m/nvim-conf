local util = require('util')
local assign = util.assign

local jetpackfile = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if vim.fn.filereadable(jetpackfile) == 0 then
  vim.fn.system(string.format('curl -fsSLo %s --create-dirs %s', jetpackfile, jetpackurl))
end

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
  relativenumber = true,
  expandtab = true,
  tabstop = 2,
  shiftwidth = 2,
  scrolloff = 2,
  termguicolors = true,
  completeopt = 'menu,menuone,noselect',
}

require('jetpack-init') {
  { 'tani/vim-jetpack', opt = 1 },

  -- Startup time
  { 'dstein64/vim-startuptime', cmd = 'StartupTime', opt = 1 },

  -- Notification
  { 'rcarriga/nvim-notify',
    config = function()
      require('notify').setup {}
    end,
  },

  -- Scrollbar
  { 'petertriho/nvim-scrollbar',
    event = {
      'BufRead',
      'BufNewFile',
      'BufWinEnter',
      'CmdwinLeave',
      'TabEnter',
      'TermEnter',
      'TextChanged',
      'VimResized',
      'WinEnter',
      'WinScrolled',
    },
    config = function()
      require('scrollbar').setup {}
    end,
  },

  -- Smooth scroll
  { 'psliwka/vim-smoothie',
    event = {
      'BufRead',
      'BufNewFile'
    },
    setup = function()
      local g = require('util').assign(vim.g)

      g {
        smoothie_experimental_mapping = false,
        smoothie_update_interval = 16,
        smoothie_speed_constant_factor = 16,
        smoothie_speed_exponentiiationi_factor = 16,
      }
    end
  },

  -- Icon
  { 'nvim-tree/nvim-web-devicons' },

  -- Statusbar
  { 'nvim-lualine/lualine.nvim',
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
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
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
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
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

  -- Appearance
  { 'EdenEast/nightfox.nvim',
    config = 'vim.cmd [[colorscheme duskfox]]' },

  -- Fugitive
  { 'tpope/vim-fugitive' },

  -- Tab bar
  { 'romgrk/barbar.nvim',
    event = {
      'BufRead',
      'BufNewFile'
    },
    config = function()
      require('bufferline').setup {
        icons = true
      }
    end
  },

  -- File explorer
  { 'lambdalisue/fern.vim',
    event = {
      'BufRead',
      'BufNewFile'
    }
  }
}

-- Handle vim notifications
vim.notify = require('notify')

-- New tab
vim.keymap.set('', '<A-t>', ':enew<CR>', { noremap = true, silent = true })

-- Switch tab
vim.keymap.set('', '<A-,>', ':BufferPrevious<CR>', { noremap = true, silent = true })
vim.keymap.set('', '<A-.>', ':BufferNext<CR>', { noremap = true, silent = true })

-- Close tab
vim.keymap.set('', '<A-w>', ':BufferClose<CR>', { noremap = true, silent = true })

-- Kill tab
vim.keymap.set('', '<A-q>', ':BufferClose!<CR>', { noremap = true, silent = true })

-- Toggle explorer pane
vim.keymap.set('', '<A-S-f>', ':Fern . -drawer -toggle <CR>', { noremap = true, silent = true })
