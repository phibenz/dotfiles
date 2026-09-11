-- Install Treesitter parsers and enable highlighting and indentation for their filetypes.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    -- Install missing parsers and map parser names to Neovim filetypes.
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

        require("nvim-treesitter").install(languages)

        local filetypes = {}
        for _, language in ipairs(languages) do
            vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(language))
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
            pattern = filetypes,
            -- Preserve default indentation when a parser is not yet available.
            callback = function(args)
                if pcall(vim.treesitter.start, args.buf) then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end
}
