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
    hugix.lib.hugoSite {
      inherit theme;
      system = "x86_64-linux";
      contentDir = ./content;
      config = {
        baseURL = "https://website.com";
        languageCode = "en-gb";
        title = "John Doe";
        theme = "ananke";
      };
    };
}
