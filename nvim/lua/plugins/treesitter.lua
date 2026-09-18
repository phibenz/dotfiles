-- Configure Treesitter parsers, highlighting, and indentation for Neovim 0.11.
return {
    "nvim-treesitter/nvim-treesitter",
    -- The main branch requires Neovim 0.12 and uses a different setup API.
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    ---Install missing parsers and enable highlighting and indentation.
    config = function()
        local languages = {
            "c",
            "bash",
            "lua",
            "python",
            "vim",
            "vimdoc",
            "javascript",
            "svelte",
            "html",
            "css",
            "json",
            "yaml",
            "toml",
            "rust",
        }

        require("nvim-treesitter.configs").setup({
            ensure_installed = languages,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
