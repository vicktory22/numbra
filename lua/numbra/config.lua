local M = {}

local defaults = {
	darken_factor = 0.5,
	brighten_factor = 0,
}

M.config = {}

function M.setup(opts)
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", defaults, opts)
	M.validate()
	return M.config
end

function M.validate()
	if M.config.darken_factor < 0 or M.config.darken_factor > 1 then
		error("numbra: darken_factor must be between 0 and 1")
	end
	if M.config.brighten_factor < 0 or M.config.brighten_factor > 2 then
		error("numbra: brighten_factor must be between 0 and 2")
	end
end

function M.get()
	return M.config
end

return M
