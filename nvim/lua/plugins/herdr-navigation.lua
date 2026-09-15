-- Keep Herdr prefix navigation separate from review.nvim's Ctrl+h/l shortcuts.
return {
  "paulbkim-dev/vim-herdr-navigation",
  lazy = false,
  -- Enable navigation only when Neovim runs inside a Herdr pane.
  cond = function()
    return vim.env.HERDR_PANE_ID ~= nil and vim.env.HERDR_PANE_ID ~= ""
  end,
  -- Retain upstream mappings and use dedicated keys for Herdr prefix navigation.
  config = function(plugin)
    dofile(plugin.dir .. "/editor/nvim.lua")

    -- F6/F7 are sent by herdr/navigate.sh, not by review.nvim's own shortcuts.
    for key, target in pairs({ ["<F6>"] = { "<C-h>", "left" }, ["<F7>"] = { "<C-l>", "right" } }) do
      local navigate = vim.fn.maparg(target[1], "n", false, true).callback
      -- Focus adjacent Herdr panes from review windows; otherwise use upstream navigation.
      vim.keymap.set("n", key, function()
        local layout = package.loaded["review.ui.layout"]
        if layout and layout.is_layout_window(vim.api.nvim_get_current_win()) then
          local herdr = vim.env.HERDR_BIN_PATH
          if not herdr or herdr == "" then
            herdr = "herdr"
          end
          vim.fn.system({ herdr, "pane", "focus", "--direction", target[2], "--pane", vim.env.HERDR_PANE_ID })
        else
          navigate()
        end
      end, { silent = true, desc = "Navigate " .. target[2] .. " (Herdr prefix)" })
    end
  end,
}
