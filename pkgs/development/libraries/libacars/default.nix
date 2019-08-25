{ stdenv, fetchFromGitHub, cmake, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  pname = "libacars";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k3znv9qxprg5nmwkpj18q7wcsnwcxyi8ir1q0pyqgl0mjxq3dyq";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    description = "A library for decoding various ACARS message payloads ";
    homepage = https://github.com/szpajder/libacars;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lasandell ];
  };
}
