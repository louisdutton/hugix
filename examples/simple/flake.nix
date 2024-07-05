{
  description = "A simple website";

  inputs = {
    hugix.url = "path:../../";
    theme = {
      url = "github:thenewdynamic/gohugo-theme-ananke";
      flake = false;
    };
  };

  outputs =
    { hugix, theme, ... }:
    let
      name = "website";
      system = "x86_64-linux";
    in
    {
      packages.${system}.default = hugix.lib.generate {
        inherit system name theme;
        content = ./content;
        cfg = {
          baseURL = "https://website.com";
          languageCode = "en-gb";
          title = "John Doe";
          theme = "ananke";
        };
      };
    };
}
