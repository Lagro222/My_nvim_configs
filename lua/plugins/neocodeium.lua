return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require "neocodeium"

      neocodeium.setup()

      vim.keymap.set("i", "<A-f>", neocodeium.accept)
      vim.keymap.set("i", "<A-n>", neocodeium.cycle_or_complete)
      vim.keymap.set("i", "<A-p>", function()
        neocodeium.cycle_or_complete(-1)
      end)
    end,
  },
}
