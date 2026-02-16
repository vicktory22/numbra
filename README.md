# Numbra

A Neovim plugin for adjusting line number brightness.

## Features

- Manual control over line number brightness
- Works with all colorschemes (no hardcoded colors)
- Supports `relativenumber` (LineNrAbove, LineNrBelow)
- Lightweight and simple

## Requirements

- Neovim 0.9.0+
- `termguicolors` must be enabled

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "vicktory22/numbra",
  config = true,
}
```

## Usage

```vim
:NumbraIncrease  " Increase brightness
:NumbraDecrease  " Decrease brightness
:NumbraReset     " Reset to original brightness
:NumbraDebug     " Show current state
```

### Keymaps

```lua
vim.keymap.set("n", "<leader>li", ":NumbraIncrease<CR>")
vim.keymap.set("n", "<leader>ld", ":NumbraDecrease<CR>")
vim.keymap.set("n", "<leader>lr", ":NumbraReset<CR>")
```

### API

```lua
require("numbra").increase()
require("numbra").decrease()
require("numbra").reset()
require("numbra").set_factor(1.5)
require("numbra").get_factor()
```

## Configuration

```lua
require("numbra").setup({
  factor = 1.0,       -- Initial brightness (1.0 = original)
  step = 0.2,         -- Change per command
  min_factor = 0.1,   -- Minimum brightness
  max_factor = 3.0,   -- Maximum brightness
  cache_delay = 100,  -- Delay before caching colors (ms)
})
```

| Option | Default | Description |
|--------|---------|-------------|
| `factor` | `1.0` | Initial brightness factor |
| `step` | `0.2` | Brightness change per command |
| `min_factor` | `0.1` | Minimum allowed factor |
| `max_factor` | `3.0` | Maximum allowed factor |
| `cache_delay` | `100` | Delay before caching colors after colorscheme loads |

## Troubleshooting

### Line numbers don't change

Ensure `termguicolors` is enabled:

```lua
vim.o.termguicolors = true
```

### Plugin doesn't work with TokyoNight

Increase the cache delay:

```lua
require("numbra").setup({
  cache_delay = 300,
})
```

### Debug

Run `:NumbraDebug` to see cached and current colors.

## How It Works

1. Caches original line number highlight colors
2. Adjusts brightness by interpolating toward white (factor > 1) or black (factor < 1)
3. Applies to LineNr, CursorLineNr, LineNrAbove, and LineNrBelow

## License

MIT
