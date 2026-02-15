package.path = package.path .. ";../lua/?.lua"
local lu = require("luaunit")

local colors = require("numbra.colors")

function test_adjust_brightness_increase()
	local result = colors.adjust_brightness("#808080", 1.5)
	lu.assertNotNil(result)
	lu.assertNotEquals(result, "#808080")
end

function test_adjust_brightness_decrease()
	local result = colors.adjust_brightness("#808080", 0.5)
	lu.assertNotNil(result)
	lu.assertNotEquals(result, "#808080")
end

function test_adjust_brightness_no_change()
	local result = colors.adjust_brightness("#808080", 1.0)
	lu.assertEquals(result, "#808080")
end

function test_adjust_brightness_white()
	local result = colors.adjust_brightness("#ffffff", 1.5)
	lu.assertEquals(result, "#ffffff")
end

function test_adjust_brightness_black()
	local result = colors.adjust_brightness("#000000", 0.5)
	lu.assertEquals(result, "#000000")
end

function test_adjust_brightness_none()
	lu.assertNil(colors.adjust_brightness("NONE", 1.5))
	lu.assertNil(colors.adjust_brightness("", 1.5))
	lu.assertNil(colors.adjust_brightness(nil, 1.5))
end

function test_adjust_brightness_invalid_hex()
	lu.assertNil(colors.adjust_brightness("invalid", 1.5))
	lu.assertNil(colors.adjust_brightness("#gggggg", 1.5))
	lu.assertNil(colors.adjust_brightness("#gggg", 1.5))
end

os.exit(lu.LuaUnit.run())