local M = {}

local function hex_to_rgb(hex)
	if not hex or hex == "NONE" or hex == "" then
		return nil
	end
	hex = hex:gsub("#", "")
	if #hex ~= 6 then
		return nil
	end
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	if not r or not g or not b then
		return nil
	end
	return { r = r, g = g, b = b }
end

local function rgb_to_hex(r, g, b)
	return string.format("#%02x%02x%02x", r, g, b)
end

local function clamp(val, min, max)
	return math.min(max, math.max(min, val))
end

function M.adjust_brightness(hex, factor)
	local rgb = hex_to_rgb(hex)
	if not rgb then
		return nil
	end

	local r, g, b = rgb.r, rgb.g, rgb.b

	if factor >= 1 then
		local t = clamp((factor - 1) / 2, 0, 1)
		r = math.floor(r + (255 - r) * t)
		g = math.floor(g + (255 - g) * t)
		b = math.floor(b + (255 - b) * t)
	else
		r = math.floor(r * factor)
		g = math.floor(g * factor)
		b = math.floor(b * factor)
	end

	return rgb_to_hex(clamp(r, 0, 255), clamp(g, 0, 255), clamp(b, 0, 255))
end

return M
