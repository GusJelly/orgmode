local tmp_dir = vim.env.TMPDIR or vim.env.TMP or vim.env.TEMP or '/tmp'
local nvim_root = tmp_dir .. '/nvim_orgmode'
local lazy_root = nvim_root .. '/lazy'
local lazypath = lazy_root .. '/lazy.nvim'

-- Install lazy.nvim if not already installed
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    branch = 'feat/no-nvim-ts',
    config = function()
      require('orgmode').setup()
    end
  },
}, {
  root = lazy_root,
  lockfile = nvim_root .. '/lazy.json',
  install = {
    missing = false,
  },
})

require('lazy').sync({
  wait = true,
  show = false,
})
