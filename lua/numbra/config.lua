local M = {}

local defaults = {
	factor = 1.0,
	step = 0.05,
	min_factor = 0.1,
	max_factor = 3.0,
}

M.config = {}

function M.setup(opts)
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", defaults, opts)
	M.validate()
	return M.config
end

function M.validate()
	if M.config.step <= 0 or M.config.step > 1 then
		error("numbra: step must be between 0 and 1")
	end
	if M.config.min_factor < 0 or M.config.min_factor >= M.config.max_factor then
		error("numbra: min_factor must be between 0 and max_factor")
	end
	if M.config.max_factor <= M.config.min_factor then
		error("numbra: max_factor must be greater than min_factor")
	end
end

function M.get()
	return M.config
end

return M
