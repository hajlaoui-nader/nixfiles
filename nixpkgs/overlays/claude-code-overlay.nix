final: prev: {

  claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
    version = "1.0.56";

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-QtRT79ytIUPyiDxWCLcyDf1v/fceyFYsCWam3gCfBhk=";
    };

    # npmDepsHash will be calculated automatically by nix
  });

} 