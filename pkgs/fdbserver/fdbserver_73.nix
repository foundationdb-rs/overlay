{ stdenv, autoPatchelfHook, fetchurl, makeWrapper, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbserver";
  version = "7.3.69";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbserver.x86_64";
    sha256 = "490dd8de050b3883103ae7513deacde332c75e9a5f06e1897360d21f438b1e17";
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
