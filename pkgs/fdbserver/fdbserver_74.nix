{ stdenv, autoPatchelfHook, fetchurl, makeWrapper, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbserver";
  version = "7.4.5";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbserver.x86_64";
    sha256 = "cccc7f5cfc13e3912bc55c10831091cacb7ea726c2abc2b883e6fe31668afa84";
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
