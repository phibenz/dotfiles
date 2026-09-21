-- Configure review.nvim shortcuts, source line numbers, and safe preview refreshes.
return {
  "vuki656/review.nvim",
  ---Initialize review.nvim, source line numbers, preview guards, and shortcuts.
  config = function()
    require("review").setup({
      keymaps = { toggle = "<leader>rv" },
      quick_comments = {
        keymaps = {
          add = "<leader>rc",
          toggle_panel = "<leader>qc",
          send = "<leader>qs",
        },
      },
      ui = { diff_view_mode = "split" },
    })
    require("config.review-line-numbers").setup()

    -- Work around upstream refreshes treating commit previews as single-file diffs.
    local diff_view = require("review.ui.diff_view")
    local render = diff_view.render
    ---Refresh file views only; commit previews have no filename.
    diff_view.render = function()
      if not diff_view.current or not diff_view.current.file then
        return
      end
      return render()
    end

    ---Export review comments in the review UI, or regular-file comments elsewhere.
    local function export_comments()
      local review = require("review")
      local quick_state = require("review.quick_comments.state")
      if not review.is_open() and quick_state.count() > 0 then
        require("review.quick_comments").export()
        return
      end
      review.export()
    end

    vim.keymap.set("n", "<leader>re", export_comments, { desc = "Export review or quick comments" })
    ---Confirm quick-comment clearing, then use the normal review clearing flow.
    vim.keymap.set("n", "<leader>rq", function()
      local quick_state = require("review.quick_comments.state")
      if quick_state.count() == 0 then
        require("review").clear_comments()
        return
      end

      -- Quick comments have no public clear command; mirror their built-in cleanup.
      ---Clear quick-comment markers, state, and storage before clearing review comments.
      require("review.ui.util").confirm("Clear all quick comments?", function()
        local signs = require("review.quick_comments.signs")
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) then
            signs.clear(bufnr)
          end
        end
        quick_state.clear()
        require("review.quick_comments.persistence").save()
        require("review.quick_comments").close_panel()
        vim.notify("Cleared quick comments", vim.log.levels.INFO)
        require("review").clear_comments()
      end)
    end, { desc = "Clear review and quick comments" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("ReviewKeymaps", { clear = true }),
      pattern = "review-tree",
      ---Defer remapping until review.nvim finishes registering its panel shortcuts.
      callback = function(event)
        ---Move the staging callback to s and update the panel's help entries.
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(event.buf) then
            return
          end
          for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(event.buf, "n")) do
            if mapping.lhs == " " then
              vim.keymap.set("n", "s", mapping.callback, {
                buffer = event.buf,
                nowait = true,
                desc = mapping.desc,
              })
              vim.keymap.del("n", "<Space>", { buffer = event.buf })
              for _, entry in ipairs(require("review.ui.file_tree").get_registered_keymaps()) do
                if entry.lhs == "<Space>" then
                  entry.lhs = "s"
                end
              end
              break
            end
          end
        end)
      end,
    })
  end,
}
