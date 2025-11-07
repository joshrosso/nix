-- vim.cmd [[colorscheme catpuccin]]
vim.api.nvim_set_hl(0, "@type.builtin.go", { link = "Identifier" })

-- ===========================================
-- Vim Options
-- ===========================================
-- `:verbose options`: get available options and current values
-- vim.opt: user options
-- vim.go: global options
-- ===========================================
-- set <leader> to `;`
vim.g.mapleader = ';'
-- enable line numbers
vim.opt.number = true
-- highlight current line
vim.opt.cursorline = true
-- disable swap files
vim.opt.swapfile = false

-- ===========================================
-- Key Mappings
-- ===========================================
-- :help lua-keymap
-- :set({mode}, {lhs}, {rhs}, {opts})
-- {mode}:
   -- n - works recursively in normal mode.
   -- i - works recursively in insert mode.
   -- v - works recursively in visual and select modes.
   -- x - works recursively in visual mode.
   -- s - works recursively in select mode.
   -- c - works recursively in command-line mode.
   -- o - works recursively in operator pending mode.
   -- NOTE: use noremap in {opts} to make non-recursive
-- ===========================================
local bufopts = { noremap=true, silent=true, buffer=bufnr }
local builtin = require('telescope.builtin')

vim.keymap.set("n", "<leader>n", ":Neotree<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dd', ":TroubleToggle<CR>", bufopts)
vim.keymap.set('i', 'jj', "<Esc>", bufopts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, bufopts)
vim.keymap.set('n', '<leader>ff', builtin.find_files, bufopts)
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, bufopts)
vim.keymap.set('n', '<leader>fu', builtin.lsp_references, bufopts)
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, bufopts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)

-- ===========================================
-- LSP and Autocompletion
-- ===========================================
-- Config based on https://github.com/hrsh7th/nvim-cmp
-- ===========================================
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up LSP servers using the new vim.lsp.config API (Neovim 0.11+)
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
  "gopls",
  "terraformls",
  "rust_analyzer",
  "nil_ls"
}
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities
  })
  vim.lsp.enable(server)
end

-- Trouble config --
require("trouble").setup({})
local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open
-- Use this to add more results without clearing the trouble list
local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<c-t>"] = open_with_trouble },
      n = { ["<c-t>"] = open_with_trouble },
    },
  },
})

require('telescope').setup{
	defaults = {
		path_display={"smart"} 
	}
}

-- automatically do formatting via lsp, when possible
require("lsp-format").setup {}
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    require("lsp-format").on_attach(client, args.buf)
  end,
})

require("outline").setup({})

-- config to automatically update buffer when file is modified
vim.o.autoread = true
-- ensures that an arbitrary action, such as focusing on neovim, will trigger checktime, thus autoreading.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
})


vim.o.background = "dark"
vim.o.termguicolors = true
vim.wo.wrap = false
vim.cmd.colorscheme "catppuccin"
