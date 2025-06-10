local M = {}
local base_dir = vim.fn.stdpath("cache") .. "/eskopi"
local cache_file = base_dir .. "/clipboard.txt"

local function ensure_dir()
  if vim.fn.isdirectory(base_dir) == 0 then
    vim.fn.mkdir(base_dir, "p")
  end
end

-- Copy range based on marks and selection type
function M.copy_range(type)
  ensure_dir()

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    print("eskopi: nothing selected")
    return
  end

  if type == "v" then -- characterwise
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  elseif type == "V" then -- linewise
    -- keep full lines as-is
  elseif type == "\22" then -- blockwise visual (ctrl-v)
    local block = {}
    for i = 1, #lines do
      block[i] = string.sub(lines[i], start_pos[3], end_pos[3])
    end
    lines = block
  else
    print("eskopi: unknown selection type: " .. vim.inspect(type))
    return
  end

  local file = io.open(cache_file, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
    print("eskopi: copied!")
  else
    print("eskopi: failed to open clipboard file")
  end
end

-- Operator function
function M.operator_copy(type)
  M.copy_range(type)
end

-- Start operator-pending mode
function M.copy_operator()
  vim.o.operatorfunc = "v:lua.require'eskopi'.operator_copy"
  vim.api.nvim_feedkeys("g@", "n", false)
end

-- For visual or block selection
function M.copy_visual()
  local mode = vim.fn.visualmode()
  vim.cmd([[normal! `<]])
  vim.cmd([[normal! `>]])
  M.copy_range(mode)
end

-- Paste from cache
function M.paste()
  local file = io.open(cache_file, "r")
  if not file then
    print("eskopi: clipboard is empty")
    return
  end
  local content = file:read("*a")
  file:close()
  local lines = vim.split(content, "\n", { plain = true })
  vim.api.nvim_put(lines, "l", true, true)
end

return M

