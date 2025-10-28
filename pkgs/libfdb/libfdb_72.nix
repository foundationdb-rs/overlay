{ stdenv, autoPatchelfHook, fetchurl, lib, xz, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfdb_c";
  version = "7.2.9";
  sha256 = "8ddfdc5073217740e5e733323e8858a1c3ad496f8db985bd88a769d02ee8642a";

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
