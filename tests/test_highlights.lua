package.path = package.path .. ";../lua/?.lua"
local lu = require("luaunit")

local highlights = require("numbra.highlights")

	local function setup_mocks()
	local mock_get_hl = {}
	local mock_set_hl = {}

	vim = {
		api = {
			nvim_get_hl = function(_, opts)
				local group = opts.name
				if opts.link == false then
					local visited = {}
					while mock_get_hl[group] and mock_get_hl[group].link do
						if visited[group] then
							return nil
						end
						visited[group] = true
						group = mock_get_hl[group].link
					end
				end
				if mock_get_hl[group] then
					return mock_get_hl[group]
				end
				return nil
			end,
			nvim_set_hl = function(_, group, hl)
				mock_set_hl[group] = hl
			end,
		},
	}

	highlights.clear_cache()

	return mock_get_hl, mock_set_hl
end

function test_get_fg_with_direct_color()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { fg = 0xffaa55 }
	mock_get_hl["CursorLineNr"] = { fg = 0xffaa55 }

	highlights.cache_original()
	highlights.apply(1.0)

	lu.assertNotNil(mock_set_hl["LineNr"].fg)
	lu.assertEquals(mock_set_hl["LineNr"].fg, "#ffaa55")
end

function test_get_fg_with_single_link()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { link = "LineNrDefault" }
	mock_get_hl["LineNrDefault"] = { fg = 0xffaa55 }
	mock_get_hl["CursorLineNr"] = { link = "LineNrDefault" }

	highlights.cache_original()
	highlights.apply(1.0)

	lu.assertNotNil(mock_set_hl["LineNr"].fg)
	lu.assertEquals(mock_set_hl["LineNr"].fg, "#ffaa55")
end

function test_get_fg_with_link_chain()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { link = "LineNrLinked" }
	mock_get_hl["LineNrLinked"] = { link = "LineNrDefault" }
	mock_get_hl["LineNrDefault"] = { fg = 0xffaa55 }
	mock_get_hl["CursorLineNr"] = { link = "LineNrLinked" }

	highlights.cache_original()
	highlights.apply(1.0)

	lu.assertNotNil(mock_set_hl["LineNr"].fg)
	lu.assertEquals(mock_set_hl["LineNr"].fg, "#ffaa55")
end

function test_get_fg_with_circular_link()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { link = "LineNrLinked" }
	mock_get_hl["LineNrLinked"] = { link = "LineNr" }
	mock_get_hl["CursorLineNr"] = { fg = 0xffffff }

	highlights.cache_original()
	highlights.apply(1.0)

	lu.assertNil(mock_set_hl["LineNr"])
end

function test_cache_original_both_groups()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { fg = 0x888888 }
	mock_get_hl["CursorLineNr"] = { fg = 0xffffff }

	highlights.cache_original()
	highlights.apply(1.0)

	lu.assertEquals(mock_set_hl["LineNr"].fg, "#888888")
	lu.assertEquals(mock_set_hl["CursorLineNr"].fg, "#ffffff")
end

function test_cache_original_with_linked_cursor_line()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { fg = 0x888888 }
	mock_get_hl["CursorLineNr"] = { link = "LineNr" }

	highlights.cache_original()
	highlights.apply(1.0)

	lu.assertEquals(mock_set_hl["LineNr"].fg, "#888888")
	lu.assertEquals(mock_set_hl["CursorLineNr"].fg, "#888888")
end

function test_apply_reset_factor()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { fg = 0x888888 }
	mock_get_hl["CursorLineNr"] = { fg = 0xffffff }

	highlights.cache_original()
	highlights.apply(1.0)

	lu.assertEquals(mock_set_hl["LineNr"].fg, "#888888")
	lu.assertEquals(mock_set_hl["CursorLineNr"].fg, "#ffffff")
end

function test_apply_increased_factor()
	local mock_get_hl, mock_set_hl = setup_mocks()
	mock_get_hl["LineNr"] = { fg = 0x888888 }
	mock_get_hl["CursorLineNr"] = { fg = 0x888888 }

	highlights.cache_original()
	highlights.apply(1.5)

	lu.assertNotNil(mock_set_hl["LineNr"].fg)
	lu.assertNotNil(mock_set_hl["CursorLineNr"].fg)

	lu.assertNotEquals(mock_set_hl["LineNr"].fg, "#888888")
	lu.assertEquals(mock_set_hl["LineNr"].fg, mock_set_hl["CursorLineNr"].fg)
end

function test_get_current_factor()
	local mock_get_hl, _ = setup_mocks()
	mock_get_hl["LineNr"] = { fg = 0x888888 }
	mock_get_hl["CursorLineNr"] = { fg = 0x888888 }

	highlights.apply(1.5)
	lu.assertEquals(highlights.get_current_factor(), 1.5)
end

function test_set_factor()
	local mock_get_hl, _ = setup_mocks()
	mock_get_hl["LineNr"] = { fg = 0x888888 }
	mock_get_hl["CursorLineNr"] = { fg = 0x888888 }

	highlights.set_factor(2.0)
	lu.assertEquals(highlights.get_current_factor(), 2.0)
end

os.exit(lu.LuaUnit.run())