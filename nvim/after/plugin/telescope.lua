-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        -- layout_strategy = 'vertical',
        layout_config = {
            width = 0.95,
            height = 0.95,
        },
        mappings = {
            i = {
                ["<RightMouse>"] = actions.close,
                ["<esc>"] = actions.close,
                ["<LeftMouse>"] = actions.select_default,
                ["<ScrollWheelDown>"] = actions.move_selection_next,
                ["<ScrollWheelUp>"] = actions.move_selection_previous,
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')


local builtin = require('telescope.builtin')
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
    layout_config = {
      width = 0.8,
      height = 0.85,
      prompt_position = "top",
      horizontal = {
        preview_width = function(_, cols, _)
          return math.floor(cols * 0.4)
        end,
      },

      vertical = {
        width = 0.8,
        height = 0.85,
        preview_height = 0.35,
      },

      flex = {
        horizontal = {
          preview_width = 0.8,
        },
      },
    },
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sm', ":Telescope harpoon marks<CR>", { desc = 'Harpoon [M]arks' })
-- maybe remove this?
vim.keymap.set('n', '<leader>ss', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

local M = {}

M.get_path_and_tail = function(filename)
  local utils = require('telescope.utils')
  local bufname_tail = utils.path_tail(filename)
  local path_without_tail = require('plenary.strings').truncate(filename, #filename - #bufname_tail, '')
  local path_to_display = utils.transform_path({
    path_display = { 'truncate' },
  }, path_without_tail)

  return bufname_tail, path_to_display
end

M.project_files = function(opts, search_function)
  local make_entry = require('telescope.make_entry')
  local strings = require('plenary.strings')
  local utils = require('telescope.utils')
  local entry_display = require('telescope.pickers.entry_display')
  local devicons = require('nvim-web-devicons')
  local def_icon = devicons.get_icon('fname', { default = true })
  local iconwidth = strings.strdisplaywidth(def_icon)

  local map_i_actions = function(prompt_bufnr, map)
    map('i', '<C-o>', function()
      require('libs.telescope.picker_keymaps').open_selected_in_window(prompt_bufnr)
    end, { noremap = true, silent = true })
  end

  opts = opts or {}
  opts.hidden = true

  opts.attach_mappings = function(_, map)
    map_i_actions(_, map)
    return true
  end

  local entry_make = make_entry.gen_from_file(opts)
  opts.entry_maker = function(line)
    local entry = entry_make(line)
    local displayer = entry_display.create({
      separator = ' ',
      items = {
        { width = iconwidth },
        { width = nil },
        { remaining = true },
      },
    })
    entry.display = function(et)
      local tail_raw, path_to_display = M.get_path_and_tail(et.value)
      local tail = tail_raw .. ' '
      local icon, iconhl = utils.get_devicons(tail_raw)

      return displayer({
        { icon, iconhl },
        tail,
        { path_to_display, 'TelescopeResultsComment' },
      })
    end
    return entry
  end

  if opts and opts.oldfiles then
    local cache_opts = vim.tbl_deep_extend('force', {
    }, opts)
    local cycle = require('libs.telescope.cycle')(
      function(income_opts)
        require('telescope.builtin').find_files(vim.tbl_extend('force', cache_opts, {
          results_title = '  All Files: ',
        }, income_opts))
      end
    )
    opts = vim.tbl_extend('force', {
      results_title = '  Recent files: ',
      prompt_title = '  Recent files',
      attach_mappings = function(_, map)
        map_i_actions(_, map)
        map('i', '<C-b>', cycle.next, { noremap = true, silent = true })
        return true
      end
    }, opts)
    return require('telescope.builtin').oldfiles(opts)
  end

  search_function(opts)
end

function M.buffers_or_recent()
  local count = #vim.fn.getbufinfo({ buflisted = 1 })
  if count <= 1 then
    --- open recent.
    M.project_files({
      cwd_only = true,
      oldfiles = true,
    })
    return
  end
  return M.buffers()
end

function M.buffers()
  local actionstate = require('telescope.actions.state')
  -- local Buffer = require('libs.runtime.buffer')

  builtin.buffers({
    ignore_current_buffer = true,
    sort_mru = true,
    -- layout_strategy = 'vertical',
    layout_strategy = "bottom_pane",
    entry_maker = M.gen_from_buffer({
      bufnr_width = 2,
      sort_mru = true,
    }),
    attach_mappings = function(prompt_bufnr, map)
      local close_buf = function()
        local selection = actionstate.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_buf_delete(selection.bufnr, { force = false })
        local state = require('telescope.state')
        local cached_pickers = state.get_global_key('cached_pickers') or {}
        -- remove this picker cache
        table.remove(cached_pickers, 1)
      end

      local open_selected = function()
        local entry = actionstate.get_selected_entry()
        actions.close(prompt_bufnr)
        if not entry or (not entry.bufnr) then
          vim.notify("no selected entry found")
          return
        end
        local bufnr = entry.bufnr
        -- Buffer.set_current_buffer_focus(bufnr)
        vim.api.nvim_set_current_buf(bufnr)
      end

      map('i', '<C-h>', close_buf)
      map('i', '<CR>', open_selected)

      return true
    end,
  })
end

function M.gen_from_buffer(opts)
  local utils = require('telescope.utils')
  local strings = require('plenary.strings')
  local entry_display = require('telescope.pickers.entry_display')
  local Path = require('plenary.path')
  local make_entry = require('telescope.make_entry')

  opts = opts or {}

  local disable_devicons = opts.disable_devicons

  local icon_width = 0
  if not disable_devicons then
    local icon, _ = utils.get_devicons('fname', disable_devicons)
    icon_width = strings.strdisplaywidth(icon)
  end

  local cwd = vim.fn.expand(opts.cwd or ".")

  local make_display = function(entry)
    -- bufnr_width + modes + icon + 3 spaces + : + lnum
    opts.__prefix = opts.bufnr_width + 4 + icon_width + 3 + 1 + #tostring(entry.lnum)
    local bufname_tail = utils.path_tail(entry.filename)
    local path_without_tail = require('plenary.strings').truncate(entry.filename, #entry.filename - #bufname_tail, '')
    local path_to_display = utils.transform_path({
      path_display = { 'truncate' },
    }, path_without_tail)
    local bufname_width = strings.strdisplaywidth(bufname_tail)
    local icon, hl_group = utils.get_devicons(entry.filename, disable_devicons)

    local displayer = entry_display.create({
      separator = ' ',
      items = {
        { width = opts.bufnr_width },
        { width = 4 },
        { width = icon_width },
        { width = bufname_width },
        { remaining = true },
      },
    })

    return displayer({
      { entry.bufnr, 'TelescopeResultsNumber' },
      { entry.indicator, 'TelescopeResultsComment' },
      { icon, hl_group },
      bufname_tail,
      { path_to_display .. ':' .. entry.lnum, 'TelescopeResultsComment' },
    })
  end

  return function(entry)
    local bufname = entry.info.name ~= '' and entry.info.name or '[No Name]'
    -- if bufname is inside the cwd, trim that part of the string
    bufname = Path:new(bufname):normalize(cwd)

    local hidden = entry.info.hidden == 1 and 'h' or 'a'
    -- local readonly = vim.api.nvim_buf_get_option(entry.bufnr, 'readonly') and '=' or ' '
    local readonly = vim.api.nvim_get_option_value('readonly', {
      buf = entry.bufnr,
    }) and '=' or ' '
    local changed = entry.info.changed == 1 and '+' or ' '
    local indicator = entry.flag .. hidden .. readonly .. changed
    local lnum = 1

    -- account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker
    if entry.info.lnum ~= 0 then
      -- but make sure the buffer is loaded, otherwise line_count is 0
      if vim.api.nvim_buf_is_loaded(entry.bufnr) then
        local line_count = vim.api.nvim_buf_line_count(entry.bufnr)
        lnum = math.max(math.min(entry.info.lnum, line_count), 1)
      else
        lnum = entry.info.lnum
      end
    end

    return make_entry.set_default_entry_mt({
      value = bufname,
      ordinal = entry.bufnr .. ' : ' .. bufname,
      display = make_display,
      bufnr = entry.bufnr,
      filename = bufname,
      lnum = lnum,
      indicator = indicator,
    }, opts)
  end
end


vim.keymap.set('n', '<leader>sb', M.buffers_or_recent, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>sf', function()
    local opts = {}
    M.project_files(opts, builtin.find_files)
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>?', function()
    local opts = {}
    M.project_files(opts, builtin.oldfiles)
end, { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<leader>sp', function()
    local opts = {}
    M.project_files(opts, builtin.git_files)
end, { desc = '[S]earch git [P]roject' })

return M

-- vim.keymap.set("n", "<Leader>sr", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
-- vim.keymap.set("n", "<Leader>sR", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", silent)
