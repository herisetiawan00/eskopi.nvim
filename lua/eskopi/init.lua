local M = {}
local base_dir = vim.fn.stdpath("cache") .. "/eskopi"
local cache_file = base_dir .. "/clipboard.txt"

local function get_visual_selection()
	local old_reg = vim.fn.getreg('"')
	local old_regtype = vim.fn.getregtype('"')

	vim.cmd('normal! ""y')

	local selection = vim.fn.getreg('"')

	vim.fn.setreg('"', old_reg, old_regtype)

	return selection
end

local function get_motion_selection()
	local buf = 0
	local start_pos = vim.api.nvim_buf_get_mark(buf, "[")
	local end_pos = vim.api.nvim_buf_get_mark(buf, "]")

	if not start_pos or not end_pos then
		vim.notify("[eskopi] Could not get motion range", vim.log.levels.WARN)
		return ""
	end

	local lines = vim.api.nvim_buf_get_text(buf,
		start_pos[1] - 1, start_pos[2],
		end_pos[1] - 1, end_pos[2] + 1,
		{}
	)

	return table.concat(lines, "\n")
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

local function paste(reversed)
	local file = io.open(cache_file, "r")
	if not file then
		print("eskopi: Clipboard is empty")
		return
	end

	local content = file:read("*a")
	file:close()
	local lines = vim.split(content, "\n", { plain = true })

	vim.api.nvim_put(lines, "l", not reversed, true)
	vim.api.nvim_feedkeys("`]$", "n", false)
end

function M.paste_before()
	paste(true)
end

function M.paste_after()
	paste(false)
end

return M
