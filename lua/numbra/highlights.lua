local colors = require("numbra.colors")
local config = require("numbra.config")

local M = {}

local original_colors = {}
local groups = { "LineNr", "CursorLineNr" }

local function get_hl(group)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	if not ok or not hl then
		return nil
	end
	return hl
end

local function get_fg(group)
	local hl = get_hl(group)
	if not hl then
		return nil
	end
	return hl.fg
end

local function cache_original()
	for _, group in ipairs(groups) do
		if not original_colors[group] then
			local fg = get_fg(group)
			if fg then
				original_colors[group] = string.format("#%06x", fg)
			end
		end
	end
end

local function apply_to_group(group, factor)
	local original = original_colors[group]
	if not original then
		return
	end

	local new_color = colors.adjust_brightness(original, factor)
	if new_color then
		vim.api.nvim_set_hl(0, group, { fg = new_color })
	end
end

function M.apply_to_window(winid, factor)
	vim.api.nvim_win_call(winid, function()
		for _, group in ipairs(groups) do
			apply_to_group(group, factor)
		end
	end)
end

function M.clear_cache()
	original_colors = {}
end

function M.restore_all()
	for _, group in ipairs(groups) do
		local original = original_colors[group]
		if original then
			vim.api.nvim_set_hl(0, group, { fg = original })
		end
	end
end

function M.refresh()
	cache_original()
end

return M
