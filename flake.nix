{
  description = "Hugix: A Nix wrapper for Hugo";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    {
      lib.hugoSite =
        {
          theme,
          config,
          contentDir ? ./content,
          system,
        }:
        let
          pkgs = import nixpkgs { inherit system; };
          toml = pkgs.formats.toml { };
          buildInputs = with pkgs; [ hugo ];
          configFile = toml.generate "hugo.toml" config;

          hugoSite = pkgs.stdenv.mkDerivation {
            inherit buildInputs;
            name = "hugo-src";
            dontUnpack = true;
            dontInstall = true;
            buildPhase = ''
              hugo new site $out
              mkdir -p $out/themes/theme
              cp -r ${theme}/* $out/themes/theme
            '';
          };

          hugoServer = pkgs.writeShellScriptBin "hugo-server" ''
            TEMP_DIR=$(mktemp -d)
            cp -r ${hugoSite}/. $TEMP_DIR
            ${pkgs.hugo}/bin/hugo server \
            	-s $TEMP_DIR \
            	-c ${contentDir} \
            	-t theme \
            	--config ${configFile}
          '';
        in
        {
          apps.${system}.server = {
            type = "app";
            program = "${hugoServer}/bin/hugo-server";
          };

          devShells.${system}.default = pkgs.mkShell {
            packages = [
              pkgs.hugo
              hugoServer
            ];
            shellHook = ''
              echo "run hugo --help for a list of available commands"
            '';
          };

          packages.${system}.default = pkgs.stdenv.mkDerivation {
            inherit buildInputs;
            name = "hugo-build";
            dontInstall = true;
            dontUnpack = true;
            buildPhase = ''
              hugo \
              	-s ${hugoSite} \
              	-c ${contentDir} \
              	-t theme
              	--config ${configFile} \
              	-d $out \
              	--noBuildLock \
              	--minify
            '';
          };
        };
    };
}
