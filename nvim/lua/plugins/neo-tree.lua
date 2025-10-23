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
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              filepath,
              modify(filepath, ':.'),  -- relative to CWD
              modify(filepath, ':~'),  -- relative to HOME
              filename,
              modify(filename, ':r'),  -- filename without extension
            }

            vim.api.nvim_echo({
              { 'Choose path format:\n', 'Normal' },
              { '1. Absolute path\n', 'Normal' },
              { '2. Relative to CWD\n', 'Normal' },
              { '3. Relative to HOME\n', 'Normal' },
              { '4. Filename\n', 'Normal' },
              { '5. Filename (no ext)', 'Normal' },
            }, false, {})

            local char = vim.fn.getchar()
            local number = tonumber(vim.fn.nr2char(char))

            vim.cmd('redraw')  -- Clear the prompt

            if number and number > 0 and number <= #results then
              vim.fn.setreg('+', results[number])
            end
          end,
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
