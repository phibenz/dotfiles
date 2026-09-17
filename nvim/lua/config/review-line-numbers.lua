-- Display source line numbers in review.nvim's scratch diff buffers.
local M = {}

---Return the source line for the row being drawn, or blank for non-source rows.
function M.line()
  if vim.v.virtnum ~= 0 then
    return ""
  end

  local view = require("review.ui.diff_view")
  local bufnr = vim.api.nvim_get_current_buf()
  local split = view.split_state
  local lines
  if split and bufnr == split.old_bufnr then
    lines = split.old_lines
  elseif split and bufnr == split.new_bufnr then
    lines = split.new_lines
  elseif view.current and bufnr == view.current.bufnr then
    lines = view.current.render_lines
  end

  if not lines then
    return ""
  end
  local line = require("review.core.diff").get_source_line(vim.v.lnum, lines)
  return line or ""
end

---Install the source-number column when review.nvim creates a diff or commit preview.
function M.setup()
  local view = require("review.ui.diff_view")
  local layout = require("review.ui.layout")
  for _, name in ipairs({ "create", "create_commit_preview" }) do
    local create = view[name]
    ---Preserve the renderer's result and configure its active diff windows.
    view[name] = function(...)
      local result = create(...)
      for _, get_component in ipairs({ layout.get_diff_view, layout.get_diff_view_old, layout.get_diff_view_new }) do
        local component = get_component()
        if component and vim.api.nvim_win_is_valid(component.winid) then
          vim.api.nvim_set_option_value(
            "statuscolumn",
            "%s%=%{v:lua.require'config.review-line-numbers'.line()} ",
            { win = component.winid }
          )
        end
      end
      return result
    end
  end
end

return M
