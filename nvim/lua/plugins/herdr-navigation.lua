-- Navigate Neovim splits and cross into adjacent Herdr panes at their edges.
return {
  "paulbkim-dev/vim-herdr-navigation",
  lazy = false,
  -- Enable navigation only when Neovim runs inside a Herdr pane.
  cond = function()
    return vim.env.HERDR_PANE_ID ~= nil and vim.env.HERDR_PANE_ID ~= ""
  end,
  -- Load the upstream editor integration and its Ctrl+h/j/k/l mappings.
  config = function(plugin)
    dofile(plugin.dir .. "/editor/nvim.lua")
  end,
}
