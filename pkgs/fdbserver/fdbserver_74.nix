{ stdenv, autoPatchelfHook, fetchurl, makeWrapper, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbserver";
  version = "7.4.6";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbserver.x86_64";
    sha256 = "2e9bd4ce461821c5d978e1119d4065e7f2db8da77655273a2ddd31177543aa18";
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
