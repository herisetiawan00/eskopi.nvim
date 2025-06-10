local M = {}
local base_dir = vim.fn.stdpath("cache") .. "/eskopi"
local cache_file = base_dir .. "/clipboard.txt"

local function get_visual_selection()
	-- Save the current register content and selection type
	local old_reg = vim.fn.getreg('"')
	local old_regtype = vim.fn.getregtype('"')

	-- Yank the visual selection to the " register (default)
	vim.cmd('normal! ""y')

	-- Get the yanked text
	local selection = vim.fn.getreg('"')

	-- Restore the original register content and type
	vim.fn.setreg('"', old_reg, old_regtype)

	return selection
end

local function get_motion_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	if #lines == 0 then return '' end

	lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	lines[1] = string.sub(lines[1], start_pos[3])

	local selection = table.concat(lines, '\n')

	return selection
end

local function write(text)
	if vim.fn.isdirectory(base_dir) == 0 then
		vim.fn.mkdir(base_dir, "p")
	end

	local file = io.open(cache_file, "w")
	if file then
		file:write(text)
		file:close()
		print("eskopi: Copied to clipboard!")
	else
		print("eskopi: Failed to open clipboard")
	end
end

function M.copy_motion()
	local text = get_motion_selection()
	write(text)
end

function M.copy_operator()
	vim.o.operatorfunc = "v:lua.require'eskopi'.copy_motion"
	vim.api.nvim_feedkeys("g@", "n", false)
end

function M.copy_visual()
	local text = get_visual_selection()
	write(text)
end

function M.paste()
	local file = io.open(cache_file, "r")
	if not file then
		print("eskopi: Clipboard is empty")
		return
	end

	local content = file:read("*a")
	file:close()
	local lines = vim.split(content, "\n", { plain = true })
	vim.api.nvim_put(lines, "l", true, true)
end

return M
