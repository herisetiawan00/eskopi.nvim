# eskopi.nvim ☕

*Eskopi* (/ɛs ˈkoʊ.pi/) comes from the Indonesian word "Es Kopi", meaning "iced coffee". The name was chosen because it sounds like "S copy" (short for super copy), which reflects what this plugin does — copy content that can be pasted in any other Neovim instance.

Question? lets [discuss it](https://github.com/herisetiawan00/eskopi.nvim/discussions)!

Have a problem or idea? Make an [issue](https://github.com/herisetiawan00/eskopi.nvim/issues) or a [PR](https://github.com/herisetiawan00/eskopi.nvim/pulls).

---

## Table of Contents

1. [Features](#features)
2. [Requirements](#requirements)
3. [Installation](#installation)
5. [Options](#options)
6. [Usage](#usage)

## Features

- Copy text on visual mode.
- Support vim motion.
- Paste on another instance without interrupting os clipboard.

## Requirements

- Nothing :)

## Installation

Use your favorite plugin manager :)

```lua
{ "herisetiawan00/eskopi.nvim" }
```

## Options

| Action          | Description                       |
| --------------- | --------------------------------- |
| `copy_operator` | Use for copy from motion          |
| `copy_visual`   | Use for copy from visual mode     |
| `paste_before`  | Use for paste before current line |
| `paste_after`   | Use for paste after current line  | 

## Usage
```lua
local map = vim.keymap.set
local eskopi = require("eskopi")

map("n", "<leader>y", eskopi.copy_operator, { desc = "eskopi copy (operator)" })
map("v", "<leader>y", eskopi.copy_visual, { desc = "eskopi copy (visual)" })
map("n", "<leader>P", eskopi.paste_before, { desc = "eskopi paste before current line" })
map("n", "<leader>p", eskopi.paste_after, { desc = "eskopi paste after current line" })
```

