return {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
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
      vim.keymap.set('n', '<C-n>', ':Neotree filesystem toggle left<CR>', {})
    end
}
