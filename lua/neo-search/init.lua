-- Import Modules Needed
local config = require("neo-search.config")
local telescope = require("neo-search.telescope")

local M = {}

-- Plugin Setup Function
function M.setup(opts)
	-- Merge the user options with the default config
	config.setup(opts or {})

	telescope.setup()
end

-- Main find and replace funtion
function M.find_and_replace()
	telescope.find_and_replace()
end

-- Export the module
return M
