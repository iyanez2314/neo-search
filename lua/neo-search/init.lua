-- Import Modules Needed
local config = require("neo-search.config")
local telescope = require("neo-search.telescope")

local M = {}

-- Plugin setup function
function M.setup(opts)
	-- Merge user options with defaults
	config.setup(opts or {})

	-- Register telescope extension
	telescope_extension.setup()
end

-- Main find and replace function
function M.find_and_replace()
	telescope_extension.find_and_replace()
end

-- Debug version
function M.find_and_replace_debug()
	telescope_extension.find_and_replace_debug()
end

-- Export the module
return M
