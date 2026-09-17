-- Display source line numbers and split-diff gap separators in review.nvim.
local M = {}

---Mark omitted source lines with aligned virtual rows in both split panes.
local function add_separators(split, namespace)
  if not split then
    return
  end

  local previous_old, previous_new
  for row, old in ipairs(split.old_lines) do
    local new = split.new_lines[row]
    local old_line = old.source_line
    local new_line = new and new.source_line
    if (old_line and previous_old and old_line > previous_old + 1)
      or (new_line and previous_new and new_line > previous_new + 1) then
      for _, bufnr in ipairs({ split.old_bufnr, split.new_bufnr }) do
        vim.api.nvim_buf_set_extmark(bufnr, namespace, row - 1, 0, {
          virt_lines = { { { "⋯", "Comment" } } },
          virt_lines_above = true,
        })
      end
      -- The other pane can start this block with padding before its first source row.
      previous_old, previous_new = nil, nil
    end
    previous_old = old_line or previous_old
    previous_new = new_line or previous_new
  end
end

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

---Refresh source-number columns and split separators when review.nvim renders a view.
function M.setup()
  local view = require("review.ui.diff_view")
  local layout = require("review.ui.layout")
  local namespace = vim.api.nvim_create_namespace("ReviewGapSeparators")
  for _, name in ipairs({ "create", "create_commit_preview", "render" }) do
    local create = view[name]
    ---Preserve the renderer's result and refresh its columns and gap separators.
    view[name] = function(...)
      local result = create(...)
      for _, get_component in ipairs({ layout.get_diff_view, layout.get_diff_view_old, layout.get_diff_view_new }) do
        local component = get_component()
        if component and vim.api.nvim_win_is_valid(component.winid) then
          vim.api.nvim_buf_clear_namespace(component.bufnr, namespace, 0, -1)
          vim.api.nvim_set_option_value(
            "statuscolumn",
            "%s%=%{v:lua.require'config.review-line-numbers'.line()} ",
            { win = component.winid }
          )
        end
      end
      add_separators(view.split_state, namespace)
      return result
    end
  end
end

return M
