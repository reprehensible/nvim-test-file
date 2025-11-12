local M = {}

-- Pattern mappings for finding related files
local patterns = {
    -- TypeScript patterns
    typescript = {
        -- Source to test
        {
            from = "^(.+)%.ts$",
            to_patterns = {
                "%1.test.ts",
                "%1.spec.ts",
                "%1.test.tsx",
                "%1.spec.tsx",
            }
        },
        {
            from = "^(.+)%.tsx$",
            to_patterns = {
                "%1.test.tsx",
                "%1.spec.tsx",
                "%1.test.ts",
                "%1.spec.ts",
            }
        },
        -- Test to source
        {
            from = "^(.+)%.test%.tsx?$",
            to_patterns = {
                "%1.tsx",
                "%1.ts",
            }
        },
        {
            from = "^(.+)%.spec%.tsx?$",
            to_patterns = {
                "%1.tsx",
                "%1.ts",
            }
        },
    },

    -- Python patterns
    python = {
        -- Source to test
        {
            from = "^(.+)/([^/]+)%.py$",
            to_patterns = {
                "%1/test_%2.py",
                "%1/%2_test.py",
                "tests/%1/%2.py",
                "test/%1/%2.py",
            }
        },
        -- Test to source (test_foo.py -> foo.py)
        {
            from = "^(.+)/test_([^/]+)%.py$",
            to_patterns = {
                "%1/%2.py",
            }
        },
        -- Test to source (foo_test.py -> foo.py)
        {
            from = "^(.+)/([^/]+)_test%.py$",
            to_patterns = {
                "%1/%2.py",
            }
        },
        -- Test directory to source (tests/foo/bar.py -> foo/bar.py)
        {
            from = "^tests/(.+)%.py$",
            to_patterns = {
                "%1.py",
            }
        },
        {
            from = "^test/(.+)%.py$",
            to_patterns = {
                "%1.py",
            }
        },
    },
}

-- Detect file type based on extension
local function get_filetype(filepath)
    if filepath:match("%.tsx?$") then
        return "typescript"
    elseif filepath:match("%.py$") then
        return "python"
    end
    return nil
end

-- Find related file for the current buffer
local function find_related_file(current_file)
    local filetype = get_filetype(current_file)

    if not filetype or not patterns[filetype] then
        return nil
    end

    -- Get relative path from cwd
    local cwd = vim.fn.getcwd()

    local relative_path = current_file
    if current_file:sub(1, #cwd) == cwd then
        relative_path = current_file:sub(#cwd + 2)  -- +2 to skip the separator
    end

    -- Collect all potential related files from matching patterns
    local candidates = {}

    for i, pattern_group in ipairs(patterns[filetype]) do
        local match = relative_path:match(pattern_group.from)

        if match then
            -- Generate all target files for this pattern
            for j, to_pattern in ipairs(pattern_group.to_patterns) do
                local related_file = relative_path:gsub(pattern_group.from, to_pattern)
                table.insert(candidates, related_file)
            end
        end
    end

    -- First pass: try all direct paths (fast)
    for i, related_file in ipairs(candidates) do
        local direct_path = cwd .. "/" .. related_file
        local readable = vim.fn.filereadable(direct_path)

        if readable == 1 then
            return vim.fn.fnamemodify(direct_path, ":p")
        end
    end

    -- Second pass: try recursive search (slow, only if direct failed)
    for i, related_file in ipairs(candidates) do
        local full_path = vim.fn.findfile(related_file, cwd .. "/**")

        if full_path ~= "" then
            return vim.fn.fnamemodify(full_path, ":p")
        end
    end

    return nil
end

-- Get the window in the specified direction
local function get_window_in_direction(direction)
    local current_win = vim.api.nvim_get_current_win()
    local current_pos = vim.api.nvim_win_get_position(current_win)

    local wins = vim.api.nvim_list_wins()

    for _, win in ipairs(wins) do
        if win ~= current_win then
            local pos = vim.api.nvim_win_get_position(win)

            -- Check if window is in the specified direction
            if direction == "h" then  -- left
                if pos[2] < current_pos[2] then
                    return win
                end
            elseif direction == "l" then  -- right
                if pos[2] > current_pos[2] then
                    return win
                end
            elseif direction == "k" then  -- up
                if pos[1] < current_pos[1] then
                    return win
                end
            elseif direction == "j" then  -- down
                if pos[1] > current_pos[1] then
                    return win
                end
            end
        end
    end

    return nil
end

-- Open related file in the specified direction
function M.open_related_in_direction(direction)
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end

    local related_file = find_related_file(current_file)

    if not related_file then
        vim.notify("No related file found", vim.log.levels.WARN)
        return
    end

    local target_win = get_window_in_direction(direction)

    if not target_win then
        vim.notify("No window in that direction", vim.log.levels.WARN)
        return
    end

    -- Switch to target window and open the file
    vim.api.nvim_set_current_win(target_win)
    vim.cmd("edit " .. vim.fn.fnameescape(related_file))
    vim.notify("Opened: " .. vim.fn.fnamemodify(related_file, ":~:."))
end

return M
