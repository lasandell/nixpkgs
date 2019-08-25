{ stdenv, fetchFromGitHub, alsaLib, rtl-sdr, libsndfile, sqlite }:

stdenv.mkDerivation rec {
  pname = "acarsdec";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "TLeconte";
    repo = pname;
    rev = "acarsdec-${version}";
    sha256 = "14czq3m5rbp6mra8rvzgpzqx9wf4zlsp7hp2637xb3f3x1mrhxbv";
  };

  buildInputs = [ alsaLib libsndfile rtl-sdr sqlite ];

  # Fix to work with PulseAudio ALSA emulation when passing `-a default` option
  # Upstream has since removed soundcard support, but we can patch this version
  postPatch = ''
    substituteInPlace alsa.c --replace \
      snd_pcm_hw_params_get_channels snd_pcm_hw_params_get_channels_min
  '';

  buildPhase = ''
    make acarsdec acarsserv
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp acarsdec $out/bin
    cp acarsserv $out/bin
    mkdir -p $out/share/acarsdec
    cp $src/test.wav $out/share/acarsdec/sample.wav
  '';

  meta = with stdenv.lib; {
    description = "ACARS SDR decoder";
    homepage = https://github.com/TLeconte/acarsdec;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lasandell ];
  };
}
