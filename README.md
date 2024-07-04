# Hugix

A nix wrapper for Hugo

## Single-file static site

```nix
{
  description = "My website";
  inputs.hugix.url = "louisdutton/hugix";
  outputs =
    { hugix, ... }:
    {
      defaultPackage.x86_64-linux = hugix.generate {
        baseURL = "https://website.com";
        languageCode = "en-gb";
        title = "My website";
        theme = "blowfish";
      };
    };
}
```
