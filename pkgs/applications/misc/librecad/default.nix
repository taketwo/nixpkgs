{ stdenv, fetchurl, qt4, qmake4Hook, muparser, which, boost, pkgconfig }:

stdenv.mkDerivation rec {
  version = "2.1.3";
  name = "librecad-${version}";

  src = fetchurl {
    url = "https://github.com/LibreCAD/LibreCAD/tarball/${version}";
    name = name + ".tar.gz";
    sha256 = "1czp8bja61hfav2m7184cq1np1n76w3w6vn0hlkp81hhz9zc62sx";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, scripts/postprocess-unix.sh
    sed -i -e s,/usr/share,$out/share, librecad/src/lib/engine/rs_system.cpp
  '';

  qmakeFlags = [ "MUPARSER_DIR=${muparser}" "BOOST_DIR=${boost.dev}" ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -R unix/librecad $out/bin
    cp -R unix/resources $out/share/librecad
  '';

  buildInputs = [ qt4 muparser which boost ];
  nativeBuildInputs = [ pkgconfig qmake4Hook ];

  enableParallelBuilding = true;

  meta = {
    description = "A 2D CAD package based upon Qt";
    homepage = http://librecad.org;
    repositories.git = git://github.com/LibreCAD/LibreCAD.git;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
