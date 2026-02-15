local M = {}

local function hex_to_rgb(hex)
	if not hex or hex == "NONE" or hex == "" then
		return nil
	end
	hex = hex:gsub("#", "")
	if #hex ~= 6 then
		return nil
	end
	return {
		r = tonumber(hex:sub(1, 2), 16),
		g = tonumber(hex:sub(3, 4), 16),
		b = tonumber(hex:sub(5, 6), 16),
	}
end

local function rgb_to_hex(r, g, b)
	return string.format("#%02x%02x%02x", r, g, b)
end

local function rgb_to_hsl(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local h, s, l = 0, 0, (max + min) / 2

	if max ~= min then
		local d = max - min
		s = l > 0.5 and d / (2 - max - min) or d / (max + min)
		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		else
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	return h, s, l
end

local function hsl_to_rgb(h, s, l)
	local r, g, b

	if s == 0 then
		r, g, b = l, l, l
	else
		local function hue_to_rgb(p, q, t)
			if t < 0 then
				t = t + 1
			end
			if t > 1 then
				t = t - 1
			end
			if t < 1 / 6 then
				return p + (q - p) * 6 * t
			end
			if t < 1 / 2 then
				return q
			end
			if t < 2 / 3 then
				return p + (q - p) * (2 / 3 - t) * 6
			end
			return p
		end

		local q = l < 0.5 and l * (1 + s) or l + s - l * s
		local p = 2 * l - q
		r = hue_to_rgb(p, q, h + 1 / 3)
		g = hue_to_rgb(p, q, h)
		b = hue_to_rgb(p, q, h - 1 / 3)
	end

	return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

function M.adjust_brightness(hex, factor)
	if not hex or hex == "NONE" or hex == "" then
		return nil
	end

	local rgb = hex_to_rgb(hex)
	if not rgb then
		return nil
	end

	local h, s, l = rgb_to_hsl(rgb.r, rgb.g, rgb.b)
	l = math.min(1, math.max(0, l * factor))
	local r, g, b = hsl_to_rgb(h, s, l)

	return rgb_to_hex(r, g, b)
end

return M
