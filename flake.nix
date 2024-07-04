{
  description = "Hugix: A Nix wrapper for Hugo";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          packages.default =
            let
              toml = pkgs.formats.toml { };
            in
            {
              generate =
                {
                  name,
                  theme,
                  cfg,
                }:
                pkgs.stdenv.mkDerivation {
                  inherit name;
                  dontInstall = true;
                  src = theme;
                  buildInputs = with pkgs; [ hugo ];
                  buildPhase = ''
                    hugo new site tmp
                    mkdir -p tmp/themes/${cfg.theme}
                    cp -r $src/* tmp/themes/${cfg.theme}
                    hugo -s tmp -c ${toml.generate "hugo.toml" cfg} -d $out --noBuildLock
                  '';
                };
            };
        };
    };
}
