{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libsdrplay, soapysdr
} :

let
  version = "0.2.0";

in stdenv.mkDerivation {
  name = "soapysdrplay-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDRPlay";
    rev = "soapy-sdrplay-${version}";
    sha256 = "0w91p1db6cf1w17m9xxhgpb0y8naaawxc22j3rcpd2paf3isv3sh";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libsdrplay soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyRTLSDR;
    description = "SoapySDR plugin for SDRplay devices";
    license = licenses.mit;
    maintainers = with maintainers; [ lasandell ];
    platforms = platforms.linux;
  };
}
