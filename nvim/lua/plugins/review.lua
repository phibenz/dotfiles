return {
  "georgeguimaraes/review.nvim",
  version = "v1.9.1",
  dependencies = {
    "esmuellert/codediff.nvim",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Review" },
  keys = {
    { "<leader>r", "<cmd>Review<cr>", desc = "Review changes" },
    { "<leader>R", "<cmd>Review commits<cr>", desc = "Review commits" },
  },
  opts = {
    keymaps = {
      send_sidekick = false,
    },
    codediff = {
      readonly = true,
    },
  },
}
