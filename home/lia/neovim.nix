{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Build dependencies for treesitter
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nil  # Nix LSP
      pyright
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      marksman  # Markdown LSP

      # Formatters
      stylua
      nixpkgs-fmt
      black
      nodePackages.prettier
      shfmt

      # Treesitter compilers
      gcc
      gnumake
      nodejs

      # Other tools
      ripgrep
      fd
      git
    ];

    # Base configuration - you'll likely want to expand this
    # or use a Neovim distribution like LazyVim, AstroNvim, etc.
    extraLuaConfig = ''
      -- Basic settings
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      local opt = vim.opt

      -- Line numbers
      opt.number = true
      opt.relativenumber = true

      -- Tabs & indentation
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true
      opt.autoindent = true
      opt.smartindent = true

      -- Line wrapping
      opt.wrap = false

      -- Search
      opt.ignorecase = true
      opt.smartcase = true
      opt.hlsearch = true
      opt.incsearch = true

      -- Appearance
      opt.termguicolors = true
      opt.background = 'dark'
      opt.signcolumn = 'yes'
      opt.cursorline = true
      opt.scrolloff = 8
      opt.sidescrolloff = 8

      -- Behavior
      opt.hidden = true
      opt.errorbells = false
      opt.swapfile = false
      opt.backup = false
      opt.undofile = true
      opt.undodir = vim.fn.stdpath('data') .. '/undodir'

      -- Split windows
      opt.splitright = true
      opt.splitbelow = true

      -- Clipboard
      opt.clipboard = 'unnamedplus'

      -- Update time
      opt.updatetime = 250
      opt.timeoutlen = 300

      -- Mouse
      opt.mouse = 'a'

      -- Completion
      opt.completeopt = 'menuone,noselect'

      -- Basic keymaps
      local keymap = vim.keymap.set

      -- Better window navigation
      keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
      keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
      keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
      keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

      -- Clear search highlight
      keymap('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

      -- Better indenting
      keymap('v', '<', '<gv')
      keymap('v', '>', '>gv')

      -- Move lines
      keymap('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
      keymap('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

      -- Diagnostic keymaps
      keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
      keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

      -- NOTE: This is a minimal config. You probably want to use a plugin manager
      -- like lazy.nvim and set up plugins for:
      -- - Treesitter (nvim-treesitter)
      -- - LSP (nvim-lspconfig)
      -- - Completion (nvim-cmp)
      -- - File explorer (neo-tree or oil.nvim)
      -- - Fuzzy finder (telescope.nvim)
      -- - Git (gitsigns.nvim, neogit)
      -- - Theme (rose-pine)
      --
      -- Consider using a distribution like LazyVim, AstroNvim, or NvChad
      -- for a more complete setup, or create your own ~/.config/nvim/
    '';
  };

  # Create a starter init.lua that can bootstrap lazy.nvim
  # This file will only be used if you don't have your own config
  xdg.configFile."nvim/lua/plugins/init.lua".text = ''
    -- Placeholder for your plugins
    -- You can add your plugin configurations here
    return {}
  '';
}
