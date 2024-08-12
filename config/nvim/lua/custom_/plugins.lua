local plugins = {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<leader>cW", function () require('metals').hover_worksheet() end, desc = "Metals Worksheet" },
      { "<leader>cM", function () require('telescope').extensions.metals.commands() end, desc = "Telescope Metals Commands" },
    },
    init = function()
      local metals_config = require("metals").bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
      }
      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "debugpy",
        "mypy",
        "ruff",
        "pyright",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
{
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer', -- source for text in buffer
      'hrsh7th/cmp-path', -- source for file system paths
      'L3MON4D3/LuaSnip', -- snippet engine
      'saadparwaiz1/cmp_luasnip', -- for autocompletion
      'rafamadriz/friendly-snippets', -- useful snippets
      'onsails/lspkind.nvim', -- vs-code like pictograms
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require('cmp')

      local luasnip = require('luasnip')

      local lspkind = require('lspkind')

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        completion = {
          completeopt = 'menu,menuone,preview,noselect',
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
          ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
          ['<C-e>'] = cmp.mapping.abort(), -- close completion window
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- snippets
          { name = 'buffer' }, -- text within current buffer
          { name = 'path' }, -- file system paths
        }),

        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = '...',
          }),
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end,
  },
}
return plugins
