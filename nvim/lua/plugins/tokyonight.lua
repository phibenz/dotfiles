-- Load TokyoNight's Moon palette.
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- Apply the theme before other plugins load.
    config = function()
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
}
