-- Prevent loading twice
if vim.g.loaded_your_plugin_name then
	return
end
vim.g.loaded_your_plugin_name = 1

-- Create user commands
vim.api.nvim_create_user_command("FindAndReplace", function()
	require("neo-search").find_and_replace() -- Live search version
end, {
	desc = "Find and replace in current buffer",
})

vim.api.nvim_create_user_command("FAR", function()
	require("neo-search").find_and_replace()
end, {
	desc = "Find and replace in current buffer (alias)",
})

vim.api.nvim_create_user_command("TestSearch", function()
	require("neo-search").test_search()
end, {
	desc = "Test search functionality to debug results",
})
