local colors = require("numbra.colors")

local M = {}

local HIGHLIGHT_GROUPS = { "LineNr", "CursorLineNr", "LineNrAbove", "LineNrBelow" }
local original_colors = {}
local current_factor = 1.0

local function get_hl(group)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	return ok and hl or nil
end

local function get_available_groups()
	local available = {}
	for _, group in ipairs(HIGHLIGHT_GROUPS) do
		local hl = get_hl(group)
		if hl and hl.fg then
			table.insert(available, group)
		end
	end
	return #available > 0 and available or { "LineNr", "CursorLineNr" }
end

function M.cache_original()
	for _, group in ipairs(get_available_groups()) do
		if not original_colors[group] then
			local hl = get_hl(group)
			if hl and hl.fg then
				original_colors[group] = string.format("#%06x", hl.fg)
			end
		end
	end
end

function M.clear_cache()
	original_colors = {}
end

function M.apply(factor)
	current_factor = factor
	for _, group in ipairs(get_available_groups()) do
		local original = original_colors[group]
		if original then
			local new_color = colors.adjust_brightness(original, factor)
			if new_color then
				vim.api.nvim_set_hl(0, group, { fg = new_color })
			end
		end
	end
end

function M.set_factor(factor)
	M.apply(factor)
end

function M.get_current_factor()
	return current_factor
end

function M.restore_original()
	for _, group in ipairs(get_available_groups()) do
		local original = original_colors[group]
		if original then
			vim.api.nvim_set_hl(0, group, { fg = original })
		end
	end
end

function M.debug()
	return {
		factor = current_factor,
		original = original_colors,
		current = (function()
			local current = {}
			for _, group in ipairs(get_available_groups()) do
				local hl = get_hl(group)
				current[group] = hl and hl.fg and string.format("#%06x", hl.fg) or nil
			end
			return current
		end)(),
	}
end

return M
