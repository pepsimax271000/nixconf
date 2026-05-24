{ inputs, ... }:
{
  flake.homeModules.neovim =
    { pkgs, ... }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        # ── Options ─────────────────────────────────────────────────────────────
        opts = {
          number = true;
          relativenumber = true;
          numberwidth = 2;
          signcolumn = "yes";
          cursorline = true;

          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          smartindent = true;

          wrap = false;
          scrolloff = 8;
          sidescrolloff = 8;

          hlsearch = false;
          incsearch = true;
          ignorecase = true;
          smartcase = true;

          termguicolors = true;
          showmode = false; # lualine handles this
          laststatus = 3; # global statusline
          splitbelow = true;
          splitright = true;

          undofile = true;
          swapfile = false;
          backup = false;
          updatetime = 250;
          timeoutlen = 300;

          fillchars.__raw = ''{ eob = " " }''; # hide ~ at end of buffer
        };

        globals = {
          mapleader = " ";
          maplocalleader = " ";
        };

        # ── Theme ────────────────────────────────────────────────────────────────
        colorschemes.catppuccin = {
          enable = true;
          settings = {
            flavour = "mocha";
            transparent_background = false;
            integrations = {
              cmp = true;
              gitsigns = true;
              nvimtree = false;
              neo_tree = true;
              telescope = {
                enabled = true;
              };
              which_key = true;
              indent_blankline = {
                enabled = true;
              };
              native_lsp = {
                enabled = true;
                underlines.errors = [ "underline" ];
                underlines.hints = [ "underline" ];
                underlines.warnings = [ "underline" ];
              };
            };
          };
        };

        # ── Keymaps ──────────────────────────────────────────────────────────────
        keymaps = [
          # better up/down on wrapped lines
          {
            mode = [
              "n"
              "x"
            ];
            key = "j";
            action = "v:count == 0 ? 'gj' : 'j'";
            options.expr = true;
          }
          {
            mode = [
              "n"
              "x"
            ];
            key = "k";
            action = "v:count == 0 ? 'gk' : 'k'";
            options.expr = true;
          }

          # window navigation
          {
            mode = "n";
            key = "<C-h>";
            action = "<C-w>h";
            options.desc = "Go to left window";
          }
          {
            mode = "n";
            key = "<C-j>";
            action = "<C-w>j";
            options.desc = "Go to lower window";
          }
          {
            mode = "n";
            key = "<C-k>";
            action = "<C-w>k";
            options.desc = "Go to upper window";
          }
          {
            mode = "n";
            key = "<C-l>";
            action = "<C-w>l";
            options.desc = "Go to right window";
          }

          # resize windows
          {
            mode = "n";
            key = "<C-Up>";
            action = "<cmd>resize +2<cr>";
            options.desc = "Increase window height";
          }
          {
            mode = "n";
            key = "<C-Down>";
            action = "<cmd>resize -2<cr>";
            options.desc = "Decrease window height";
          }
          {
            mode = "n";
            key = "<C-Left>";
            action = "<cmd>vertical resize -2<cr>";
            options.desc = "Decrease window width";
          }
          {
            mode = "n";
            key = "<C-Right>";
            action = "<cmd>vertical resize +2<cr>";
            options.desc = "Increase window width";
          }

          # buffers
          {
            mode = "n";
            key = "<S-l>";
            action = "<cmd>bnext<cr>";
            options.desc = "Next buffer";
          }
          {
            mode = "n";
            key = "<S-h>";
            action = "<cmd>bprevious<cr>";
            options.desc = "Previous buffer";
          }
          {
            mode = "n";
            key = "<leader>bd";
            action = "<cmd>bdelete<cr>";
            options.desc = "Delete buffer";
          }

          # move lines
          {
            mode = "n";
            key = "<A-j>";
            action = "<cmd>m .+1<cr>==";
            options.desc = "Move line down";
          }
          {
            mode = "n";
            key = "<A-k>";
            action = "<cmd>m .-2<cr>==";
            options.desc = "Move line up";
          }
          {
            mode = "i";
            key = "<A-j>";
            action = "<esc><cmd>m .+1<cr>==gi";
            options.desc = "Move line down";
          }
          {
            mode = "i";
            key = "<A-k>";
            action = "<esc><cmd>m .-2<cr>==gi";
            options.desc = "Move line up";
          }
          {
            mode = "v";
            key = "<A-j>";
            action = ":m '>+1<cr>gv=gv";
            options.desc = "Move selection down";
          }
          {
            mode = "v";
            key = "<A-k>";
            action = ":m '<-2<cr>gv=gv";
            options.desc = "Move selection up";
          }

          # better indenting in visual
          {
            mode = "v";
            key = "<";
            action = "<gv";
          }
          {
            mode = "v";
            key = ">";
            action = ">gv";
          }

          # file tree
          {
            mode = "n";
            key = "<leader>e";
            action = "<cmd>Neotree toggle<cr>";
            options.desc = "Toggle file tree";
          }
          {
            mode = "n";
            key = "<leader>o";
            action = "<cmd>Neotree focus<cr>";
            options.desc = "Focus file tree";
          }

          # telescope
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<cr>";
            options.desc = "Find files";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>Telescope live_grep<cr>";
            options.desc = "Live grep";
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<cr>";
            options.desc = "Buffers";
          }
          {
            mode = "n";
            key = "<leader>fh";
            action = "<cmd>Telescope help_tags<cr>";
            options.desc = "Help tags";
          }
          {
            mode = "n";
            key = "<leader>fr";
            action = "<cmd>Telescope oldfiles<cr>";
            options.desc = "Recent files";
          }
          {
            mode = "n";
            key = "<leader>fc";
            action = "<cmd>Telescope commands<cr>";
            options.desc = "Commands";
          }
          {
            mode = "n";
            key = "<leader>fk";
            action = "<cmd>Telescope keymaps<cr>";
            options.desc = "Keymaps";
          }
          {
            mode = "n";
            key = "<leader>fs";
            action = "<cmd>Telescope lsp_document_symbols<cr>";
            options.desc = "Document symbols";
          }

          # LSP (also set in lsp.onAttach)
          {
            mode = "n";
            key = "gd";
            action = "<cmd>lua vim.lsp.buf.definition()<cr>";
            options.desc = "Go to definition";
          }
          {
            mode = "n";
            key = "gD";
            action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
            options.desc = "Go to declaration";
          }
          {
            mode = "n";
            key = "gr";
            action = "<cmd>Telescope lsp_references<cr>";
            options.desc = "References";
          }
          {
            mode = "n";
            key = "gi";
            action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
            options.desc = "Go to implementation";
          }
          {
            mode = "n";
            key = "K";
            action = "<cmd>lua vim.lsp.buf.hover()<cr>";
            options.desc = "Hover docs";
          }
          {
            mode = "n";
            key = "<leader>ca";
            action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
            options.desc = "Code action";
          }
          {
            mode = "n";
            key = "<leader>rn";
            action = "<cmd>lua vim.lsp.buf.rename()<cr>";
            options.desc = "Rename";
          }
          {
            mode = "n";
            key = "<leader>d";
            action = "<cmd>lua vim.diagnostic.open_float()<cr>";
            options.desc = "Line diagnostics";
          }
          {
            mode = "n";
            key = "[d";
            action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
            options.desc = "Previous diagnostic";
          }
          {
            mode = "n";
            key = "]d";
            action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
            options.desc = "Next diagnostic";
          }
          {
            mode = "n";
            key = "<leader>lf";
            action = "<cmd>lua vim.lsp.buf.format()<cr>";
            options.desc = "Format buffer";
          }

          # git
          {
            mode = "n";
            key = "<leader>gg";
            action = "<cmd>lua require('neogit').open()<cr>";
            options.desc = "Neogit";
          }
          {
            mode = "n";
            key = "<leader>gb";
            action = "<cmd>Gitsigns blame_line<cr>";
            options.desc = "Blame line";
          }
          {
            mode = "n";
            key = "<leader>gp";
            action = "<cmd>Gitsigns preview_hunk<cr>";
            options.desc = "Preview hunk";
          }
          {
            mode = "n";
            key = "]g";
            action = "<cmd>Gitsigns next_hunk<cr>";
            options.desc = "Next hunk";
          }
          {
            mode = "n";
            key = "[g";
            action = "<cmd>Gitsigns prev_hunk<cr>";
            options.desc = "Previous hunk";
          }

          # misc
          {
            mode = "n";
            key = "<leader>w";
            action = "<cmd>w<cr>";
            options.desc = "Save";
          }
          {
            mode = "n";
            key = "<leader>q";
            action = "<cmd>q<cr>";
            options.desc = "Quit";
          }
          {
            mode = "n";
            key = "<leader>h";
            action = "<cmd>nohlsearch<cr>";
            options.desc = "Clear highlights";
          }
          {
            mode = "n";
            key = "<leader>tn";
            action = "<cmd>tabnew<cr>";
            options.desc = "New tab";
          }
          {
            mode = "n";
            key = "<leader>/";
            action = "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>";
            options.desc = "Toggle comment";
          }
          {
            mode = "v";
            key = "<leader>/";
            action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
            options.desc = "Toggle comment";
          }
        ];

        # ── Plugins ──────────────────────────────────────────────────────────────
        plugins = {

          # LSP
          lsp = {
            enable = true;
            inlayHints = true;
            servers = {
              lua_ls.enable = true;
              ts_ls.enable = true;
              bashls.enable = true;
              cssls.enable = true;
              html.enable = true;
              jsonls.enable = true;
              pyright.enable = true;
              nixd.enable = true;
            };
          };

          # Completion
          cmp = {
            enable = true;
            settings = {
              completion.completeopt = "menu,menuone,noinsert";
              snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
              sources = [
                {
                  name = "nvim_lsp";
                  priority = 1000;
                }
                {
                  name = "luasnip";
                  priority = 750;
                }
                {
                  name = "buffer";
                  priority = 500;
                }
                {
                  name = "path";
                  priority = 250;
                }
              ];
              mapping.__raw = ''
                cmp.mapping.preset.insert({
                  ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                  ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                  ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                  ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                  ["<C-Space>"] = cmp.mapping.complete(),
                  ["<C-e>"]     = cmp.mapping.abort(),
                  ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                  ["<Tab>"]     = cmp.mapping(function(fallback)
                    if cmp.visible() then
                      cmp.select_next_item()
                    elseif require("luasnip").expand_or_jumpable() then
                      require("luasnip").expand_or_jump()
                    else
                      fallback()
                    end
                  end, { "i", "s" }),
                  ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                      cmp.select_prev_item()
                    elseif require("luasnip").jumpable(-1) then
                      require("luasnip").jump(-1)
                    else
                      fallback()
                    end
                  end, { "i", "s" }),
                })
              '';
            };
          };
          luasnip = {
            enable = true;
            settings.history = true;
          };
          friendly-snippets.enable = true;
          cmp-nvim-lsp.enable = true;
          cmp-buffer.enable = true;
          cmp-path.enable = true;
          cmp_luasnip.enable = true;

          # Treesitter
          treesitter = {
            enable = true;
            settings = {
              highlight.enable = true;
              indent.enable = true;
              incremental_selection.enable = true;
            };
          };
          treesitter-textobjects.enable = true;
          rainbow-delimiters.enable = true;

          # Telescope
          telescope = {
            enable = true;
            settings.defaults = {
              prompt_prefix = "   ";
              selection_caret = "  ";
              entry_prefix = "  ";
              sorting_strategy = "ascending";
              layout_config.horizontal.prompt_position = "top";
            };
            extensions.fzf-native.enable = true;
            extensions.ui-select.enable = true;
          };

          # File tree
          neo-tree = {
            enable = true;
            settings = {
              window = {
                width = 30;
                mappings."<space>" = "none";
              };
              filesystem = {
                filteredItems = {
                  visible = false;
                  hideGitignored = false;
                  hideDotfiles = false;
                };
                followCurrentFile.enabled = true;
              };
            };
          };

          # Statusline
          lualine = {
            enable = true;
            settings = {
              options = {
                theme = "catppuccin-nvim";
                globalstatus = true;
                disabled_filetypes.statusline = [
                  "dashboard"
                  "alpha"
                ];
                component_separators = {
                  left = "";
                  right = "";
                };
                section_separators = {
                  left = "";
                  right = "";
                };
              };
              sections = {
                lualine_a = [ "mode" ];
                lualine_b = [
                  "branch"
                  "diff"
                  "diagnostics"
                ];
                lualine_c = [
                  {
                    name = "filename";
                    extraConfig.path = 1;
                  }
                ];
                lualine_x = [
                  "encoding"
                  "fileformat"
                  "filetype"
                ];
                lualine_y = [ "progress" ];
                lualine_z = [ "location" ];
              };
            };
          };

          # Bufferline
          bufferline = {
            enable = true;
            settings.options = {
              numbers = "none";
              close_command = "bdelete! %d";
              diagnostics = "nvim_lsp";
              separator_style = "slant";
              show_buffer_close_icons = true;
              show_close_icon = false;
              always_show_bufferline = false;
            };
          };

          # Dashboard
          alpha = {
            enable = true;
            settings = {
              layout = [
                {
                  type = "padding";
                  val = 4;
                }
                {
                  type = "text";
                  val = [
                    "  ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
                    "  ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
                    "  ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
                    "  ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
                    "  ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
                    "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
                  ];
                  opts = {
                    position = "center";
                    hl = "AlphaHeader";
                  };
                }
                {
                  type = "padding";
                  val = 2;
                }
                {
                  type = "group";
                  val = [
                    {
                      type = "button";
                      val = "  Find file";
                      on_press.__raw = "function() require('telescope.builtin').find_files() end";
                      opts = {
                        shortcut = "f";
                        position = "center";
                        hl = "AlphaButtons";
                      };
                    }
                    {
                      type = "button";
                      val = "  Recent files";
                      on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
                      opts = {
                        shortcut = "r";
                        position = "center";
                        hl = "AlphaButtons";
                      };
                    }
                    {
                      type = "button";
                      val = "  New file";
                      on_press.__raw = "function() vim.cmd('enew') end";
                      opts = {
                        shortcut = "n";
                        position = "center";
                        hl = "AlphaButtons";
                      };
                    }
                    {
                      type = "button";
                      val = "  Config";
                      on_press.__raw = "function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') }) end";
                      opts = {
                        shortcut = "c";
                        position = "center";
                        hl = "AlphaButtons";
                      };
                    }
                    {
                      type = "button";
                      val = "󰗼  Quit";
                      on_press.__raw = "function() vim.cmd('qa') end";
                      opts = {
                        shortcut = "q";
                        position = "center";
                        hl = "AlphaButtons";
                      };
                    }
                  ];
                }
                {
                  type = "padding";
                  val = 2;
                }
              ];
            };
          };

          # Git
          gitsigns = {
            enable = true;
            settings = {
              signs = {
                add.text = "▎";
                change.text = "▎";
                delete.text = "";
                topdelete.text = "";
                changedelete.text = "▎";
                untracked.text = "▎";
              };
              current_line_blame = false;
            };
          };
          neogit = {
            enable = true;
            settings.integrations.diffview = true;
          };
          diffview.enable = true;

          # Editing
          conform-nvim = {
            enable = true;
            settings = {
              format_on_save.lsp_fallback = true;
              formatters_by_ft = {
                nix = [ "nixfmt" ];
                javascript = [ "prettier" ];
                typescript = [ "prettier" ];
                json = [ "prettier" ];
                css = [ "prettier" ];
                html = [ "prettier" ];
                markdown = [ "prettier" ];
                python = [ "black" ];
              };
            };
          };
          nvim-autopairs = {
            enable = true;
            settings.check_ts = true;
          };
          comment.enable = true;
          todo-comments.enable = true;
          indent-blankline = {
            enable = true;
            settings = {
              indent.char = "│";
              scope.enabled = true;
            };
          };
          nvim-surround.enable = true;

          # UI
          which-key = {
            enable = true;
            settings.spec = [
              {
                __unkeyed = "<leader>f";
                group = "find";
              }
              {
                __unkeyed = "<leader>g";
                group = "git";
              }
              {
                __unkeyed = "<leader>l";
                group = "lsp";
              }
              {
                __unkeyed = "<leader>b";
                group = "buffer";
              }
              {
                __unkeyed = "<leader>t";
                group = "tab";
              }
            ];
          };
          noice = {
            enable = true;
            settings = {
              lsp.override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
                "cmp.entry.get_documentation" = true;
              };
              presets = {
                bottom_search = true;
                command_palette = true;
                long_message_to_split = true;
                inc_rename = false;
              };
            };
          };
          notify = {
            enable = true;
            settings.render = "compact";
          };
          web-devicons.enable = true;
          dressing.enable = true;

          # Navigation
          flash = {
            enable = true;
            settings.modes.char.jump_labels = true;
          };
          harpoon = {
            enable = true;
            settings.settings.save_on_toggle = true;
          };

          # Terminal
          toggleterm = {
            enable = true;
            settings = {
              size = 20;
              open_mapping = "[[<C-\\>]]";
              direction = "float";
              float_opts.border = "curved";
            };
          };
        };

        extraPackages = with pkgs; [
          nixd
          nixfmt
          prettier
          typescript-language-server
          bash-language-server
          vscode-langservers-extracted
          pyright
          black
          ripgrep
          fd
          gcc # treesitter needs a C compiler
        ];

        extraPlugins = with pkgs.vimPlugins; [
          catppuccin-nvim
        ];

        extraConfigLua = ''
          -- Diagnostic signs
          vim.diagnostic.config({
            virtual_text     = { prefix = "●" },
            signs            = true,
            underline        = true,
            update_in_insert = false,
            severity_sort    = true,
            float = {
              focusable = false,
              style     = "minimal",
              border    = "rounded",
              source    = "always",
              header    = "",
              prefix    = "",
            },
          })

          -- Rounded borders on LSP hover/signature
          vim.lsp.handlers["textDocument/hover"]         = vim.lsp.with(vim.lsp.handlers.hover,          { border = "rounded" })
          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

          -- Harpoon keymaps
          local harpoon = require("harpoon")
          vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end,                        { desc = "Harpoon add" })
          vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
          vim.keymap.set("n", "<leader>1",  function() harpoon:list():select(1) end,                    { desc = "Harpoon 1" })
          vim.keymap.set("n", "<leader>2",  function() harpoon:list():select(2) end,                    { desc = "Harpoon 2" })
          vim.keymap.set("n", "<leader>3",  function() harpoon:list():select(3) end,                    { desc = "Harpoon 3" })
          vim.keymap.set("n", "<leader>4",  function() harpoon:list():select(4) end,                    { desc = "Harpoon 4" })
        '';
      };
    };
}
