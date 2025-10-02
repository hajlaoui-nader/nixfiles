final: prev: {

  claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
    version = "2.0.1";

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-Emx9dS/G7iTwjC22+nDc9FloM/SNi95aHw2NLxSc4CM=";
    };

    # npmDepsHash will be calculated automatically by nix
  });

}

