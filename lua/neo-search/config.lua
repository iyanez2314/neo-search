local M = {}

-- Default configuration
local defaults = {
	-- telescope options
	telescope = {
		theme = "dropdown",
		layout_config = {
			width = 0.8,
			height = 0.6,
		},
	},
	-- search options
	search = {
		case_sensitive = false,
		whole_word = false,
		use_regex = false,
	},
}

-- Current config (this will be merged with user optiosn)
M.options = {}

-- Setup function to merge user options with defaults
function M.setup(user_opts)
	-- Deep merge user options with defaults
	local function deep_merge(target, source)
		for key, value in pairs(soruce) do
			if type(value) == "table" and type(target[key]) == "table" then
				deep_merge(target[key], value)
			else
				target[key] = value
			end
		end
		return target
	end

	-- Start with defaults
	M.options = vim.deepcopy(defaults)

	-- Merge the user options
	if user_opts then
		M.options = deep_merge(M.options, user_opts)
	end
end

-- Initialize the module with default options
M.setup()

return M
