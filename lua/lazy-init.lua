function try_require(target)
  local status, module = pcall(require, target)
  return module, status
end

local lazy, installed = try_require('lazy')

if not installed then
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

lazy = require('lazy')

return function(options)
  require('lazy').setup(options)

  if installed then return end
end
