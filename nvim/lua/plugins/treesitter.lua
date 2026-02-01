return {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
        ensure_installed = { "c", "bash", "lua", "python", "vim", "vimdoc", "javascript", "svelte", "html", "css", "json", "yaml", "toml" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
    },
    config = function(_, opts)
        require("nvim-treesitter.config").setup(opts)
    end
}
