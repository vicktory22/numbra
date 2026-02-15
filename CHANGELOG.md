# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Manual brightness control through user commands
- `:NumbraIncrease` command to increase brightness
- `:NumbraDecrease` command to decrease brightness
- `:NumbraReset` command to reset to original colors
- API methods: increase(), decrease(), reset(), get_factor(), set_factor(factor)
- Configurable step size for brightness adjustments
- Configurable minimum and maximum brightness factors

### Changed
- **BREAKING**: Removed automatic window-based brightness adjustment
- **BREAKING**: Removed `darken_factor` and `brighten_factor` configuration options
- **BREAKING**: Removed `enable()`, `disable()`, `toggle()`, and `is_enabled()` API methods
- Simplified configuration to single `factor` with `step`, `min_factor`, and `max_factor`
- Default brightness now starts at 1.0 (original colors) instead of auto-darkening
- Removed WinEnter and FocusGained autocmds
- Changed from per-window to global brightness application

### Removed
- `autocmds.lua` module
- Window-specific brightness logic
- Automatic brightness adjustments on window/focus changes

## [0.1.0]

### Added
- Initial release of Numbra plugin
- Dynamic line number brightness adjustment
- Support for LineNr and CursorLineNr groups
- Configurable darken_factor (0.0-1.0)
- Configurable brighten_factor (0.0-2.0)
- Toggle enable/disable functionality
- API methods: enable(), disable(), toggle(), is_enabled()
- GitHub Actions CI workflow with luacheck
