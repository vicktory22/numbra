local config = require("numbra.config")
local highlights = require("numbra.highlights")

local M = {}

function M.setup(opts)
	if not vim.o.termguicolors then
		vim.notify("numbra: termguicolors must be enabled", vim.log.levels.WARN)
		return
	end

	config.setup(opts)
	highlights.cache_original()
	highlights.apply(config.get().factor)

	vim.api.nvim_create_user_command("NumbraIncrease", function()
		M.increase()
	end, {})

	vim.api.nvim_create_user_command("NumbraDecrease", function()
		M.decrease()
	end, {})

	vim.api.nvim_create_user_command("NumbraReset", function()
		M.reset()
	end, {})
end

function M.increase()
	local cfg = config.get()
	local current = highlights.get_current_factor()
	local new_factor = math.min(cfg.max_factor, current + cfg.step)
	highlights.set_factor(new_factor)
end

function M.decrease()
	local cfg = config.get()
	local current = highlights.get_current_factor()
	local new_factor = math.max(cfg.min_factor, current - cfg.step)
	highlights.set_factor(new_factor)
end

function M.reset()
	highlights.set_factor(1.0)
end

function M.get_factor()
	return highlights.get_current_factor()
end

function M.set_factor(factor)
	local cfg = config.get()
	if factor < cfg.min_factor or factor > cfg.max_factor then
		vim.notify("numbra: factor must be between " .. cfg.min_factor .. " and " .. cfg.max_factor, vim.log.levels.WARN)
		return
	end
	highlights.set_factor(factor)
end

return M
