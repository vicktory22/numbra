# Numbra

A Neovim plugin that dynamically adjusts line number brightness using configurable darken and brighten factors.

## Features

- Increase or decrease line number brightness
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
      darken_factor = 0.5,
      brighten_factor = 0,
    })
  end,
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'vicktory22/numbra'
```

## Usage

After installation, the plugin will automatically adjust line number brightness based on configuration.

### Configuration

```lua
require("numbra").setup({
  -- Factor to decrease brightness (0.0 to 1.0)
  -- 0.5 = 50% darker, 0.0 = no darkening
  darken_factor = 0.5,

  -- Factor to increase brightness (0.0 to 2.0)
  -- 1.0 = 100% brighter, 0.0 = no brightening
  brighten_factor = 0,
})
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `darken_factor` | number | `0.5` | Factor to decrease brightness (0-1) |
| `brighten_factor` | number | `0` | Factor to increase brightness (0-2) |

### API

```lua
-- Enable the plugin
require("numbra").enable()

-- Disable the plugin
require("numbra").disable()

-- Toggle on/off
require("numbra").toggle()

-- Check if enabled
local enabled = require("numbra").is_enabled()
```

## How It Works

1. Calculates the current line number highlight color
2. Adjusts brightness using HSL color space
3. Applies the new colors to LineNr and CursorLineNr groups

## Default Configuration

```lua
{
  darken_factor = 0.5,
  brighten_factor = 0,
}
```

- **darken_factor**: Set to `0.5` to reduce line number brightness by 50%
- **brighten_factor**: Set to `1.0` (or higher) to brighten line numbers

## Examples

### Decrease brightness only

```lua
require("numbra").setup({
  darken_factor = 0.5,
  brighten_factor = 0,
})
```

### Increase brightness only

```lua
require("numbra").setup({
  darken_factor = 0,
  brighten_factor = 1.0,
})
```

### Both decrease and increase brightness

```lua
require("numbra").setup({
  darken_factor = 0.5,
  brighten_factor = 0.5,
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
3. Try increasing/decreasing the factor values

## License

MIT License

## Contributing

Contributions are welcome! Feel free to open issues or pull requests.
