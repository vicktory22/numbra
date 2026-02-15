# Numbra

A Neovim plugin that allows manual adjustment of line number brightness through user commands.

## Features

- Manual control over line number brightness
- Increase and decrease brightness with user commands
- Works with all colorschemes (no hardcoded colors)
- Lightweight and performant
- Simple, unobtrusive

## Requirements

- Neovim 0.9.0+
- `termguicolors` must be enabled

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "vicktory22/numbra",
  config = function()
    require("numbra").setup({
      step = 0.05,
      min_factor = 0.1,
      max_factor = 3.0,
    })
  end,
}
```

## Usage

After installation, use the provided commands to adjust line number brightness.

### Commands

```vim
:NumbraIncrease  " Increase brightness by step value
:NumbraDecrease  " Decrease brightness by step value
:NumbraReset     " Reset to original brightness
```

### Keymap Examples

Add these to your Neovim configuration:

```lua
vim.keymap.set("n", "<leader>li", ":NumbraIncrease<CR>")
vim.keymap.set("n", "<leader>ld", ":NumbraDecrease<CR>")
vim.keymap.set("n", "<leader>lr", ":NumbraReset<CR>")
```

### Configuration

```lua
require("numbra").setup({
  -- Initial brightness factor (1.0 = original colors)
  factor = 1.0,

  -- Step size for increase/decrease commands (0.05 = 5%)
  step = 0.05,

  -- Minimum brightness factor (0.1 = 10% brightness)
  min_factor = 0.1,

  -- Maximum brightness factor (3.0 = 300% brightness)
  max_factor = 3.0,
})
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `factor` | number | `1.0` | Initial brightness (1.0 = original colors) |
| `step` | number | `0.05` | Brightness change per command (0.05 = 5%) |
| `min_factor` | number | `0.1` | Minimum allowed brightness (10%) |
| `max_factor` | number | `3.0` | Maximum allowed brightness (300%) |

### API

```lua
-- Increase brightness
require("numbra").increase()

-- Decrease brightness
require("numbra").decrease()

-- Reset to original brightness
require("numbra").reset()

-- Get current brightness factor
local factor = require("numbra").get_factor()

-- Set brightness factor directly
require("numbra").set_factor(1.5)
```

## How It Works

1. Caches original line number highlight colors from your colorscheme
2. When you increase/decrease brightness, adjusts lightness using HSL color space
3. Applies the new colors to LineNr and CursorLineNr groups
4. Resetting restores the original colors

## Default Configuration

```lua
{
  factor = 1.0,      -- Start with original brightness
  step = 0.05,       -- 5% change per command
  min_factor = 0.1,   -- 10% minimum
  max_factor = 3.0,   -- 300% maximum
}
```

## Examples

### Fine-grained control (1% steps)

```lua
require("numbra").setup({
  step = 0.01,
  min_factor = 0.05,
  max_factor = 5.0,
})
```

### Large adjustments (10% steps)

```lua
require("numbra").setup({
  step = 0.1,
  min_factor = 0.2,
  max_factor = 2.0,
})
```

### Dimmer by default

```lua
require("numbra").setup({
  factor = 0.8,  -- Start at 80% brightness
  step = 0.05,
})
```

## Troubleshooting

### Line numbers don't change color

Make sure `termguicolors` is enabled:

```lua
vim.o.termguicolors = true
```

### Plugin not working in some colorschemes

This plugin works with any colorscheme that provides foreground colors. If you experience issues:

1. Check your Neovim logs for errors
2. Ensure your colorscheme supports line number highlights
3. Try resetting with `:NumbraReset`

### Brightness not changing

Check current factor with `:lua print(require("numbra").get_factor())` - should return a number between your min and max values.

## License

MIT License

## Contributing

Contributions are welcome! Feel free to open issues or pull requests.

## Testing

Run the test suite:

```bash
cd tests
./run_all.sh
```

Tests use luaunit and mock Neovim API calls to verify:
- Link resolution for highlight groups (direct, single link, link chains, circular links)
- Color caching and application
- Brightness adjustment with various factors
