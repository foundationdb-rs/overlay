{ stdenv, autoPatchelfHook, fetchurl, makeWrapper, lib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbserver";
  version = "7.1.61";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbserver.x86_64";
    sha256 = "6fd31402d5cd0a797307077d6f39591a806d39068fc6a28e3c6cb96b96081438";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ]; 

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
