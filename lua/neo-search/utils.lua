local M = {}

-- Search for text in current buffer
function M.search_in_buffer(search_term, search_opts)
  local results = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  
  -- If buffer has no name, use a placeholder
  if filename == "" then
    filename = "[No Name]"
  else
    filename = vim.fn.fnamemodify(filename, ":t") -- Get just the filename
  end
  
  for lnum, line in ipairs(lines) do
    local search_pattern = search_term
    
    -- Handle search options
    if not search_opts.use_regex then
      search_pattern = M.escape_pattern(search_term)
    end
    
    if not search_opts.case_sensitive then
      search_pattern = "(?i)" .. search_pattern
    end
    
    -- Find all matches in the line
    local start_pos = 1
    while true do
      local match_start, match_end
      
      if search_opts.case_sensitive then
        match_start, match_end = line:find(search_pattern, start_pos, not search_opts.use_regex)
      else
        match_start, match_end = line:lower():find(search_pattern:lower(), start_pos, not search_opts.use_regex)
      end
      
      if not match_start then
        break
      end
      
      -- Check whole word option
      if search_opts.whole_word then
        local before_char = match_start > 1 and line:sub(match_start - 1, match_start - 1) or ""
        local after_char = match_end < #line and line:sub(match_end + 1, match_end + 1) or ""
        
        if before_char:match("%w") or after_char:match("%w") then
          start_pos = match_start + 1
          goto continue
        end
      end
      
      table.insert(results, {
        bufnr = bufnr,
        filename = filename,
        lnum = lnum,
        col = match_start,
        end_col = match_end,
        text = line,
        match_text = line:sub(match_start, match_end),
        display = string.format("Line %d: %s", lnum, line:gsub("^%s+", ""))
      })
      
      start_pos = match_start + 1
      ::continue::
    end
  end
  
  return results
end

-- Replace text in current buffer
function M.replace_in_buffer(bufnr, line_num, col_start, col_end, new_text)
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(bufnr, line_num - 1, line_num, false)[1]
  if not line then
    return false, "Invalid line number"
  end
  
  -- Create the new line with replacement
  local new_line = line:sub(1, col_start - 1) .. new_text .. line:sub(col_end + 1)
  
  -- Replace the line in the buffer
  vim.api.nvim_buf_set_lines(bufnr, line_num - 1, line_num, false, {new_line})
  
  return true, "Replacement successful"
end

-- Escape special pattern characters for literal matching
function M.escape_pattern(text)
  return text:gsub("([^%w])", "%%%1")
end

-- Show notification
function M.notify(message, level)
  level = level or vim.log.levels.INFO
  vim.notify(message, level, { title = "Find & Replace" })
end

return M
