# Fix direnv build on macOS: nixpkgs sets CGO_ENABLED=0 but the GNUmakefile
# unconditionally adds -linkmode=external on Darwin, which requires cgo.
# Remove that flag since we're building a static executable anyway.
final: prev: {
  direnv = prev.direnv.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace GNUmakefile \
        --replace-fail "GO_LDFLAGS += -linkmode=external" ""
    '';
  });
}
