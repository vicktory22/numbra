local highlights = require("numbra.highlights")
local config = require("numbra.config")

local M = {}

local augroup_name = "NumbraHighlight"
local enabled = false

local function apply_highlights()
	local current_win = vim.api.nvim_get_current_win()
	local wins = vim.api.nvim_list_wins()
	local cfg = config.get()

	highlights.refresh()

	for _, winid in ipairs(wins) do
		if winid == current_win then
			if cfg.brighten_factor > 0 then
				highlights.apply_to_window(winid, cfg.brighten_factor)
			end
		else
			if cfg.darken_factor > 0 then
				highlights.apply_to_window(winid, cfg.darken_factor)
			end
		end
	end
end

local function setup_autocmds()
	local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })

	vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
		group = group,
		callback = apply_highlights,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			highlights.clear_cache()
			apply_highlights()
		end,
	})
end

function M.enable()
	if enabled then
		return
	end
	enabled = true
	setup_autocmds()
	apply_highlights()
end

function M.disable()
	if not enabled then
		return
	end
	enabled = false
	vim.api.nvim_del_augroup_by_name(augroup_name)
	highlights.restore_all()
end

function M.toggle()
	if enabled then
		M.disable()
	else
		M.enable()
	end
end

function M.is_enabled()
	return enabled
end

return M
