-- nvim-test-file plugin loader
-- Prevents the plugin from loading multiple times
if vim.g.loaded_nvim_test_file then
    return
end
vim.g.loaded_nvim_test_file = true

-- Create user commands for opening related files in each direction
vim.api.nvim_create_user_command('TestFileLeft', function()
    require('nvim-test-file').open_related_in_direction('h')
end, { desc = 'Open related test file in left window' })

vim.api.nvim_create_user_command('TestFileRight', function()
    require('nvim-test-file').open_related_in_direction('l')
end, { desc = 'Open related test file in right window' })

vim.api.nvim_create_user_command('TestFileUp', function()
    require('nvim-test-file').open_related_in_direction('k')
end, { desc = 'Open related test file in window above' })

vim.api.nvim_create_user_command('TestFileDown', function()
    require('nvim-test-file').open_related_in_direction('j')
end, { desc = 'Open related test file in window below' })
