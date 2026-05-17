{ config, ... }:
{
  flake.nixosModules.shell =
    { pkgs, ... }:
    {
      programs.fish.enable = true;

      environment.systemPackages = with pkgs; [
        btop
        eza
        fd
        jq
        ripgrep
      ];
    };

  flake.homeModules.shell =
    { ... }:
    {
      programs = {
        bat.enable = true;

        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        btop = {
          enable = true;
          settings = {
            theme_background = false;
            rounded_corners = false;
          };
        };

        fzf = {
          enable = true;
          enableFishIntegration = true;
        };

        yazi = {
          enable = true;
          enableFishIntegration = true;
          shellWrapperName = "y";
          settings = {
            manager = {
              linemode = "size";
              show_symlink = true;
              sort_by = "natural";
              sort_dir_first = true;
              sort_reverse = false;
              sort_sensitive = false;
            };
          };
        };

        fish = {
          enable = true;
          interactiveShellInit = ''
            fish_config theme choose catppuccin-mocha --color-theme=dark
            set fish_greeting
            function fish_user_key_bindings
              fish_vi_key_bindings
            end
            function fish_mode_prompt
            end
            function y
            	set tmp (mktemp -t "yazi-cwd.XXXXXX")
            	yazi $argv --cwd-file="$tmp"
            	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            		builtin cd -- "$cwd"
            	end
            	rm -f -- "$tmp"
            end
          '';

          functions = {
            fish_prompt = {
              body = ''
                set -l mocha_blue   \e\[38\;2\;137\;180\;250m
                set -l mocha_green  \e\[38\;2\;166\;227\;161m
                set -l mocha_red    \e\[38\;2\;243\;139\;168m
                set -l reset        \e\[0m

                set -l cwd (prompt_pwd --full-length-dirs 1 --dir-length 1)

                set -l status_color $mocha_green
                if test $status -ne 0
                  set status_color $mocha_red
                end

                if set -q SSH_CONNECTION
                  echo -s $mocha_blue (hostname) " " $reset $cwd " " $status_color ">" $reset " "
                else
                  echo -s $mocha_blue $cwd " " $status_color ">" $reset " "
                end
              '';
            };
          };

          shellAbbrs = {
            "vim" = "nvim";
            "vi" = "nvim";
            "v" = "nvim";
            "neovim" = "nvim";
            "n" = "nvim";
            "vfzf" = "nvim $(fzf)";
            "cp" = "cp -iv";
            "mv" = "mv -iv";
            "rm" = "rm -vI";
            "rsync" = "rsync -vrPlu";
            "md" = "mkdir -pv";
            "fa" = "fastfetch --config examples/13.jsonc";

            "g" = "git";
            "gc" = "git clone";
            "ga" = "git add";
            "gaa" = "git add -A";
            "gcm" = "git commit -m";
            "gp" = "git push";
            "gpp" = "git pull";

            "yt" = "yt-dlp --embed-metadata -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'";
            "yta" = "yt -x -f bestaudio/best";
            "ffmpeg" = "ffmpeg -hide_banner";

            "ls" = "eza --group-directories-first --icons always";
            "ll" = "eza --group-directories-first -lag --icons always --header";
            "grep" = "rg";
            "cat" = "bat";
            "cd" = "z";
            "cc" = "clear; z";
            "ka" = "killall";

            ".." = "z ..";
            "..." = "z ../..";
            "...." = "z ../../..";

            "untar" = "tar -zxvf";
            "mktar" = "tar -cvzf";

            # Nixos related
            "nr" = "nixos-rebuild";
            "nuc" = "nh os switch ~/nixconf -u && nh clean all";
            "nru" = "z ~/nixconf && doas nixos-rebuild switch --flake . --upgrade";
            "nsp" = "nix-shell -p";
            "scg" = "doas nix-collect-garbage -d";
            "ucg" = "nix-collect-garbage -d";
            "cfg" = "z /home/${config.my.username}/nixconf/";
            "rn" = "nh os switch ~/nixconf";
          };
        };
      };
    };
}
