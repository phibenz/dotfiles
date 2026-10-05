return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    --- Apply Dracula colors while keeping the terminal background visible.
    config = function()
      require("dracula").setup({
        transparent_bg = true,
        --- Keep floating windows and Telescope on the terminal background.
        overrides = function(colors)
          return {
            NormalFloat = { fg = colors.fg },
            TelescopeNormal = { fg = colors.fg },
          }
        end,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },
}
