{ dpkg
, fetchurl
, glib
, glibc
, lib
, libsecret
, libuuid
, stdenv
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pje-office";
  version = "1.0.28";

  rpath = lib.makeLibraryPath [
    glib
    glibc
    libsecret
    libuuid

    stdenv.cc.cc
    systemd
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src = fetchurl {
    url = "https://cnj-pje-programs.s3-sa-east-1.amazonaws.com/pje-office/pje-office_amd64.deb";
    sha256 = "sha256-GoO3nShHKnndQXKK8YSGn9+hH0WHsIjkRptyQqv7QZc=";
  };

  nativeBuildInputs = [ wrapGAppsHook glib ];

  buildInputs = [ dpkg ];

  dontUnpack = true;

  # unpackPhase = ''
  #   runHook preUnpack

  #   dpkg -x $src ./pje-office-src

  #   runHook postUnpack
  # '';

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/opt $out/usr
    mkdir -p $out/bin

    ln -s "$out/share/pje-office/pjeOffice.sh" "$out/bin/pje-office"
    ln -s "$out/share/pje-office/pjeOffice.sh" "$out/bin/pjeOffice"

    # Otherwise it looks "suspicious"
    chmod -R g-w $out
  '';

  postFixup = ''
    # for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
    #   patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
    #   patchelf --set-rpath ${rpath}:$out/share/skypeforlinux $file || true
    # done

    # Fix the desktop link
    substituteInPlace $out/share/pje-office/shortcuts/pje-office.desktop \
      --replace /usr/bin/ ""
  '';

  meta = with lib; {
    description = "Aplicativo nativo utilizado para realizar assinatura digitais.";
    homepage = "https://www.pje.jus.br/wiki/index.php/PJeOffice";
    downloadPage = "https://cnj-pje-programs.s3-sa-east-1.amazonaws.com/pje-office/pje-office_amd64.deb";
    license = licenses.unfree;
    platforms = with platforms; [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ "Conselho Nacional de Justica - CNJ" ];
    # mainProgram = "pje-office";
  };
}
