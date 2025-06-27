{
  stdenv
, autoPatchelfHook
, fetchurl
, makeWrapper
, lib # For optional meta
, xz # Added for liblzma
, zlib # Added for libz
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdbserver";
  version = "7.4.3";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/fdbserver.x86_64";
    # Hash obtained via nix-prefetch-url
    sha256 = "f2cb0712d33711f227c51a10bd40f620b4743b79ebe6895e2e6b6c92056ab0f4";
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
