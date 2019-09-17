{ stdenv, fetchurl, libudev }:

stdenv.mkDerivation rec {
  name = "libsdrplay-${version}";
  version = "2.13.1";

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${version}.run";
    sha256 = "08j56rmvk3ycpsdgvhdci84wy72jy9x20mp995fwp8zzmyg0ncp2";
  };

  buildInputs = [ libudev ];

  unpackPhase = ''
    sh "$src" --noexec --target .
  '';

  installPhase = ''
    lib=libmirsdrapi-rsp
    major=`echo "$version" | cut -d. -f1`
    minor=`echo "$version" | cut -d. -f2`
    libFile="$libName.so.$major.$minor"
    arch=`echo "$system" | cut -d- -f1`
    mkdir -p "$out/lib" "$out/include" "$out/etc/udev/rules.d"
    cp "$arch/$lib.so.$major.$minor" "$out/lib"
    ln -s "$out/lib/$lib.so.$major.$minor" "$out/lib/$lib.so.$major"
    ln -s "$out/lib/$lib.so.$major" "$out/lib/$lib.so"
    cp *.h "$out/include"
    cp *.rules "$out/etc/udev/rules.d"
  '';

  meta = with stdenv.lib; {
    description = "Library for interfacing with SDRplay devices";
    homepage = https://www.sdrplay.com/;
    license = licenses.unfree;
    platforms = ["x86_64-linux" "i686-linux"];
  };
}
