local function keymap(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


keymap('', '<Space>', '<Nop>')
vim.g.mapleader = ' '

keymap('', '<F3>', ':NvimTreeToggle<CR>')

keymap('n', '<Leader><Backspace>', [[ :%s/\s\+$//e <CR> ]])   -- Remove trailing space


