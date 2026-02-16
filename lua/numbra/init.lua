local config = require("numbra.config")
local highlights = require("numbra.highlights")

local M = {}

function M.setup(opts)
	if not vim.o.termguicolors then
		vim.notify("numbra: termguicolors must be enabled", vim.log.levels.WARN)
		return
	end

	config.setup(opts)

	local function init()
		highlights.clear_cache()
		highlights.cache_original()
		highlights.apply(config.get().factor)
	end

	init()

	local augroup = vim.api.nvim_create_augroup("Numbra", { clear = true })

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = augroup,
		callback = init,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		once = true,
		callback = function()
			vim.defer_fn(init, config.get().cache_delay)
		end,
	})

	vim.api.nvim_create_user_command("NumbraIncrease", function() M.increase() end, {})
	vim.api.nvim_create_user_command("NumbraDecrease", function() M.decrease() end, {})
	vim.api.nvim_create_user_command("NumbraReset", function() M.reset() end, {})
	vim.api.nvim_create_user_command("NumbraDebug", function()
		vim.notify(vim.inspect(highlights.debug()), vim.log.levels.INFO)
	end, {})
end

function M.increase()
	local cfg = config.get()
	local new_factor = math.min(cfg.max_factor, highlights.get_current_factor() + cfg.step)
	highlights.set_factor(new_factor)
end

function M.decrease()
	local cfg = config.get()
	local new_factor = math.max(cfg.min_factor, highlights.get_current_factor() - cfg.step)
	highlights.set_factor(new_factor)
end

function M.reset()
	highlights.set_factor(1.0)
end

function M.set_factor(factor)
	local cfg = config.get()
	if factor < cfg.min_factor or factor > cfg.max_factor then
		vim.notify(
			string.format("numbra: factor must be between %.1f and %.1f", cfg.min_factor, cfg.max_factor),
			vim.log.levels.WARN
		)
		return
	end
	highlights.set_factor(factor)
end

function M.get_factor()
	return highlights.get_current_factor()
end

return M
