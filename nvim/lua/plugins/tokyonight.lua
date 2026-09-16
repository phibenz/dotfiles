-- Use TokyoNight's Moon colors with the terminal's transparent background.
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- Let the terminal control the background before applying the Moon palette.
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
}
