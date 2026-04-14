{ stdenv, autoPatchelfHook, fetchurl, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfdb_c";
  version = "7.4.6";
  sha256 = "d1a097c3947fbc4aadfbfcb42daac101b4150160656377fba19bcdbe4656513c";

  src = fetchurl {
    url = "https://github.com/apple/foundationdb/releases/download/${finalAttrs.version}/libfdb_c.x86_64.so";
    sha256 = "${finalAttrs.sha256}";
  };

  nativeBuildInputs = [ autoPatchelfHook xz zlib ];

  unpackPhase = ":";

  installPhase = [
    ''
      mkdir -p $out/include
      cp $src $out/include/libfdb_c.so
      chmod 555 $out/include/libfdb_c.so
    ''
  ];
})
