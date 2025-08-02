# 🔍 neo-search

```
███╗   ██╗███████╗ ██████╗       ███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗
████╗  ██║██╔════╝██╔═══██╗      ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║
██╔██╗ ██║█████╗  ██║   ██║█████╗███████╗█████╗  ███████║██████╔╝██║     ███████║
██║╚██╗██║██╔══╝  ██║   ██║╚════╝╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║
██║ ╚████║███████╗╚██████╔╝      ███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝       ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
```

> **A powerful, telescope-powered find and replace plugin for Neovim**  
> *Fast • Intuitive • Precise*

## ✨ Features

- 🔍 **Instant Search** - Find all matches in your current buffer
- 🎯 **Precise Targeting** - See each match with line and column numbers
- 🌟 **Telescope Integration** - Beautiful UI with fuzzy finding capabilities
- ⚡ **Quick Replace** - Replace individual matches or all at once
- 🎨 **Visual Highlighting** - Temporary highlighting of selected matches
- ⚙️ **Configurable** - Customize search behavior and UI appearance

## 🚀 Installation

### With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "your-username/neo-search", -- Replace with your actual repo
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("neo-search").setup({
      -- Optional configuration
    })
  end,
  keys = {
    { "<leader>fr", "<cmd>lua require('neo-search').find_and_replace()<cr>", desc = "Find and Replace" },
  },
}
```

### With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "your-username/neo-search", -- Replace with your actual repo
  requires = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("neo-search").setup()
  end
}
```

## ⚡ Quick Start

1. **Basic Usage**: Press `<leader>fr` to start find and replace
2. **Enter Search Term**: Type what you want to find
3. **Browse Results**: Navigate through all matches in telescope
4. **Take Action**:
   - `<Enter>` - Jump to selected match
   - `<C-r>` - Replace selected match
   - `<C-a>` - Replace all matches

## 🎮 Keybindings

| Key | Action |
|-----|--------|
| `<leader>fr` | Open find and replace |
| `<Enter>` | Jump to selected match |
| `<C-r>` | Replace selected match |
| `<C-a>` | Replace all matches |

## 🛠️ Configuration

```lua
require("neo-search").setup({
  -- Telescope options
  telescope = {
    theme = "dropdown", -- or "ivy", "cursor", etc.
    layout_config = {
      width = 0.8,
      height = 0.6,
    },
  },
  
  -- Search options
  search = {
    case_sensitive = false,  -- Case-insensitive search by default
    whole_word = false,      -- Match partial words
    use_regex = false,       -- Use literal search by default
  },
})
```

## 📋 Commands

| Command | Description |
|---------|-------------|
| `:FindAndReplace` | Open find and replace interface |
| `:FAR` | Alias for FindAndReplace |
| `:TestSearch` | Debug command to test search functionality |

## 🎯 Use Cases

### Perfect for:
- 🔧 **Refactoring** - Rename variables, functions, or classes
- 📝 **Content Editing** - Replace repeated text patterns
- 🐛 **Bug Fixing** - Find and fix specific code patterns
- 🧹 **Code Cleanup** - Remove or replace deprecated code

### Example Workflow:
1. Press `<leader>fr`
2. Search for `oldFunctionName`
3. See all 15 occurrences across your file
4. Replace individual instances with `<C-r>` or all at once with `<C-a>`

## 🏗️ How It Works

Neo-search leverages the power of Telescope to provide a smooth find and replace experience:

1. **Search Phase**: Scans your current buffer for all matches
2. **Display Phase**: Shows results in a beautiful Telescope picker
3. **Action Phase**: Perform targeted replacements with visual feedback

### Match Display Format:
```
Line 42 Col 15: [local] config = require("config")
Line 58 Col 8:  function [local]_helper() 
```

Each match shows:
- Line number and column position
- Highlighted match in brackets `[match]`
- Surrounding context for clarity

## 🤝 Contributing

Contributions are welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest features  
- 📖 Improve documentation
- 🔧 Submit pull requests

## 📄 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - For the amazing fuzzy finder framework
- [Neovim](https://neovim.io/) - For the incredible editor
- The Neovim community for inspiration and support

---

<div align="center">

**Made with ❤️ for the Neovim community**

*Happy searching! 🔍*

</div>