-- Load the colorscheme plugin from the active Omarchy theme.
local theme_lua = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

if vim.fn.filereadable(theme_lua) == 0 then
  return {}
end

local ok, spec = pcall(dofile, theme_lua)
if not ok or type(spec) ~= "table" then
  return {}
end

local colorscheme = "aether"
for _, item in ipairs(spec) do
  if type(item) == "table" and item[1] == "LazyVim/LazyVim" and item.opts and item.opts.colorscheme then
    colorscheme = item.opts.colorscheme
  end
end

local plugins = {}
for _, item in ipairs(spec) do
  if type(item) == "table" and item[1] ~= "LazyVim/LazyVim" then
    item.lazy = false
    item.priority = item.priority or 1000
    local prev_config = item.config
    local opts = item.opts
    local scheme = colorscheme
    item.config = function(plugin, plugin_opts)
      if prev_config then
        prev_config(plugin, plugin_opts)
      elseif opts or plugin_opts then
        local mod = plugin.name
        if type(mod) == "string" then
          pcall(function()
            require(mod).setup(plugin_opts or opts)
          end)
        end
      end
      vim.schedule(function()
        pcall(vim.cmd.colorscheme, scheme)
      end)
    end
    table.insert(plugins, item)
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    pcall(vim.cmd.colorscheme, colorscheme)
  end,
})

return plugins
