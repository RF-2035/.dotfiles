return {
  -- ┌────────────┐
  -- │ Completion │
  -- └────────────┘
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            -- NOTE: <Tab> or <C-]> → complete, <C-[> → dismiss
            -- NOTE: <M-]> → next, <M-[> → previous
            accept = '<C-]>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-[>',
            toggle_auto_trigger = false,
          },
        },
        filetypes = {
          ['*'] = true,
        },
      }
      -- NOTE: <leader>cc → copilot panel
      vim.keymap.set('n', '<leader>cc', function()
        vim.cmd 'Copilot panel'
      end, { desc = 'Completions', silent = true })
    end,
  },
  -- ┌────────────────────────────┐
  -- │ NES (Next Edit Suggestion) │
  -- └────────────────────────────┘
  {
    'copilotlsp-nvim/copilot-lsp',
  },
  -- ┌─────────────────────────┐
  -- │ NES & Agent Integration │
  -- └─────────────────────────┘
  {
    'folke/sidekick.nvim',
    opts = {
      cli = {
        mux = {
          enabled = true,
          backend = 'tmux',
        },
      },
    },

    keys = {
      {
        '<c-]>',
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require('sidekick').nes_jump_or_apply() then
            return '<c-]>' -- fallback to normal <c-]>
          end
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      {
        '<c-.>',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Sidekick Toggle',
        mode = { 'n', 't', 'i', 'x' },
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Toggle',
      },
      {
        '<leader>as',
        function()
          require('sidekick.cli').select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = 'Select',
      },
      {
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        desc = 'Detach',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send { msg = '{this}' }
        end,
        mode = { 'x', 'n' },
        desc = 'This',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send { msg = '{file}' }
        end,
        desc = 'File',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send { msg = '{selection}' }
        end,
        mode = { 'x' },
        desc = 'Visual Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'x' },
        desc = 'Prompt',
      },
      {
        '<leader>ag',
        function()
          require('sidekick.cli').toggle { name = 'gemini', focus = true }
        end,
        desc = 'Gemini',
      },
    },
  },
}
