{
  description = "Hugix: A Nix wrapper for Hugo";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    {
      lib = {
        generate =
          {
            name,
            theme,
            cfg,
            system,
            content,
          }:
          let
            pkgs = import nixpkgs { inherit system; };
            toml = pkgs.formats.toml { };
            config = toml.generate "hugo.toml" cfg;
            themePath = "tmp/themes/${cfg.theme}";
          in
          pkgs.stdenv.mkDerivation {
            inherit name;
            dontInstall = true;
            src = content;
            buildInputs = with pkgs; [ hugo ];
            buildPhase = ''
              hugo new site tmp
              mkdir -p ${themePath}
              cp -r ${theme}/* ${themePath}
              hugo \
              	-s tmp \
              	-c $src \
              	--config ${config} \
              	-d $out \
              	--noBuildLock \
              	--minify
            '';
          };
      };
    };
}
