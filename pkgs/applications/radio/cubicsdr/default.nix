{ stdenv, fetchFromGitHub, fetchpatch, cmake, fftw, hamlib, libpulseaudio, libGL, libX11, liquid-dsp,
  pkgconfig, soapysdr-with-plugins, wxGTK, enableDigitalLab ? false }:

stdenv.mkDerivation rec {
  pname = "cubicsdr";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "cjcliffe";
    repo = "CubicSDR";
    rev = version;
    sha256 = "1ihbn18bzdcdvwpa4hnb55ns38bj4b8xy53hkmra809f9qpbcjhn";
  };

  # Allow cubicsdr 0.2.5 to build with wxGTK 3.1.3
  patches = [
    (fetchpatch {
      url = "https://github.com/cjcliffe/CubicSDR/commit/65a160fa356ce9665dfe05c6bfc6754535e16743.patch";
      sha256 = "1s161k4rpnapfdnz03ibhkppy8iyrijkv7f3yvagjd7d5fjfpmxy";
    })
    (fetchpatch {
      url = "https://github.com/cjcliffe/CubicSDR/commit/f449a65457e35bf8260d0b16b8a47b6bc0ea2c7e.patch";
      sha256 = "0sxqbd3qw6dbyy8i5qdncl719x6vy6y47ywjf3xd131ykjinf163";
    })
    (fetchpatch {
      url = "https://github.com/cjcliffe/CubicSDR/commit/0540d08c2dea79b668b32b1a6d58f235d65ce9d2.patch";
      sha256 = "1wc7hk1gm3vbrrh3f3aga4sv7cqrc9z95bh3618wxzmvc72ijvpq";
    })
  ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ fftw hamlib libpulseaudio libGL libX11 liquid-dsp soapysdr-with-plugins wxGTK ];

  cmakeFlags = [ "-DUSE_HAMLIB=ON" ]
    ++ stdenv.lib.optional enableDigitalLab "-DENABLE_DIGITAL_LAB=ON";

  meta = with stdenv.lib; {
    homepage = "https://cubicsdr.com";
    description = "Software Defined Radio application";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lasandell ];
    platforms = platforms.linux;
  };
}

