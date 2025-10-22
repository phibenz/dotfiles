return {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      window = {
        mappings = {
          ["<C-b>"] = "close_window",  -- Toggle from inside neo-tree
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_gitignored = false,
          hide_dotfiles = false,
          hide_by_name = {
            ".git",
            ".github",
            ".gitignore",
            ".DS_Store",
            "__pycache__",
            "package-lock.json",
            ".changeset",
            ".prettierrc.json",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      enable_git_status = true,
      enable_diagnostics = true,
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
      -- Focus neo-tree (switch to sidebar without toggling)
      vim.keymap.set('n', '<C-n>', ':Neotree filesystem focus left<CR>', {})

      -- Toggle neo-tree (show/hide)
      vim.keymap.set('n', '<C-b>', ':Neotree filesystem toggle left<CR>', {})

      -- Auto-refresh neo-tree on git events
      vim.api.nvim_create_autocmd("User", {
        pattern = "FugitiveChanged",  -- Triggers on fugitive git commands
        callback = function()
          local events = require("neo-tree.events")
          events.fire_event(events.GIT_EVENT)
        end,
      })

      -- Also refresh when switching buffers or writing files
      vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter"}, {
        callback = function()
          local events = require("neo-tree.events")
          events.fire_event(events.GIT_EVENT)
        end,
      })
    end
}
