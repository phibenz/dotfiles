return {
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    keymap = { preset = 'super-tab' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'buffer' },
    },

    signature = { enabled = true },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      }
    }
  }
}
