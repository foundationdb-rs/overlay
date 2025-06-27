{ stdenv, autoPatchelfHook, fetchurl, makeWrapper, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbserver";
  version = "7.3.63";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbserver.x86_64";
    # Hash obtained via nix-prefetch-url
    sha256 = "0024nwjsascwwgfgn7ndmr0wb0p3kl21rc9mmkdhnvjpwi3vj42b";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper xz zlib ]; 

  # fdbserver is a binary, not an archive
  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fdbserver
    chmod +x $out/bin/fdbserver
  '';

  # Optional meta information
  meta = {
    description = "FoundationDB Server ${finalAttrs.version}";
    # license = lib.licenses.asl20; # Assuming Apache 2.0
    platforms = [ "x86_64-linux" ];
  };
})
