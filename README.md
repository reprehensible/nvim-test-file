# nvim-test-file

A Neovim plugin for quickly switching between source files and their corresponding test files in existing split windows.

Written entirely with/by Claude Code.

## Features

- Toggle between source files and test files
- Opens files in existing split windows (left, right, up, or down)
- Smart pattern matching for TypeScript/TSX and Python files
- Fast file lookup with fallback to recursive search
- Works seamlessly with your existing window layout

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'your-username/nvim-test-file',
    config = function()
        -- Optional: Set up custom keymaps
        vim.keymap.set('n', '<leader>th', ':TestFileLeft<CR>', { desc = 'Open test file in left window' })
        vim.keymap.set('n', '<leader>tl', ':TestFileRight<CR>', { desc = 'Open test file in right window' })
        vim.keymap.set('n', '<leader>tk', ':TestFileUp<CR>', { desc = 'Open test file in window above' })
        vim.keymap.set('n', '<leader>tj', ':TestFileDown<CR>', { desc = 'Open test file in window below' })
    end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'your-username/nvim-test-file',
    config = function()
        -- Optional: Set up custom keymaps
        vim.keymap.set('n', '<leader>th', ':TestFileLeft<CR>', { desc = 'Open test file in left window' })
        vim.keymap.set('n', '<leader>tl', ':TestFileRight<CR>', { desc = 'Open test file in right window' })
        vim.keymap.set('n', '<leader>tk', ':TestFileUp<CR>', { desc = 'Open test file in window above' })
        vim.keymap.set('n', '<leader>tj', ':TestFileDown<CR>', { desc = 'Open test file in window below' })
    end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'your-username/nvim-test-file'

" Optional: Set up custom keymaps
nnoremap <leader>th :TestFileLeft<CR>
nnoremap <leader>tl :TestFileRight<CR>
nnoremap <leader>tk :TestFileUp<CR>
nnoremap <leader>tj :TestFileDown<CR>
```

## Usage

### Commands

The plugin provides four commands to open related files in different directions:

- `:TestFileLeft` - Open related file in the window to the left
- `:TestFileRight` - Open related file in the window to the right
- `:TestFileUp` - Open related file in the window above
- `:TestFileDown` - Open related file in the window below

### Typical Workflow

1. Open your source file in one window
2. Create a split (`:vsplit` or `:split`)
3. Run one of the `TestFile*` commands to open the related test file in an existing split

The plugin will:
- Detect if you're in a source file and open the corresponding test file
- Detect if you're in a test file and open the corresponding source file
- Use the first available window in the specified direction

### Example Keymaps

You can set up custom keymaps in your `init.lua`:

```lua
-- Using <leader>t as a prefix for test file commands
vim.keymap.set('n', '<leader>th', ':TestFileLeft<CR>', { desc = 'Test file left' })
vim.keymap.set('n', '<leader>tl', ':TestFileRight<CR>', { desc = 'Test file right' })
vim.keymap.set('n', '<leader>tk', ':TestFileUp<CR>', { desc = 'Test file up' })
vim.keymap.set('n', '<leader>tj', ':TestFileDown<CR>', { desc = 'Test file down' })

-- Or use a single key with a direction modifier
vim.keymap.set('n', '<C-t>h', ':TestFileLeft<CR>', { desc = 'Test file left' })
vim.keymap.set('n', '<C-t>l', ':TestFileRight<CR>', { desc = 'Test file right' })
vim.keymap.set('n', '<C-t>k', ':TestFileUp<CR>', { desc = 'Test file up' })
vim.keymap.set('n', '<C-t>j', ':TestFileDown<CR>', { desc = 'Test file down' })
```

### Lua API

You can also use the Lua API directly:

```lua
require('nvim-test-file').open_related_in_direction('h')  -- left
require('nvim-test-file').open_related_in_direction('l')  -- right
require('nvim-test-file').open_related_in_direction('k')  -- up
require('nvim-test-file').open_related_in_direction('j')  -- down
```

## Supported File Patterns

### TypeScript/TSX

The plugin recognizes the following patterns:

**Source to Test:**
- `file.ts` → `file.test.ts`, `file.spec.ts`, `file.test.tsx`, `file.spec.tsx`
- `file.tsx` → `file.test.tsx`, `file.spec.tsx`, `file.test.ts`, `file.spec.ts`

**Test to Source:**
- `file.test.ts` / `file.test.tsx` → `file.ts`, `file.tsx`
- `file.spec.ts` / `file.spec.tsx` → `file.ts`, `file.tsx`

### Python

The plugin recognizes the following patterns:

**Source to Test:**
- `path/to/file.py` → `path/to/test_file.py`, `path/to/file_test.py`, `tests/path/to/file.py`, `test/path/to/file.py`

**Test to Source:**
- `path/to/test_file.py` → `path/to/file.py`
- `path/to/file_test.py` → `path/to/file.py`
- `tests/path/to/file.py` → `path/to/file.py`
- `test/path/to/file.py` → `path/to/file.py`

## How It Works

1. **File Type Detection**: The plugin detects the file type based on the extension (`.ts`, `.tsx`, `.py`)
2. **Pattern Matching**: It uses predefined patterns to find related files
3. **Fast Lookup**: First attempts a direct file path lookup (fast)
4. **Fallback Search**: If direct lookup fails, performs a recursive search in the project (slower but thorough)
5. **Window Selection**: Finds the first window in the specified direction relative to the current window
6. **File Opening**: Switches to that window and opens the related file

## Configuration

Currently, the plugin uses built-in patterns for TypeScript/TSX and Python files. Future versions may support custom pattern configuration.

## Requirements

- Neovim 0.7.0 or higher

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

MIT License - see LICENSE file for details

## Roadmap

Potential future enhancements:
- [ ] Support for more languages (Go, Rust, Java, etc.)
- [ ] Custom pattern configuration
- [ ] Create test file if it doesn't exist
- [ ] Support for alternative test file locations
- [ ] Window selection preferences (e.g., nearest vs. farthest)
