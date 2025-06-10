local M = {}
local cache_file = vim.fn.stdpath("cache") .. "/eskopi/clipboard.txt"

-- Write visual selection to the cache file
function M.copy()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Trim the first and last lines based on columns
  lines[1] = string.sub(lines[1], start_pos[3])
  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

  local file = io.open(cache_file, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
    print("Copied to shared clipboard")
  else
    print("Failed to open cache file")
  end
end

-- Paste content from the cache file at cursor position
function M.paste()
  local file = io.open(cache_file, "r")
  if not file then
    print("Nothing in clipboard")
    return
  end

  local content = file:read("*a")
  file:close()

  local lines = vim.split(content, "\n", { plain = true })
  vim.api.nvim_put(lines, "l", true, true)
end

return M

