local config = require("numbra.config")
local autocmds = require("numbra.autocmds")

local M = {}

function M.setup(opts)
	if not vim.o.termguicolors then
		vim.notify("numbra: termguicolors must be enabled", vim.log.levels.WARN)
		return
	end

	config.setup(opts)
	autocmds.enable()
end

M.enable = autocmds.enable
M.disable = autocmds.disable
M.toggle = autocmds.toggle
M.is_enabled = autocmds.is_enabled

return M
