final: prev: {

  claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
    version = "2.0.13";

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-eZWtiIWE0pV7Z/6hAtr+s46t4nuv/d+U2K9AgfpjjSE=";
    };

    npmDepsHash = "sha256-wazALudqwwYVCm7qCYIuOkOVcFxRTzLjkDnRXaHLFIQ=";
  });

}

