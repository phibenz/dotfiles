return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
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
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = languages,
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
}
