-- Import Modules Needed
local config = require("neo-search.config")
local telescope = require("neo-search.telescope")

local M = {}

-- Plugin setup function
function M.setup(opts)
	-- Merge user options with defaults
	config.setup(opts or {})

	-- Register telescope extension
	telescope.setup()
end

-- Main find and replace function
function M.find_and_replace()
	telescope.find_and_replace()
end

-- Debug version
function M.find_and_replace_debug()
	telescope.find_and_replace_debug()
end

-- Test function to debug search results
function M.test_search()
	local config = require("neo-search.config")
	local utils = require("neo-search.utils")
	
	local search_term = vim.fn.input("Test search for: ")
	if search_term == "" then
		print("No search term provided")
		return
	end
	
	local results = utils.search_in_buffer(search_term, config.options.search)
	
	print("\n=== SEARCH RESULTS ===")
	print("Search term:", search_term)
	print("Total results:", #results)
	
	for i, result in ipairs(results) do
		print(string.format("%d. %s", i, result.display))
	end
	print("======================")
end

-- Export the module
return M
