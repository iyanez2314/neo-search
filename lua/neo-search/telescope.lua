local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local config = require("neo-search.config")
local utils = require("neo-search.utils")

local M = {}

-- Simple debug version of find and replace
function M.find_and_replace_debug()
	-- Check if buffer is modifiable
	local bufnr = vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_get_option(bufnr, "modifiable") then
		utils.notify("Buffer is not modifiable", vim.log.levels.WARN)
		return
	end

	-- Get search term from user (simple version)
	local search_term = vim.fn.input("Search for: ")
	if search_term == "" then
		print("No search term provided")
		return
	end

	print("Starting search for:", search_term)

	-- Search for matches in current buffer
	local results = utils.search_in_buffer(search_term, config.options.search)

	print("Search completed, results:", #results)

	if #results == 0 then
		utils.notify("No matches found for: " .. search_term, vim.log.levels.WARN)
		return
	end

	-- Create simple telescope picker
	pickers
		.new(config.options.telescope, {
			prompt_title = "Find & Replace: " .. search_term .. " (" .. #results .. " matches)",
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.display,
						ordinal = entry.display,
					}
				end,
			}),
			sorter = conf.generic_sorter(config.options.telescope),
			attach_mappings = function(prompt_bufnr, map)
				-- Just go to location for now
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						vim.api.nvim_win_set_cursor(0, { selection.value.lnum, selection.value.col - 1 })
					end
				end)
				return true
			end,
		})
		:find()
end

-- Highlight a match temporarily
function M.highlight_match(match_info)
	local ns_id = vim.api.nvim_create_namespace("find_replace_highlight")

	-- Clear any existing highlights
	vim.api.nvim_buf_clear_namespace(match_info.bufnr, ns_id, 0, -1)

	-- Add highlight
	vim.api.nvim_buf_add_highlight(
		match_info.bufnr,
		ns_id,
		"Search",
		match_info.lnum - 1,
		match_info.col - 1,
		match_info.end_col
	)

	-- Remove highlight after 2 seconds
	vim.defer_fn(function()
		vim.api.nvim_buf_clear_namespace(match_info.bufnr, ns_id, 0, -1)
	end, 2000)
end

-- Replace single match
function M.replace_single_match(prompt_bufnr, search_term)
	local selection = action_state.get_selected_entry()
	if not selection then
		return
	end

	actions.close(prompt_bufnr)

	-- Get replacement text
	local replace_text = vim.fn.input("Replace with: ")
	if replace_text == "" then
		return
	end

	-- Perform replacement
	local success, message = utils.replace_in_buffer(
		selection.value.bufnr,
		selection.value.lnum,
		selection.value.col,
		selection.value.end_col,
		replace_text
	)

	if success then
		utils.notify("Replaced 1 occurrence")
		-- Move cursor to the replacement
		vim.api.nvim_win_set_cursor(0, { selection.value.lnum, selection.value.col - 1 })
	else
		utils.notify(message, vim.log.levels.ERROR)
	end
end

-- Replace all matches
function M.replace_all_matches(prompt_bufnr, search_term, results)
	actions.close(prompt_bufnr)

	-- Get replacement text
	local replace_text = vim.fn.input("Replace ALL " .. #results .. " occurrences with: ")
	if replace_text == "" then
		return
	end

	-- Confirm action
	local confirm = vim.fn.input("Replace " .. #results .. " occurrences in current buffer? (y/N): ")
	if confirm:lower() ~= "y" then
		return
	end

	-- Sort results by line number and column in reverse order
	-- This prevents position shifts from affecting subsequent replacements
	table.sort(results, function(a, b)
		if a.lnum == b.lnum then
			return a.col > b.col
		end
		return a.lnum > b.lnum
	end)

	local success_count = 0
	local bufnr = results[1].bufnr

	-- Perform all replacements
	for _, result in ipairs(results) do
		local success, message = utils.replace_in_buffer(bufnr, result.lnum, result.col, result.end_col, replace_text)

		if success then
			success_count = success_count + 1
		else
			utils.notify("Failed replacement at line " .. result.lnum .. ": " .. message, vim.log.levels.ERROR)
		end
	end

	utils.notify("Replaced " .. success_count .. " of " .. #results .. " occurrences")

	-- Move cursor to first replacement location
	if success_count > 0 then
		local first_match = results[#results] -- Last in sorted array = first in buffer
		vim.api.nvim_win_set_cursor(0, { first_match.lnum, first_match.col - 1 })
	end
end

-- Setup function for telescope extension
function M.setup()
	-- Register as telescope extension
	telescope.register_extension({
		setup = function(ext_config)
			-- Extension setup if needed
		end,
		exports = {
			find_and_replace = M.find_and_replace,
		},
	})
end

return M
