-- Helpers ====================================================================
local add = vim.pack.add
local map = vim.keymap.set

add({ "https://github.com/nvim-mini/mini.nvim" })

local misc = require("mini.misc")

-- stylua: ignore start

-- Execute immediately.
-- Use for what must be executed during startup.
-- Like colorscheme, statusline, tabline, dashboard, etc.
local now = function(f) misc.safely("now", f) end

-- Execute a bit later.
-- Use for things not needed during startup.
local later = function(f) misc.safely("later", f) end

-- Use only if needed during startup when Neovim is started
-- Like `nvim -- path/to/file`, but otherwise delaying is fine.
local now_if_args = vim.fn.argc(-1) > 0 and now or later

-- Custom autocommand group
local gr = vim.api.nvim_create_augroup("custom-config", {})

-- Helper to create an autocommand
local new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

-- `vim.pack.add()` hook helper
local on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  new_autocmd('PackChanged', '*', f, desc)
end

-- stylua: ignore end

-- Mini ======================================================================

-- Colorscheme
now(function()
  add({ "https://github.com/catppuccin/nvim" })

  require("catppuccin").setup({
    term_colors = true,
    lsp_styles = {
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
    integrations = {
      mason = true,
      noice = true,
      snacks = {
        enabled = true,
        indent_scope_color = "overlay2", -- catppuccin color (eg. `lavender`) Default: overlay2
      },
    },
  })

  vim.cmd("colorscheme catppuccin-nvim")
end)

-- Common configuration presets
now(function()
  require("mini.basics").setup({
    options = {
      -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
      extra_ui = true,
      -- Presets for window borders ('single', 'double', ...)
      -- Default 'auto' infers from 'winborder' option
      win_borders = "auto",
    },
    mappings = {
      -- Basic mappings (better 'jk', save with Ctrl+S, ...)
      basic = true,
      -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
      option_toggle_prefix = "",
      -- Create `<C-hjkl>` mappings for window navigation
      windows = true,
      -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
      move_with_alt = true,
    },
  })

  -- Options ==================================================================

  vim.o.autowrite = true
  vim.o.backup = false
  vim.o.swapfile = false
  vim.o.tabstop = 2
  vim.o.shiftwidth = 2
  vim.o.shiftround = true
  vim.o.foldlevel = 99
  vim.o.foldmethod = "indent"
  vim.o.inccommand = "nosplit"
  vim.o.relativenumber = true
  vim.o.laststatus = 3
  vim.o.wrap = false
  vim.o.list = false
  vim.o.wildmode = "longest:full,full"
  vim.o.winblend = 0
  vim.o.pumblend = 0
  vim.o.helpheight = 10
  vim.o.spelllang = "en_us,cjk"
  vim.o.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

  vim.g.vim_dadbod_completion_lowercase_keywords = 0

  -- Change default shell on Windows
  if vim.fn.has("win32") then
    if vim.fn.executable("nu") then
      vim.o.shell = "nu"
      vim.o.shellcmdflag = "--stdin --no-newline -c"
      vim.o.shellredir = "out+err> %s"
      vim.o.shellxescape = ""
      vim.o.shellxquote = ""
      vim.o.shellquote = ""
      vim.o.shelltemp = false

      vim.g.termcmd = "nu.exe"
    else
      vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
      vim.o.shellcmdflag =
        "-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
      vim.o.shellredir = "2>&1 | %{ '$_' } | Out-File %s; exit $LastExitCode"
      vim.o.shellpipe = "2>&1 | %{ '$_' } | Tee-Object %s; exit $LastExitCode"
      vim.o.shellquote = ""
      vim.o.shellxquote = ""

      vim.g.termcmd = string.format("%s.exe -NoLogo", vim.api.nvim_get_option_value("shell", {}))
    end
  end

  -- Keymaps ==================================================================

  -- Better escape
  map("i", "jj", "<esc>", { desc = "Better Escape" })

  -- Better paste
  map("n", "p", '"+p', { desc = "Better paste" })
  map("v", "p", "P", { desc = "Better paste" })

  -- Better indenting
  map("x", "<", "<gv")
  map("x", ">", ">gv")

  -- Misc
  map("v", "<C-c>", '"+y', { desc = "Copy selection" })
  map("v", "<C-x>", '"+d', { desc = "Cut selection" })
  map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
  map({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
  -- map({ 'n', 'v', 'x', 'i' }, '<C-a>', '<esc>ggVG', { desc = 'Select All' })
  map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

  -- Window splits
  map("n", "|", "<cmd>split<cr>", { desc = "Horizontal Split" })
  map("n", "\\", "<cmd>vsplit<cr>", { desc = "Vertical Split" })

  -- Buffers
  map("n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" })
  map("n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Previous buffer" })
  map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

  -- Tabs
  map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
  map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
  map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
  map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
  map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })

  -- Quit
  map({ "n", "v", "x" }, "<leader>qw", "<cmd>exit<cr>", { desc = "Quit current window" })
  map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

  -- Comment
  map("n", "<c-/>", ":norm gcc<CR>", { desc = "Toggle comment", silent = true })
  map("v", "<c-/>", "gc", { desc = "Toggle comment", remap = true })
  map("n", "<c-_>", ":norm gcc<CR>", { desc = "Toggle comment", silent = true })
  map("v", "<c-_>", "gc", { desc = "Toggle comment", remap = true })

  -- Paste linewise before/after current line
  map("n", "[p", '<Cmd>exe "iput! " . v:register<CR>', { desc = "Paste Above" })
  map("n", "]p", '<Cmd>exe "iput "  . v:register<CR>', { desc = "Paste Below" })

  -- Highlights under cursor
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
  map("n", "<leader>uI", function()
    vim.treesitter.inspect_tree()
    vim.api.nvim_input("I")
  end, { desc = "Inspect Tree" })

  -- Clear search and stop snippet on escape
  map({ "i", "n", "s" }, "<esc>", function()
    vim.cmd("noh")
    return "<esc>"
  end, { expr = true, desc = "Escape and Clear hlsearch" })

  -- Autocmds =================================================================

  -- Set my highlight group
  new_autocmd("ColorScheme", "*", function()
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    -- set_hl("FloatBorder", { fg = "#3b4261", bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinSeparator", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })
  end, "Custom highlight group")

  -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
  -- Do on `FileType` to always override these changes from filetype plugins.
  new_autocmd("FileType", nil, function()
    vim.cmd("setlocal formatoptions-=c formatoptions-=o")
  end, "Proper 'formatoptions'")

  -- Change tab size to 4 for some languages
  new_autocmd("FileType", { "c", "cpp", "cs", "go", "rust", "python", "fish", "hyprlang", "rasi" }, function()
    vim.cmd("setlocal tabstop=4 softtabstop=4 shiftwidth=4")
  end, "4-space indentation for some filetypes")

  -- Change some options for markdown files
  new_autocmd("FileType", "markdown", function()
    vim.opt_local.commentstring = "<!-- %s -->"
  end, "Markdown related options")

  -- Check if we need to reload the file when it changed
  new_autocmd({ "FocusGained", "TermClose", "TermLeave" }, "*", function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end, "Reload changed file")

  -- resize splits if window got resized
  new_autocmd({ "VimResized" }, "*", function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end, "Resize splits")
end)

-- Icon provider
now(function()
  -- Set up to not prefer extension-based icon for some extensions
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  require("mini.icons").setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      ["README.md"] = { glyph = "󰍔", hl = "MiniIconsBlue" },
      ["README.txt"] = { glyph = "󰍔", hl = "MiniIconsBlue" },
      arch = { glyph = "󰣇", hl = "MiniIconsAzure" },
      conf = { glyph = "󰒓", hl = "MiniIconsGrey" },
      config = { glyph = "󰒓", hl = "MiniIconsCyan" },
      env = { glyph = "󰒓", hl = "MiniIconsYellow" },
      profile = { glyph = "󰒓", hl = "MiniIconsGrey" },
      README = { glyph = "󰍔", hl = "MiniIconsBlue" },
    },
    filetype = {
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
    directory = {
      [".vscode"] = { glyph = "󰉋", hl = "MiniIconsYellow" },
      git = { glyph = "󰉋", hl = "MiniIconsOrange" },
      src = { glyph = "󰴉", hl = "MiniIconsGreen" },
      build = { glyph = "󱧼", hl = "MiniIconsGreen" },
      dist = { glyph = "󱧼", hl = "MiniIconsGreen" },
    },
    extension = {
      conf = { glyph = "󰒓", hl = "MiniIconsGrey" },
      ttf = { glyph = "", hl = "MiniIconsRed" },
    },
  })

  -- Mock 'nvim-tree/nvim-web-devicons' for plugins without 'mini.icons' support.
  MiniIcons.mock_nvim_web_devicons()

  -- Add LSP kind icons
  MiniIcons.tweak_lsp_kind()
end)

-- Extra 'mini.nvim' functionality
later(function()
  require("mini.extra").setup()
end)

-- Miscellaneous small but useful functions
later(function()
  -- Makes `:h MiniMisc.put()` and `:h MiniMisc.put_text()` public
  require("mini.misc").setup()

  -- Change current working directory based on the current file path
  MiniMisc.setup_auto_root()

  -- Restore latest cursor position on file open
  MiniMisc.setup_restore_cursor()

  -- Synchronize terminal emulator background with Neovim's background to remove
  -- possibly different color padding around Neovim instance
  -- MiniMisc.setup_termbg_sync()
end)

-- Extend and create a/i textobjects, like `:h a(`, `:h a'`, and more)
later(function()
  local ai = require("mini.ai")
  ai.setup({
    -- 'mini.ai' can be extended with custom textobjects
    custom_textobjects = {
      -- buffer
      b = MiniExtra.gen_ai_spec.buffer(),
      -- function
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      -- class
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    },
    n_lines = 500,
  })
end)

-- Align text interactively
later(function()
  require("mini.align").setup()
end)

-- Go forward/backward with square brackets
later(function()
  require("mini.bracketed").setup()
end)

-- Show next key clues in a bottom right window
later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = { delay = 200 },
    -- Define which clues to show. By default shows only clues for custom mappings
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
      {
        { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
        { mode = "n", keys = "<Leader>c", desc = "+Code" },
        { mode = "n", keys = "<Leader>e", desc = "+Explore" },
        { mode = "n", keys = "<Leader>f", desc = "+Find" },
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = "n", keys = "<Leader>q", desc = "+Session" },
        { mode = "n", keys = "<Leader>s", desc = "+Search" },
        { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
        { mode = "n", keys = "<Leader>u", desc = "+Toggle" },
        { mode = "n", keys = "<Leader>x", desc = "+Quickfix" },
        { mode = "n", keys = "<Leader><tab>", desc = "+Tab" },
        -- { mode = "n", keys = "<Leader>v", desc = "+Visual" },
        { mode = "x", keys = "<Leader>g", desc = "+Git" },
      },
    },
    -- Explicitly opt-in for set of common keys to trigger clue window
    triggers = {
      { mode = { "n", "x" }, keys = "<Leader>" }, -- Leader triggers
      { mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
      { mode = { "n", "x" }, keys = "]" },
      { mode = "i", keys = "<C-x>" }, -- Built-in completion
      { mode = { "n", "x" }, keys = "g" }, -- `g` key
      { mode = { "n", "x" }, keys = "'" }, -- Marks
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' }, -- Registers
      { mode = { "i", "c" }, keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" }, -- Window commands
      { mode = { "n", "x" }, keys = "s" }, -- `s` key (mini.surround, etc.)
      { mode = { "n", "x" }, keys = "z" }, -- `z` key
    },
  })
end)

-- Comment lines
later(function()
  require("mini.comment").setup()
end)

-- Highlight patterns in text. Like `TODO`/`NOTE` or color hex codes.
later(function()
  local hipatterns = require("mini.hipatterns")
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      -- Highlight a fixed set of common words. Will be highlighted in any place,
      -- not like "only in comments".
      fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
      hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
      todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
      note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),

      -- Highlight hex color string (#aabbcc) with that color as a background
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Special key mappings
later(function()
  require("mini.keymap").setup()
  -- Navigate completion menu with `<Tab>` /  `<S-Tab>`
  MiniKeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
  MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
  -- On `<CR>` try to accept current completion item, fall back to accounting
  -- for pairs from 'mini.pairs'
  MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
  -- On `<BS>` just try to account for pairs from 'mini.pairs'
  MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
end)

-- Move any selection in any direction
later(function()
  require("mini.move").setup()
end)

-- Autopairs functionality
later(function()
  require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { "string" },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  })
end)

-- Split and join arguments
later(function()
  require("mini.splitjoin").setup()
end)

-- Surround actions: add/delete/replace/find/highlight
later(function()
  require("mini.surround").setup({
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  })
end)

-- Snacks =====================================================================

-- Snazzy bufferline
now(function()
  add({ "https://github.com/akinsho/bufferline.nvim" })

  local opts = {
    options = {
      always_show_bufferline = false,
      mode = "tabs",
      offsets = {
        {
          filetype = "snacks_layout_box",
          text = "",
          text_align = "center",
          separator = true,
        },
      },
    },
  }

  if (vim.g.colors_name or ""):find("catppuccin") then
    opts.highlights = require("catppuccin.special.bufferline").get_theme()
  end

  require("bufferline").setup(opts)

  map("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
  map("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
  map("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
  map("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
  map("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })
  map("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })
  map("n", "<leader>bj", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })
end)

-- Snazzy statusline
now(function()
  add({ "https://github.com/nvim-lualine/lualine.nvim" })

  local disabled_filetypes = { "snacks_dashboard", "snacks_layout_box", "snacks_picker_list", "snacks_picker_input" }

  local winbar = {
    lualine_c = {
      { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
      { "filename", padding = { left = 0 } },
    },
  }

  require("lualine").setup({
    options = {
      theme = "auto",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = disabled_filetypes, winbar = disabled_filetypes },
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        {
          "branch",
          on_click = function()
            Snacks.picker.git_branches()
          end,
        },
      },
      lualine_c = {
        { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
        { "filename", padding = { left = 0 } },
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
          on_click = function()
            Snacks.picker.diagnostics_buffer()
          end,
        },
      },
      lualine_x = {
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
          on_click = function()
            Snacks.picker.git_status()
          end,
        },
        {
          "lsp_status",
          symbols = { spinner = "", done = "" },
          on_click = function()
            vim.cmd("checkhealth vim.lsp")
          end,
        },
        -- stylua: ignore
        { function() return vim.bo.ft end, },
        { "encoding" },
        { "fileformat", padding = { left = 1, right = 2 } },
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    winbar = winbar,
    inactive_winbar = winbar,
    extensions = { "neo-tree", "lazy", "fzf" },
  })
end)

-- Collection of QoL plugins
now(function()
  add({ { src = "https://github.com/folke/snacks.nvim", name = "snacks" } })

  require("snacks").setup({
    animate = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = {
      preset = {
        -- stylua: ignore
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load({ last = true })" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
      },
    },
    explorer = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    keymap = { enabled = true },
    layout = { enabled = true },
    lazygit = { enabled = true },
    notifier = {
      enabled = true,
      top_down = false,
    },
    picker = {
      enabled = true,
      db = {
        sqlite3_path = vim.fn.has("win32") == 1
            and "~/AppData/Local/Microsoft/WinGet/Packages/SQLite.SQLite_Microsoft.Winget.Source_8wekyb3d8bbwe/sqlite3.exe"
          or nil,
      },
      -- default layout
      layout = {
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= (vim.o.lines * 2.67) and "default" or "vertical"
        end,
        -- override
        layout = {
          width = 0.80,
          min_width = 70,
          height = 0.80,
          border = "none",
        },
      },
      formatters = {
        file = { filename_first = true },
      },
      win = {
        input = {
          keys = {
            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        files = { hidden = true },
        explorer = {
          layout = {
            layout = { width = 0.3 },
            -- auto_hide = { "input" },
            -- preview = "main",
          },
          win = {
            list = {
              keys = {
                ["<f2>"] = "explorer_rename",
                ["<LeftRelease>"] = "confirm",
                ["<C-l>"] = { "<cmd>wincmd 2w<CR>", expr = true },
              },
            },
          },
          hidden = true,
          exclude = { ".git" },
          include = {
            ".vscode",
            ".node_modules",
            "*.conf*",
            ".local",
            ".gitconfig",
            ".ssh",
            ".profile",
            ".cargo",
            ".zsh*",
            ".bash*",
            "*.env.*",
            ".Xresources",
          },
        },
        projects = {
          projects = { vim.fn.expand("~/OneDrive/Obsidian") },
        },
      },
    },
    quickfile = { enabled = true },
    rename = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      enabled = true,
      win = {
        wo = { winbar = "" },
      },
    },
    toggle = { enabled = true },
    util = { enabled = true },
    win = {
      width = 0.85,
      height = 0.85,
      -- border = "rounded",
      -- backdrop = 100,
    },
    words = { enabled = true },
    zen = { enabled = true },
  })

  -- stylua: ignore start

  -- Buffers
  map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
  map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
  -- Pickers & Explorer
  map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc= "Smart Find Files" })
  map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc= "Buffers" })
  map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
  map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
  map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
  map("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })
  -- Find
  map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  map("n", "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, { desc = "Buffers (all)" })
  map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
  map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
  map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
  map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
  map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
  -- Git
  map("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
  map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
  map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
  map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
  map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
  map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
  map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
  -- lazygit
  if vim.fn.executable("lazygit") == 1 then
    map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
  end
  -- gh
  map("n", "<leader>gi", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues (open)" })
  map("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
  map("n", "<leader>gp", function() Snacks.picker.gh_pr() end, { desc = "GitHub Pull Requests (open)" })
  map("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub Pull Requests (all)" })
  -- Grep
  map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
  map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
  map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
  map("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
  map("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
  -- Search
  map("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
  map("n", '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Search History" })
  map("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
  map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
  map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
  map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
  map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
  map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
  map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
  map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
  map("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
  map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
  map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
  map("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
  map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
  map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
  map("n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
  map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
  map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
  map("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
  map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
  -- Terminal
  map("n", "<leader>th", function() Snacks.terminal(vim.g.termcmd, { win = { position = "bottom", height = 0.5, relative = "editor" } }) end, { desc = "Open terminal horizontally" })
  map("n", "<leader>tv", function() Snacks.terminal(vim.g.termcmd, { win = { position = "right", width = 0.4, relative = "editor" } }) end, { desc = "Open terminal vertically" })
  map("n", "<leader>tf", function() Snacks.terminal(vim.g.termcmd, { win = { position = "float", relative = "editor" } }) end, { desc = "Open terminal floating" })
  map("n", "<leader>tt", function() vim.cmd("term ".. vim.g.termcmd) end, { desc = "Open terminal in new buffer" })
  -- LSP
  map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
  map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
  map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References" })
  map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
  map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  map("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, { desc = "C[a]lls Incoming" })
  map("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "C[a]lls Outgoing" })
  map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
  map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  -- Other
  map("n", "<leader>z",  function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
  map("n", "<leader>Z",  function() Snacks.zen.zoom() end, { desc = "Toggle Zoom" })
  map("n", "<leader>.",  function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
  map("n", "<leader>S",  function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
  map("n", "<leader>n",  function() Snacks.notifier.show_history() end, { desc = "Notification History" })
  map("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
  map("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
  map("n", "]]",         function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
  map("t", "]]",         function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
  map("n", "[[",         function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
  map("t", "[[",         function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
  -- Toggle
  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>ul")
  Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
  Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
  Snacks.toggle.treesitter():map("<leader>uT")
  Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
  Snacks.toggle.dim():map("<leader>uD")
  Snacks.toggle.animate():map("<leader>ua")
  Snacks.toggle.indent():map("<leader>ug")
  Snacks.toggle.scroll():map("<leader>uS")
  Snacks.toggle.profiler():map("<leader>dpp")
  Snacks.toggle.profiler_highlights():map("<leader>dph")
  if vim.lsp.inlay_hint then
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end
  -- stylua: ignore end
end)

-- Git integration for buffers
now(function()
  add({ "https://github.com/lewis6991/gitsigns.nvim" })

  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      ---@diagnostic disable-next-line: redefined-local
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      -- stylua: ignore start
      map("n", "]h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next Hunk")
      map("n", "[h", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Prev Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  })
end)

-- Messages, Cmdline and the Popupmenu.
now(function()
  add({
    { src = "https://github.com/folke/noice.nvim", name = "noice" },
    "https://github.com/MunifTanjim/nui.nvim",
  })

  require("noice").setup({
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    views = {
      hover = {
        size = {
          max_width = math.floor(vim.o.columns * 0.8),
          max_height = math.floor(vim.o.lines * 0.8),
        },
        scrollbar = false,
      },
      cmdline_popup = {
        size = { max_width = math.floor(vim.o.columns * 0.8) },
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      { filter = { mode = "i" }, view = "mini", opts = { skip = true } },
      { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
      { filter = { event = "notify", find = "man.lua" }, opts = { skip = true } },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d fewer lines" },
            { find = "%d more lines" },
          },
        },
        opts = { skip = true },
      },
    },
  })

  -- stylua: ignore start
  map("n", "<leader>sn", "", { desc = "+noice" })
  map("n", "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end,  { desc = "Redirect Cmdline" })
  map("n", "<leader>snl", function() require("noice").cmd("last") end, {desc = "Noice Last Message" })
  map("n", "<leader>snh", function() require("noice").cmd("history") end, {desc = "Noice History" })
  map("n", "<leader>sna", function() require("noice").cmd("all") end, {desc = "Noice All" })
  map("n", "<leader>snd", function() require("noice").cmd("dismiss") end, {desc = "Dismiss All" })
  map("n", "<leader>snt", function() require("noice").cmd("pick") end, {desc = "Noice Picker (Telescope/FzfLua)" })
  -- stylua: ignore end
end)

-- Completion and signature help
now_if_args(function()
  add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    "https://github.com/rafamadriz/friendly-snippets",
  })

  require("blink.cmp").setup({
    fuzzy = {
      prebuilt_binaries = { download = true },
      implementation = "lua",
    },
    snippets = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      menu = {
        -- border = "none",
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "none" },
      },
      ghost_text = { enabled = false },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    cmdline = {
      enabled = true,
      keymap = {
        -- preset = "inherit",
        ["<CR>"] = {},
        ["<Tab>"] = { "insert_next" },
        ["<S-Tab>"] = { "insert_prev" },
      },
      completion = {
        menu = {
          auto_show = function(_)
            return true
            -- return vim.fn.getcmdtype() == ":"
          end,
        },
        list = {
          selection = { preselect = false, auto_insert = true },
        },
      },
    },
    -- signature = { window = { border = "none" } },
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
    },
  })

  vim.lsp.config["*"] = {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
  }
end)

-- Session management
later(function()
  add({ "https://github.com/folke/persistence.nvim" })

  require("persistence").setup({})

  -- stylua: ignore start
  map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore Session" })
  map("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select Session" })
  map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session"  })
  map("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })
  -- stylua: ignore end
end)

-- Smart navigation and resizing of Neovim + terminal multiplexer splits
later(function()
  add({ { src = "https://github.com/mrjones2014/smart-splits.nvim", name = "smart-splits" } })

  require("smart-splits").setup({ default_amount = 1 })

  map("n", "<C-h>", "<cmd>SmartCursorMoveLeft<cr>", { desc = "Move cursor left" })
  map("n", "<C-j>", "<cmd>SmartCursorMoveDown<cr>", { desc = "Move cursor down" })
  map("n", "<C-k>", "<cmd>SmartCursorMoveUp<cr>", { desc = "Move cursor up" })
  map("n", "<C-l>", "<cmd>SmartCursorMoveRight<cr>", { desc = "Move cursor right" })
  map({ "n", "t" }, "<C-Up>", "<cmd>SmartResizeUp<cr>", { desc = "Resize window up" })
  map({ "n", "t" }, "<C-Down>", "<cmd>SmartResizeDown<cr>", { desc = "Resize window down" })
  map({ "n", "t" }, "<C-Left>", "<cmd>SmartResizeLeft<cr>", { desc = "Resize window left" })
  map({ "n", "t" }, "<C-Right>", "<cmd>SmartResizeRight<cr>", { desc = "Resize window right" })
end)

-- Enhanced increment/decrement
later(function()
  add({ "https://github.com/monaqa/dial.nvim" })

  local augend = require("dial.augend")

  local default_group = {
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.integer.alias.octal,
    augend.integer.alias.binary,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%Y年%-m月%-d日"],
    augend.date.alias["%H:%M"],
    augend.constant.alias.en_weekday,
    augend.constant.alias.en_weekday_full,
    augend.constant.alias.bool,
    augend.constant.alias.Bool,
    augend.semver.alias.semver,
    augend.constant.new({
      elements = { "and", "or" },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "&&", "||" },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
				-- stylua: ignore
				elements = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
				-- stylua: ignore
				elements = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" },
      word = false,
      cyclic = true,
    }),
  }

  local filetype_groups = {
    typescript = {
      augend.constant.new({ elements = { "let", "const" } }),
    },
    css = {
      augend.hexcolor.new({ case = "lower" }),
      augend.hexcolor.new({ case = "upper" }),
    },
    markdown = {
      augend.constant.new({
        elements = { "[ ]", "[x]" },
        word = false,
        cyclic = true,
      }),
      augend.misc.alias.markdown_header,
    },
  }

  for _, group in ipairs(filetype_groups) do
    vim.list_extend(group, default_group)
  end

  require("dial.config").augends:register_group(default_group)
  require("dial.config").augends:on_filetype(filetype_groups)

  map("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
  map("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
end)

-- Enhanced character motions
later(function()
  add({ "https://github.com/folke/flash.nvim" })

  require("flash").setup()

  -- stylua: ignore start
  map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
  map({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
  map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
  map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
  map({ "c" }, "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
  -- Simulate nvim-treesitter incremental selection
  map({ "n", "o", "x" }, "<cr>", function()
    require("flash").treesitter({
      actions = {
        ["<cr>"] = "next",
        ["<BS>"] = "prev",
      },
    })
  end, { desc = "Treesitter Incremental Selection" })
  -- stylua: ignore end
end)

-- Improve viewing Markdown files
later(function()
  add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

  require("render-markdown").setup({
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = " " },
      checked = { icon = "󰄳 " },
    },
    html = { comment = { conceal = false } },
  })
end)

-- Obsidian 🤝 Neovim
later(function()
  add({ "https://github.com/obsidian-nvim/obsidian.nvim" })

  require("obsidian").setup({
    workspaces = {
      {
        name = "Obsidian",
        path = "~/OneDrive/Obsidian",
      },
    },
    notes_subdr = "02-Notes",
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = "journal-template.md",
      default_tags = {},
      workdays_only = false,
    },
    completion = {
      blink = true,
      min_chars = 1,
    },
    new_notes_location = "current_dir",
    preferred_link = { style = "wiki" },
    frontmatter = { enabled = true },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    attachments = { folder = "attachments" },
    footer = { enabled = false },
    legacy_commands = false,
  })
end)

-- Tree-sitter ================================================================

now_if_args(function()
  -- Update tree-sitter parsers after plugin is updated
  on_packchanged("nvim-treesitter", { "update" }, function()
    vim.cmd("TSUpdate")
  end, "Update tree-sitter parsers")

  add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  })

  -- Install tree-sitter parsers for languages
  local languages = {
    "bash",
    "c",
    "cpp",
    "css",
    "desktop",
    "dockerfile",
    "diff",
    "git_config",
    "gitcommit",
    "git_rebase",
    "gitignore",
    "gitattributes",
    "html",
    "ini",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "nu",
    "powershell",
    "printf",
    "python",
    "query",
    "regex",
    "sql",
    "tmux",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "xresources",
    "yaml",
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  new_autocmd("FileType", filetypes, function(ev)
    vim.treesitter.start(ev.buf)

    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end, "Start tree-sitter")
end)

-- Language servers ===========================================================

now_if_args(function()
  add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/b0o/SchemaStore.nvim",
  })

  require("mason").setup({
    max_concurrent_installers = 10,
    github = {
      -- download_url_template = "https://github.com/%s/releases/download/%s/%s",
      download_url_template = "https://gh-proxy.org/https://github.com/%s/releases/download/%s/%s",
    },
    ui = {
      -- border = "rounded",
      -- backdrop = 100,
      icons = {
        package_pending = " ",
        package_installed = "󰄳 ",
        package_uninstalled = "󰚌 ",
      },
      keymaps = {
        uninstall_package = "x",
        cancel_installation = "<C-c>",
        toggle_help = "?",
      },
    },
  })

  require("mason-lspconfig").setup({
    automatic_enable = false,
    ensure_installed = {
      "lua_ls",
      "stylua",
      "taplo",
      "marksman",
      -- "shfmt",
      -- "prettierd",
      -- "clang-format",
      -- "gofumpt",
      -- "goimports",
      -- "shellcheck",
      -- "xmlformatter"
      -- "hadolint",
      -- "markdownlint-cli2",
      -- "markdown-toc",
      -- "powershell_es"
    },
  })

  vim.lsp.config("lua_ls", {
    on_attach = function(client, _)
      -- Reduce very long list of triggers for better completion experience
      client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
    end,
    settings = {
      Lua = {
        -- Define runtime properties. Use 'LuaJIT', as it is built into Neovim.
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        workspace = {
          -- Don't analyze code from submodules
          ignoreSubmodules = true,
          -- Add Neovim's methods for easier code writing
          library = { vim.env.VIMRUNTIME },
        },
        diagnostics = { globals = { "vim", "Snacks", "MiniIcons", "MiniMisc", "MiniExtra", "MiniKeymap" } },
        telemetry = { enable = false },
      },
    },
  })

  vim.lsp.config("bashls", {
    filetypes = { "bash", "sh", "zsh" },
  })

  vim.lsp.config("jsonls", {
    -- lazy-load schemastore when needed
    before_init = function(_, new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = { enable = true },
        validate = { enable = true },
      },
    },
  })

  vim.lsp.config("yamlls", {
    -- Have to add this for yamlls to understand that we support line folding
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    -- lazy-load schemastore when needed
    before_init = function(_, new_config)
      new_config.settings.yaml.schemas =
        vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
    end,
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = { enable = true },
        validate = true,
        schemaStore = {
          -- Must disable built-in schemaStore support to use
          -- schemas from SchemaStore.nvim plugin
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
      },
    },
  })

  vim.lsp.config("taplo", {})
  vim.lsp.config("marksman", {})
  vim.lsp.config("pyright", {})
  vim.lsp.config("ruff", {})
  vim.lsp.config("vtsls", {})
  vim.lsp.config("tsgo", {})
  vim.lsp.config("html", {})
  vim.lsp.config("cssls", {})
  vim.lsp.config("eslint", {})
  vim.lsp.config("clangd", {})
  vim.lsp.config("gopls", {})
  vim.lsp.config("dockerls", {})
  vim.lsp.config("docker_compose_language_service", {})
  vim.lsp.config("powershell_es", {})
  vim.lsp.config("nushell", {})

  vim.lsp.enable({
    "lua_ls",
    "bashls",
    "jsonls",
    "yamlls",
    "taplo",
    "marksman",
    "pyright",
    "ruff",
    -- "vtsls",
    "tsgo",
    "html",
    "cssls",
    "eslint",
    "clangd",
    "gopls",
    "dockerls",
    "docker_compose_language_service",
    "powershell_es",
    "nushell",
  })

  new_autocmd("LspAttach", "*", function()
    local diagnostic_goto = function(next, severity)
      return function()
        vim.diagnostic.jump({
          count = (next and 1 or -1) * vim.v.count1,
          severity = severity and vim.diagnostic.severity[severity] or nil,
          float = true,
        })
      end
    end

    map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
    map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
    map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
    map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
    map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
    map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
    map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Actions" })
    map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
    map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

		-- stylua: ignore start
		map("n", "<leader>xq", function() vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen") end, { desc = "Quickfix list" })
		map("n", "<leader>xl", function() vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen") end, { desc = "Location list" })
    -- stylua: ignore end
  end)
end)

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
later(function()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      priority = 9999,
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
    float = { border = "rounded" },
  })
end)

-- Formatting =================================================================

now_if_args(function()
  add({ "https://github.com/stevearc/conform.nvim" })

  require("conform").setup({
    default_format_opts = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      fish = { "fish_indent" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      ["c++"] = { "clang-format" },
      xml = { "xmlformatter" },
      html = { "prettierd", "prettier", stop_after_first = true },
      handlebars = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      less = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      graphql = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      ["markdown"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc", stop_after_first = true },
      ["markdown.mdx"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc", stop_after_first = true },
    },
  })

  map("n", "<leader>cf", '<Cmd>lua require("conform").format()<CR>', { desc = "Format" })
  map("x", "<leader>cf", '<Cmd>lua require("conform").format()<CR>', { desc = "Format selection" })
end)

-- Linting ====================================================================

now_if_args(function()
  add({ "https://github.com/mfussenegger/nvim-lint" })

  require("lint").linters_by_ft = {
    -- sh = { "shellcheck" },
    zsh = { "zsh" },
    fish = { "fish" },
  }

  new_autocmd({ "BufWritePost" }, "*", function()
    require("lint").try_lint()
  end, "Lint current buffer")
end)
