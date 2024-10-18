local M = {}

---@alias OpenWindowOptions { enter: boolean, win_config: vim.api.keyset.win_config }
---@alias OpenTerminalOptions { win_opts: OpenWindowOptions, cmd: string, startinsert: boolean }
---@alias WindowSplit "left" | "right" | "above" | "below"
---@alias WindowRelative "editor" | "win" | "cursor" | "mouse"

-- Open a new window
---@param opts OpenWindowOptions
function M.open_window(opts)
  local default_opts = {
    enter = true,
    win_config = {
      style = "minimal",
      focusable = true,
    },
  } --[[@as OpenWindowOptions]]

  opts = vim.tbl_deep_extend("force", default_opts, opts)

  local win_config = opts.win_config
  local split = win_config.split --[[@as WindowSplit]]
  local relative = win_config.relative --[[@as WindowRelative]]

  if split == "below" or split == "bottom" then
    opts.win_config = vim.tbl_deep_extend("force", {
      height = math.floor(vim.o.lines * 0.40),
    }, win_config)
  elseif split == "left" or split == "right" then
    opts.win_config = vim.tbl_deep_extend("force", {
      width = math.floor(vim.o.columns * 0.40),
    }, win_config)
  elseif relative == "editor" then
    opts.win_config = vim.tbl_deep_extend("force", {
      row = math.floor(vim.o.columns * 0.02),
      col = math.floor(vim.o.columns * 0.10),
      width = math.floor(vim.o.columns * 0.80),
      height = math.floor(vim.o.lines * 0.80),
      zindex = 50,
      border = "rounded",
    }, win_config)
  end

  return vim.api.nvim_open_win(0, opts.enter, opts.win_config)
end

-- Open a new terminal
--- @param opts OpenTerminalOptions
function M.open_terminal(opts)
  local default_opts = {
    startinsert = true,
    cmd = vim.env.SHELL,
  } --[[@as OpenTerminalOptions]]
  opts = vim.tbl_deep_extend("force", default_opts, opts)

  -- Open a new window
  local win = M.open_window(opts.win_opts)

  -- Open terminal in current window
  vim.cmd.terminal(opts.cmd)

  -- Close terminal on <q>
  vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })

  -- Do not show [Process exited] in finished terminals
  -- https://github.com/neovim/neovim/issues/14986#issuecomment-902705190
  vim.cmd("autocmd TermClose * silent! execute 'bdelete! ' . expand('<abuf>')")

  -- Start insert mode
  if opts.startinsert then
    vim.cmd.startinsert()
  end

  return win
end

return M
