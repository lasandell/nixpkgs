{ lib, callPackage, stdenv, overrideCC, gcc5, fetchurl, fetchFromGitHub, fetchpatch }:

let common = opts: callPackage (import ./common.nix opts); in

rec {

  firefox = common rec {
    pname = "firefox";
    version = "57.0.3";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "1f887ab6bb16ef69bce56b689e761b3e09fc106b4bee7842be2c8e7eac05981f9922e9c3a8bd22b4935545cbbc10bf0a0c79df7800cd3c80fd4137070c9bfd09";
    };

    patches =
      [ ./no-buildconfig.patch ./env_var_for_system_dir.patch ]
      ++ lib.optional stdenv.isi686 (fetchpatch {
        url = "https://hg.mozilla.org/mozilla-central/raw-rev/15517c5a5d37";
        sha256 = "1ba487p3hk4w2w7qqfxgv1y57vp86b8g3xhav2j20qd3j3phbbn7";
      });

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.linux;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  } {};

  firefox-esr = common rec {
    pname = "firefox-esr";
    version = "52.5.3esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "7b9c87905c53bc681dc6475e05596449fed88850f9dc07c8223d0d3edd2dd9d8a0dd88ebae1cd59eced2165696df9370de5e85cc03cded58ec4d0f622634417f";
    };

    patches =
      [ ./env_var_for_system_dir.patch ];

    meta = firefox.meta // {
      description = "A web browser built from Firefox Extended Support Release source tree";
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-unwrapped";
      versionSuffix = "esr";
    };
  } {};

} // (let

  commonAttrs = {
    overrides = {
      unpackPhase = ''
        # fetchFromGitHub produces ro sources, root dir gets a name that
        # is too long for shebangs. fixing
        cp -a $src tor-browser
        chmod -R +w tor-browser
        cd tor-browser

        # set times for xpi archives
        find . -exec touch -d'2010-01-01 00:00' {} \;
      '';
    };

    meta = {
      description = "A web browser built from TorBrowser source tree";
      longDescription = ''
        This is a version of TorBrowser with bundle-related patches
        reverted.

        I.e. it's a variant of Firefox with less fingerprinting and
        some isolation features you can't get with any extensions.

        Or, alternatively, a variant of TorBrowser that works like any
        other UNIX program and doesn't expect you to run it from a
        bundle.

        It will use your default Firefox profile if you're not careful
        even! Be careful!

        It will clash with firefox binary if you install both. But its
        not a problem since you should run browsers in separate
        users/VMs anyway.

        Create new profile by starting it as

        $ firefox -ProfileManager

        and then configure it to use your tor instance.
      '';
      homepage = https://www.torproject.org/projects/torbrowser.html;
      platforms = lib.platforms.linux;
    };
  };

in rec {

  tor-browser-6-5 = common (rec {
    pname = "tor-browser";
    version = "6.5.2";
    isTorBrowserLike = true;
    extraConfigureFlags = [ "--disable-loop" ];

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo = "tor-browser";
      # branch "tor-browser-45.8.0esr-6.5-2-slnos"
      rev = "e4140ea01b9906934f0347e95f860cec207ea824";
      sha256 = "0a1qk3a9a3xxrl56bp4zbknbchv5x17k1w5kgcf4j3vklcv6av60";
    };
  } // commonAttrs) {
    stdenv = overrideCC stdenv gcc5;
    ffmpegSupport = false;
    gssSupport = false;
  };

  tor-browser-7-0 = common (rec {
    pname = "tor-browser";
    version = "7.0.1";
    isTorBrowserLike = true;

    # FIXME: fetchFromGitHub is not ideal, unpacked source is >900Mb
    src = fetchFromGitHub {
      owner = "SLNOS";
      repo  = "tor-browser";
      # branch "tor-browser-52.5.0esr-7.0-1-slnos";
      rev   = "830ff8d622ef20345d83f386174f790b0fc2440d";
      sha256 = "169mjkr0bp80yv9nzza7kay7y2k03lpnx71h4ybcv9ygxgzdgax5";
    };

    patches =
      [ ./env_var_for_system_dir.patch ];
  } // commonAttrs) {};

  tor-browser = tor-browser-7-0;

})
