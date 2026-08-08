{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  vulkan-headers,
  vulkan-loader,
  qt6,
}:

stdenv.mkDerivation {
  pname = "lsfg-vk";
  version = "2.0.0-dev-unstable-2026-06-28";

  src = fetchFromGitHub {
    owner = "PancakeTAS";
    repo = "lsfg-vk";
    rev = "8b0da2661c6f3473a7fccc8ba643880050e71642";
    hash = "sha256-SDZXT+eYkOPr/qqZgCip9YSSf6SWwuvv1Y20+hlqGCw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qttools
    qt6.qtwayland
  ];

  cmakeFlags = [
    "-DLSFGVK_BUILD_VK_LAYER=ON"
    "-DLSFGVK_BUILD_UI=ON"
    "-DLSFGVK_BUILD_CLI=ON"
    "-DLSFGVK_INSTALL_XDG_FILES=ON"
    "-DLSFGVK_LAYER_LIBRARY_PATH=${placeholder "out"}/lib/liblsfg-vk-layer.so"
  ];

  meta = {
    description = "Lossless Scaling frame generation Vulkan layer";
    homepage = "https://github.com/PancakeTAS/lsfg-vk";
    license = lib.licenses.gpl3Only;
    mainProgram = "lsfg-vk-ui";
    platforms = [ "x86_64-linux" ];
  };
}
