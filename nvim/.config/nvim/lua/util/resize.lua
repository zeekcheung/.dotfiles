local M = {}

-- Smart resize current window
---@param direction "up" | "down" | "left" | "right"
---@param step_size? number
function M.smart_resize(direction, step_size)
    table.unpack = table.unpack or unpack
    local current_window = vim.api.nvim_get_current_win()
    -- Get current window position
    local position = vim.api.nvim_win_get_position(current_window)
    local row, col = table.unpack(position)
    local in_top_left = row == 0 and col == 0
    local in_top_right = row == 0 and col ~= 0
    local in_bottom_left = row ~= 0 and col == 0
    local in_bottom_right = row ~= 0 and col ~= 0

    -- Get current window dimensions
    local current_window_width = vim.api.nvim_win_get_width(current_window)
    local current_window_height = vim.api.nvim_win_get_height(current_window)

    -- Get resize target direction
    local to_up = direction == "up"
    local to_down = direction == "down"
    local to_left = direction == "left"
    local to_right = direction == "right"

    step_size = step_size or 1

    -- stylua: ignore start
    local function add_width() vim.api.nvim_win_set_width(current_window, current_window_width + step_size) end
    local function sub_width() vim.api.nvim_win_set_width(current_window, current_window_width - step_size) end
    local function add_height() vim.api.nvim_win_set_height(current_window, current_window_height + step_size) end
    local function sub_height() vim.api.nvim_win_set_height(current_window, current_window_height - step_size) end
    -- stylua: ignore end

    -- Resize current window
    if ((in_top_left or in_bottom_left) and to_left) or ((in_top_right or in_bottom_right) and to_right) then
        sub_width()
    elseif ((in_top_left or in_bottom_left) and to_right) or ((in_top_right or in_bottom_right) and to_left) then
        add_width()
    elseif ((in_top_left or in_top_right) and to_up) or ((in_bottom_left or in_bottom_right) and to_down) then
        sub_height()
    elseif ((in_top_left or in_top_right) and to_down) or ((in_bottom_left or in_bottom_right) and to_up) then
        add_height()
    end
end

return M
