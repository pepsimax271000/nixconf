{ inputs, ... }:
{
  flake.homeModules.neovim =
    { config, ... }:
    {
      imports = [ 
      	inputs.nixvim.homeModules.nixvim
      ];
      programs.nixvim = {
        enable = true;

        # ---------- Core options ----------
        #opts = {
        #  number = true;
        #  relativenumber = true;
        #  signcolumn = "yes";
        #  cursorline = true;
        #  wrap = false;
        #  scrolloff = 8;
        #  sidescrolloff = 8;
        #  tabstop = 2;
        #  shiftwidth = 2;
        #  expandtab = true;
        #  smartindent = true;
        #  termguicolors = true;
        #  splitright = true;
        #  splitbelow = true;
        #  ignorecase = true;
        #  smartcase = true;
        #  hlsearch = true;
        #  incsearch = true;
        #  undofile = true;
        #  swapfile = false;
        #  backup = false;
        #  updatetime = 200;
        #  timeoutlen = 300;
        #  completeopt = [
        #    "menu"
        #    "menuone"
        #    "noselect"
        #  ];
        #  fileencoding = "utf-8";
        #  pumheight = 10;
        #  showmode = false;
        #  laststatus = 3;
        #  guifont = "JetBrainsMono Nerd Font:h13";
        #};

        #globals = {
        #  mapleader = " ";
        #  maplocalleader = "\\";
        #};

        ## ---------- Catppuccin Mocha ----------
        #colorschemes.catppuccin = {
        #  enable = true;
        #  settings = {
        #    flavour = "mocha";
        #    transparent_background = false;
        #    show_end_of_buffer = false;
        #    term_colors = true;
        #    dim_inactive = {
        #      enabled = true;
        #      shade = "dark";
        #      percentage = 0.15;
        #    };
        #    integrations = {
        #      cmp = true;
        #      gitsigns = true;
        #      nvimtree = true;
        #      treesitter = true;
        #      telescope.enabled = true;
        #      which_key = true;
        #      indent_blankline.enabled = true;
        #      mini.enabled = true;
        #      lsp_trouble = true;
        #      mason = true;
        #      noice = true;
        #      notify = true;
        #      bufferline = true;
        #    };
        #  };
        #};

        ## ---------- Keymaps ----------
        #keymaps = [
        #  {
        #    mode = "n";
        #    key = "<C-h>";
        #    action = "<C-w>h";
        #    options.desc = "Move to left window";
        #  }
        #  {
        #    mode = "n";
        #    key = "<C-j>";
        #    action = "<C-w>j";
        #    options.desc = "Move to lower window";
        #  }
        #  {
        #    mode = "n";
        #    key = "<C-k>";
        #    action = "<C-w>k";
        #    options.desc = "Move to upper window";
        #  }
        #  {
        #    mode = "n";
        #    key = "<C-l>";
        #    action = "<C-w>l";
        #    options.desc = "Move to right window";
        #  }
        #  {
        #    mode = "n";
        #    key = "<C-Up>";
        #    action = ":resize -2<CR>";
        #    options.silent = true;
        #  }
        #  {
        #    mode = "n";
        #    key = "<C-Down>";
        #    action = ":resize +2<CR>";
        #    options.silent = true;
        #  }
        #  {
        #    mode = "n";
        #    key = "<C-Left>";
        #    action = ":vertical resize -2<CR>";
        #    options.silent = true;
        #  }
        #  {
        #    mode = "n";
        #    key = "<C-Right>";
        #    action = ":vertical resize +2<CR>";
        #    options.silent = true;
        #  }
        #  {
        #    mode = "n";
        #    key = "<Tab>";
        #    action = ":bnext<CR>";
        #    options.silent = true;
        #    options.desc = "Next buffer";
        #  }
        #  {
        #    mode = "n";
        #    key = "<S-Tab>";
        #    action = ":bprevious<CR>";
        #    options.silent = true;
        #    options.desc = "Prev buffer";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>bd";
        #    action = ":bdelete<CR>";
        #    options.silent = true;
        #    options.desc = "Delete buffer";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>e";
        #    action = ":NvimTreeToggle<CR>";
        #    options.silent = true;
        #    options.desc = "Toggle file tree";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>ff";
        #    action = ":Telescope find_files<CR>";
        #    options.desc = "Find files";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>fg";
        #    action = ":Telescope live_grep<CR>";
        #    options.desc = "Live grep";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>fb";
        #    action = ":Telescope buffers<CR>";
        #    options.desc = "Buffers";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>fh";
        #    action = ":Telescope help_tags<CR>";
        #    options.desc = "Help tags";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>fr";
        #    action = ":Telescope oldfiles<CR>";
        #    options.desc = "Recent files";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>fc";
        #    action = ":Telescope commands<CR>";
        #    options.desc = "Commands";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>fs";
        #    action = ":Telescope lsp_document_symbols<CR>";
        #    options.desc = "Document symbols";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>/";
        #    action = ":Telescope current_buffer_fuzzy_find<CR>";
        #    options.desc = "Fuzzy find in buffer";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>ca";
        #    action = ":lua vim.lsp.buf.code_action()<CR>";
        #    options.desc = "Code action";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>rn";
        #    action = ":lua vim.lsp.buf.rename()<CR>";
        #    options.desc = "Rename symbol";
        #  }
        #  {
        #    mode = "n";
        #    key = "gd";
        #    action = ":lua vim.lsp.buf.definition()<CR>";
        #    options.desc = "Go to definition";
        #  }
        #  {
        #    mode = "n";
        #    key = "gr";
        #    action = ":Telescope lsp_references<CR>";
        #    options.desc = "References";
        #  }
        #  {
        #    mode = "n";
        #    key = "K";
        #    action = ":lua vim.lsp.buf.hover()<CR>";
        #    options.desc = "Hover docs";
        #  }
        #  {
        #    mode = "n";
        #    key = "[d";
        #    action = ":lua vim.diagnostic.goto_prev()<CR>";
        #    options.desc = "Prev diagnostic";
        #  }
        #  {
        #    mode = "n";
        #    key = "]d";
        #    action = ":lua vim.diagnostic.goto_next()<CR>";
        #    options.desc = "Next diagnostic";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>df";
        #    action = ":lua vim.diagnostic.open_float()<CR>";
        #    options.desc = "Diagnostic float";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>dl";
        #    action = ":Telescope diagnostics<CR>";
        #    options.desc = "Diagnostics list";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>lf";
        #    action = ":lua vim.lsp.buf.format({ async = true })<CR>";
        #    options.desc = "Format file";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>gs";
        #    action = ":Gitsigns stage_hunk<CR>";
        #    options.desc = "Stage hunk";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>gr";
        #    action = ":Gitsigns reset_hunk<CR>";
        #    options.desc = "Reset hunk";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>gp";
        #    action = ":Gitsigns preview_hunk<CR>";
        #    options.desc = "Preview hunk";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>gb";
        #    action = ":Gitsigns blame_line<CR>";
        #    options.desc = "Blame line";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>h";
        #    action = ":nohlsearch<CR>";
        #    options.silent = true;
        #    options.desc = "Clear highlights";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>q";
        #    action = ":q<CR>";
        #    options.desc = "Quit";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>w";
        #    action = ":w<CR>";
        #    options.desc = "Save";
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>Q";
        #    action = ":qa!<CR>";
        #    options.desc = "Force quit all";
        #  }
        #  {
        #    mode = "v";
        #    key = "<";
        #    action = "<gv";
        #  }
        #  {
        #    mode = "v";
        #    key = ">";
        #    action = ">gv";
        #  }
        #  {
        #    mode = "v";
        #    key = "<A-j>";
        #    action = ":move '>+1<CR>gv=gv";
        #    options.silent = true;
        #  }
        #  {
        #    mode = "v";
        #    key = "<A-k>";
        #    action = ":move '<-2<CR>gv=gv";
        #    options.silent = true;
        #  }
        #  {
        #    mode = "n";
        #    key = "<leader>tt";
        #    action = ":ToggleTerm<CR>";
        #    options.desc = "Toggle terminal";
        #  }
        #  {
        #    mode = "t";
        #    key = "<Esc>";
        #    action = "<C-\\><C-n>";
        #    options.desc = "Exit terminal mode";
        #  }
        #];

        ## ---------- Plugins ----------
        #plugins = {

        #  lualine = {
        #    enable = true;
        #    settings = {
        #      options = {
        #        theme = "catppuccin";
        #        globalstatus = true;
        #        disabled_filetypes.statusline = [
        #          "dashboard"
        #          "alpha"
        #        ];
        #        component_separators = {
        #          left = "";
        #          right = "";
        #        };
        #        section_separators = {
        #          left = "";
        #          right = "";
        #        };
        #      };
        #      sections = {
        #        lualine_a = [ "mode" ];
        #        lualine_b = [
        #          "branch"
        #          "diff"
        #          "diagnostics"
        #        ];
        #        lualine_c = [
        #          {
        #            name = "filename";
        #            extraConfig.path = 1;
        #          }
        #        ];
        #        lualine_x = [
        #          "encoding"
        #          "fileformat"
        #          "filetype"
        #        ];
        #        lualine_y = [ "progress" ];
        #        lualine_z = [ "location" ];
        #      };
        #    };
        #  };

        #  bufferline = {
        #    enable = true;
        #    settings.options = {
        #      mode = "buffers";
        #      separator_style = "slant";
        #      always_show_bufferline = true;
        #      show_buffer_close_icons = true;
        #      show_close_icon = false;
        #      color_icons = true;
        #      diagnostics = "nvim_lsp";
        #    };
        #  };

        #  nvim-tree = {
        #    enable = true;
        #    settings = {
        #      view.width = 30;
        #      renderer.group_empty = true;
        #      filters.dotfiles = false;
        #      git.enable = true;
        #    };
        #  };

        #  which-key = {
        #    enable = true;
        #    settings = {
        #      delay = 300;
        #      expand = 1;
        #      spec = [
        #        {
        #          __unkeyed-1 = "<leader>f";
        #          group = "Find / Telescope";
        #        }
        #        {
        #          __unkeyed-1 = "<leader>g";
        #          group = "Git";
        #        }
        #        {
        #          __unkeyed-1 = "<leader>l";
        #          group = "LSP";
        #        }
        #        {
        #          __unkeyed-1 = "<leader>t";
        #          group = "Terminal";
        #        }
        #        {
        #          __unkeyed-1 = "<leader>b";
        #          group = "Buffer";
        #        }
        #        {
        #          __unkeyed-1 = "<leader>d";
        #          group = "Diagnostics";
        #        }
        #        {
        #          __unkeyed-1 = "<leader>x";
        #          group = "Trouble";
        #        }
        #      ];
        #    };
        #  };

        #  noice = {
        #    enable = true;
        #    settings = {
        #      lsp.override = {
        #        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        #        "vim.lsp.util.stylize_markdown" = true;
        #        "cmp.entry.get_documentation" = true;
        #      };
        #      presets = {
        #        bottom_search = true;
        #        command_palette = true;
        #        long_message_to_split = true;
        #        inc_rename = false;
        #        lsp_doc_border = false;
        #      };
        #    };
        #  };

        #  notify = {
        #    enable = true;
        #    settings.background_colour = "#1e1e2e";
        #  };

        #  dashboard = {
        #    enable = true;
        #    settings.config = {
        #      header = [
        #        ""
        #        "  ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
        #        "  ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
        #        "  ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
        #        "  ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
        #        "  ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
        #        "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        #        ""
        #      ];
        #      shortcut = [
        #        {
        #          desc = "  Find file";
        #          group = "DiagnosticHint";
        #          action = "Telescope find_files";
        #          key = "f";
        #        }
        #        {
        #          desc = "  Recent";
        #          group = "DiagnosticInfo";
        #          action = "Telescope oldfiles";
        #          key = "r";
        #        }
        #        {
        #          desc = "  Config";
        #          group = "DiagnosticWarn";
        #          action = "e ~/.config/nvim/init.lua";
        #          key = "c";
        #        }
        #        {
        #          desc = "  Quit";
        #          group = "DiagnosticError";
        #          action = "qa";
        #          key = "q";
        #        }
        #      ];
        #    };
        #  };

        #  indent-blankline = {
        #    enable = true;
        #    settings = {
        #      indent.char = "│";
        #      scope.enabled = true;
        #      scope.show_start = true;
        #      scope.show_end = false;
        #    };
        #  };

        #  telescope = {
        #    enable = true;
        #    settings.defaults = {
        #      prompt_prefix = "  ";
        #      selection_caret = " ";
        #      path_display = [ "truncate" ];
        #      sorting_strategy = "ascending";
        #      layout_config.horizontal.prompt_position = "top";
        #      file_ignore_patterns = [
        #        "node_modules"
        #        ".git/"
        #        "__pycache__"
        #        ".direnv"
        #        "result"
        #      ];
        #    };
        #    extensions.fzf-native.enable = true;
        #  };

        #  treesitter = {
        #    enable = true;
        #    settings = {
        #      highlight.enable = true;
        #      indent.enable = true;
        #      incremental_selection.enable = true;
        #      auto_install = false;
        #    };
        #    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        #      bash
        #      c
        #      cpp
        #      css
        #      dockerfile
        #      elixir
        #      go
        #      hcl
        #      html
        #      javascript
        #      json
        #      lua
        #      markdown
        #      markdown_inline
        #      nix
        #      python
        #      rust
        #      sql
        #      toml
        #      typescript
        #      vim
        #      vimdoc
        #      yaml
        #      zig
        #    ];
        #  };

        #  treesitter-context = {
        #    enable = true;
        #    settings = {
        #      max_lines = 3;
        #      min_window_height = 0;
        #      trim_scope = "outer";
        #    };
        #  };

        #  lsp = {
        #    enable = true;
        #    servers = {
        #      lua_ls = {
        #        enable = true;
        #        settings.Lua = {
        #          diagnostics.globals = [ "vim" ];
        #          workspace.checkThirdParty = false;
        #        };
        #      };
        #      nixd = {
        #        enable = true;
        #      };
        #      ts_ls = {
        #        enable = true;
        #      };
        #      rust_analyzer = {
        #        enable = true;
        #        settings.check.command = "clippy";
        #      };
        #      pyright = {
        #        enable = true;
        #      };
        #      bashls = {
        #        enable = true;
        #      };
        #      html = {
        #        enable = true;
        #      };
        #      cssls = {
        #        enable = true;
        #      };
        #      jsonls = {
        #        enable = true;
        #      };
        #      yamlls = {
        #        enable = true;
        #      };
        #      gopls = {
        #        enable = true;
        #      };
        #      clangd = {
        #        enable = true;
        #      };
        #      taplo = {
        #        enable = true;
        #      };
        #      zls = {
        #        enable = true;
        #      };
        #    };
        #    keymaps.lspBuf = {
        #      "gD" = "declaration";
        #      "gi" = "implementation";
        #      "<leader>ls" = "signature_help";
        #      "<leader>lt" = "type_definition";
        #    };
        #  };

        #  lsp-format.enable = true;

        #  trouble = {
        #    enable = true;
        #    settings = {
        #      position = "bottom";
        #      icons = true;
        #      fold_open = "";
        #      fold_closed = "";
        #      auto_open = false;
        #      auto_close = false;
        #      use_diagnostic_signs = true;
        #    };
        #  };

        #  cmp = {
        #    enable = true;
        #    settings = {
        #      snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        #      mapping = {
        #        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        #        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        #        "<C-Space>" = "cmp.mapping.complete()";
        #        "<C-e>" = "cmp.mapping.abort()";
        #        "<CR>" = "cmp.mapping.confirm({ select = true })";
        #        "<Tab>" = ''
        #          cmp.mapping(function(fallback)
        #            if cmp.visible() then cmp.select_next_item()
        #            elseif require('luasnip').expand_or_jumpable() then require('luasnip').expand_or_jump()
        #            else fallback() end
        #          end, { "i", "s" })
        #        '';
        #        "<S-Tab>" = ''
        #          cmp.mapping(function(fallback)
        #            if cmp.visible() then cmp.select_prev_item()
        #            elseif require('luasnip').jumpable(-1) then require('luasnip').jump(-1)
        #            else fallback() end
        #          end, { "i", "s" })
        #        '';
        #      };
        #      sources = [
        #        { name = "nvim_lsp"; }
        #        { name = "luasnip"; }
        #        { name = "buffer"; }
        #        { name = "path"; }
        #      ];
        #      formatting.fields = [
        #        "kind"
        #        "abbr"
        #        "menu"
        #      ];
        #      window = {
        #        completion.border = "rounded";
        #        documentation.border = "rounded";
        #      };
        #      experimental.ghost_text = true;
        #    };
        #  };

        #  cmp-nvim-lsp.enable = true;
        #  cmp-buffer.enable = true;
        #  cmp-path.enable = true;
        #  cmp_luasnip.enable = true;

        #  luasnip = {
        #    enable = true;
        #    settings.history = true;
        #    settings.update_events = "TextChanged,TextChangedI";
        #    fromVscode.enable = true;
        #  };

        #  friendly-snippets.enable = true;

        #  nvim-autopairs = {
        #    enable = true;
        #    settings.check_ts = true;
        #  };

        #  nvim-surround.enable = true;
        #  comment.enable = true;

        #  gitsigns = {
        #    enable = true;
        #    settings = {
        #      signs = {
        #        add.text = "▎";
        #        change.text = "▎";
        #        delete.text = "▶";
        #        topdelete.text = "▶";
        #        changedelete.text = "~";
        #        untracked.text = "▎";
        #      };
        #      current_line_blame = false;
        #      sign_priority = 6;
        #      update_debounce = 100;
        #    };
        #  };

        #  mini = {
        #    enable = true;
        #    modules = {
        #      ai = { };
        #      pairs = { };
        #      move = { };
        #      trailspace = { };
        #      animate = { };
        #      hipatterns = { };
        #    };
        #  };

        #  toggleterm = {
        #    enable = true;
        #    settings = {
        #      size = 20;
        #      direction = "float";
        #      float_opts.border = "curved";
        #      open_mapping = "[[<c-\\>]]";
        #      shade_terminals = true;
        #      close_on_exit = true;
        #      shell = "fish"; # change to "bash" or "zsh" if needed
        #    };
        #  };

        #  web-devicons.enable = true;

        #  todo-comments = {
        #    enable = true;
        #    settings.signs = true;
        #  };

        #  flash = {
        #    enable = true;
        #    settings.modes.char.jump_labels = true;
        #  };

        #  illuminate = {
        #    enable = true;
        #    settings.delay = 200;
        #  };

        #  conform-nvim = {
        #    enable = true;
        #    settings = {
        #      formatters_by_ft = {
        #        lua = [ "stylua" ];
        #        python = [
        #          "isort"
        #          "black"
        #        ];
        #        javascript = [
        #          [
        #            "prettierd"
        #            "prettier"
        #          ]
        #        ];
        #        typescript = [
        #          [
        #            "prettierd"
        #            "prettier"
        #          ]
        #        ];
        #        nix = [ "alejandra" ];
        #        rust = [ "rustfmt" ];
        #        go = [ "gofmt" ];
        #        sh = [ "shfmt" ];
        #        "*" = [ "trim_whitespace" ];
        #      };
        #      format_on_save = {
        #        timeout_ms = 500;
        #        lsp_fallback = true;
        #      };
        #    };
        #  };

        #}; # end plugins

        ## ---------- Extra packages ----------
        #extraPackages = with pkgs; [
        #  nodePackages.typescript-language-server
        #  nodePackages.vscode-langservers-extracted
        #  nodePackages.yaml-language-server
        #  lua-language-server
        #  nixd
        #  rust-analyzer
        #  gopls
        #  pyright
        #  bash-language-server
        #  taplo
        #  zls
        #  clang-tools
        #  stylua
        #  nodePackages.prettier
        #  alejandra
        #  black
        #  isort
        #  rustfmt
        #  shfmt
        #  gofmt
        #  ripgrep
        #  fd
        #  git
        #];

        ## ---------- Extra Lua ----------
        #extraConfigLua = ''
        #  -- Diagnostic signs
        #  local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        #  for type, icon in pairs(signs) do
        #    local hl = "DiagnosticSign" .. type
        #    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        #  end

        #  vim.diagnostic.config({
        #    virtual_text     = { prefix = "●" },
        #    update_in_insert = false,
        #    underline        = true,
        #    severity_sort    = true,
        #    float            = { border = "rounded", source = "always" },
        #  })

        #  -- Rounded borders on all LSP floats
        #  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        #  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        #    opts = opts or {}
        #    opts.border = opts.border or "rounded"
        #    return orig_util_open_floating_preview(contents, syntax, opts, ...)
        #  end

        #  -- Highlight on yank
        #  vim.api.nvim_create_autocmd("TextYankPost", {
        #    callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 }) end,
        #  })

        #  -- Auto-close nvim-tree if it is the last window
        #  vim.api.nvim_create_autocmd("QuitPre", {
        #    callback = function()
        #      local wins = vim.api.nvim_list_wins()
        #      local real = vim.tbl_filter(function(w)
        #        return vim.bo[vim.api.nvim_win_get_buf(w)].buftype == ""
        #      end, wins)
        #      if #real == 1 then
        #        local info = vim.fn.getbufinfo({ buflisted = 0 })
        #        for _, buf in ipairs(info) do
        #          if vim.bo[buf.bufnr].filetype == "NvimTree" then
        #            vim.api.nvim_buf_delete(buf.bufnr, { force = true })
        #          end
        #        end
        #      end
        #    end,
        #  })

        #  -- Open dashboard when all buffers are closed
        #  vim.api.nvim_create_autocmd("BufDelete", {
        #    callback = function()
        #      local bufs = vim.tbl_filter(function(b)
        #        return vim.bo[b].buflisted
        #      end, vim.api.nvim_list_bufs())
        #      if #bufs == 0 then vim.cmd("Dashboard") end
        #    end,
        #  })

        #  -- Restore cursor position
        #  vim.api.nvim_create_autocmd("BufReadPost", {
        #    callback = function()
        #      local mark = vim.api.nvim_buf_get_mark(0, '"')
        #      if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
        #        pcall(vim.api.nvim_win_set_cursor, 0, mark)
        #      end
        #    end,
        #  })

        #  -- Filetype overrides
        #  vim.api.nvim_create_autocmd("FileType", {
        #    pattern  = { "gitcommit", "markdown" },
        #    callback = function()
        #      vim.opt_local.wrap  = true
        #      vim.opt_local.spell = true
        #    end,
        #  })

        #  -- Flash
        #  vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump()       end, { desc = "Flash" })
        #  vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
        #  vim.keymap.set("o",               "r", function() require("flash").remote()      end, { desc = "Remote Flash" })

        #  -- Mini.move
        #  require("mini.move").setup({
        #    mappings = {
        #      left = "<M-h>", right = "<M-l>", down = "<M-j>", up = "<M-k>",
        #      line_left = "<M-h>", line_right = "<M-l>", line_down = "<M-j>", line_up = "<M-k>",
        #    },
        #  })

        #  -- Todo-comments
        #  vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>",                         { desc = "Find TODOs" })
        #  vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end,   { desc = "Next TODO" })
        #  vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end,   { desc = "Prev TODO" })

        #  -- Trouble
        #  vim.keymap.set("n", "<leader>xx", ":TroubleToggle<CR>",                          { desc = "Trouble toggle" })
        #  vim.keymap.set("n", "<leader>xw", ":TroubleToggle workspace_diagnostics<CR>",    { desc = "Workspace diagnostics" })
        #  vim.keymap.set("n", "<leader>xd", ":TroubleToggle document_diagnostics<CR>",     { desc = "Document diagnostics" })
        #  vim.keymap.set("n", "<leader>xl", ":TroubleToggle loclist<CR>",                  { desc = "Loclist" })
        #  vim.keymap.set("n", "<leader>xq", ":TroubleToggle quickfix<CR>",                 { desc = "Quickfix" })
        #'';
      }; # end programs.nixvim
    };
}
