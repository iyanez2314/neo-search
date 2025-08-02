-- Prevent loading twice
if vim.g.loaded_your_plugin_name then
	return
end
vim.g.loaded_your_plugin_name = 1

-- Create user commands
vim.api.nvim_create_user_command("FindAndReplace", function()
	require("neo-search").find_and_replace()
end, {
	desc = "Find and replace in current buffer",
})
