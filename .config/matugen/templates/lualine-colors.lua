local M = {}

-- Define your custom lualine theme
M.matugen = {
  normal = {
    a = { fg = "{{ colors.surface.default.hex }}", bg = "{{ colors.primary.default.hex }}", gui = "bold" },
    b = { fg = "{{ colors.on_surface.default.hex }}", bg = "{{ colors.inverse_primary.default.hex }}" },
    c = { fg = "{{ colors.on_surface.default.hex }}", bg = "{{ colors.surface_bright.default.hex }}" },
  },
  insert = {
    a = { fg = "{{ colors.on_surface.default.hex }}", bg = "{{ colors.error_container.default.hex }}", gui = "bold" },
    b = { fg = "{{ colors.surface.default.hex }}", bg = "{{ colors.tertiary.default.hex }}" },
    c = { fg = "{{ colors.on_surface.default.hex }}", bg = "{{ colors.surface_bright.default.hex }}" },
  },
  visual = {
    a = { fg = "{{ colors.surface.default.hex }}", bg = "{{ colors.secondary.default.hex }}", gui = "bold" },
    b = { fg = "{{ colors.surface.default.hex }}", bg = "{{ colors.tertiary.default.hex }}" },
    c = { fg = "{{ colors.on_surface.default.hex }}", bg = "{{ colors.surface_bright.default.hex }}" },
  },
  replace = {
    a = { fg = "{{ colors.surface.default.hex }}", bg = "{{ colors.error.default.hex }}", gui = "bold" },
    b = { fg = "{{ colors.surface.default.hex }}", bg = "{{ colors.tertiary.default.hex }}" },
    c = { fg = "{{ colors.on_surface.default.hex }}", bg = "{{ colors.surface_bright.default.hex }}" },
  },
  inactive = {
    a = { fg = "{{ colors.outline.default.hex }}", bg = "{{ colors.on_tertiary_fixed.default.hex }}", gui = "bold" },
    b = { fg = "{{ colors.outline.default.hex }}", bg = "{{ colors.on_tertiary_fixed.default.hex }}" },
    c = { fg = "{{ colors.outline.default.hex }}", bg = "{{ colors.on_tertiary_fixed.default.hex }}" },
  },
}

return M
