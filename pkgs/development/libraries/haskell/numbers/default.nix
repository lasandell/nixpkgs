# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, QuickCheck, testFramework, testFrameworkQuickcheck2 }:

cabal.mkDerivation (self: {
  pname = "numbers";
  version = "3000.2.0.1";
  sha256 = "10z1bi5qbc81z5xx2v1ylwcpmcfl1ci7lxrswkgi0dd1wi8havbk";
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/jwiegley/numbers#readme";
    description = "Various number types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
