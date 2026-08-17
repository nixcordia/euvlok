{
  bash,
  cachix,
  dbus,
  fetchFromGitHub,
  gitMinimal,
  glibcLocalesUtf8,
  installShellFiles,
  lib,
  libghostty-vt,
  llvmPackages,
  makeBinaryWrapper,
  nixVersions,
  nixd,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,
  sqlite,
  testers,
}:
let
  version = "2.2.1";
  devenvNixVersion = "2.34";
  devenvNixSrc = fetchFromGitHub {
    name = "devenv-nix-${devenvNixVersion}-source";
    owner = "cachix";
    repo = "nix";
    rev = "f33db89fd6db6edc337d93212f6628ab6d25f407";
    hash = "sha256-JSD8lPe5kalvPKx5X+inX8ZZdGLeXkAbd3Jiv7UDf+I=";
  };

  nixComponents = (nixVersions.nixComponents_git.overrideSource devenvNixSrc).overrideScope (
    _final: _prev: {
      version = devenvNixVersion;
    }
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    hash = "sha256-S4baMekJYJGWDCo1yOYxZkmgBlAruQ5MLi+h3Zo8als=";
  };

  cargoHash = "sha256-2SQbXhDOoXQ33RYB5ik2rSdP3LxNR77lp/B9R1abUl0=";

  env = {
    RUSTFLAGS = "--cfg tracing_unstable";
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
    DEVENV_IS_RELEASE = true;
  };

  cargoBuildFlags = [
    "-p"
    "devenv"
    "-p"
    "devenv-run-tests"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    dbus
    libghostty-vt
    llvmPackages.clang-unwrapped
    nixComponents.nix-expr-c
    nixComponents.nix-store-c
    nixComponents.nix-util-c
    nixComponents.nix-flake-c
    nixComponents.nix-cmd-c
    nixComponents.nix-fetchers-c
    nixComponents.nix-main-c
  ];

  nativeCheckInputs = [
    gitMinimal
    bash
  ];

  preCheck = ''
    pushd $NIX_BUILD_TOP/source
    git init -b main
    git config user.email "test@example.com"
    git config user.name "Test User"
    git add -A
    popd
  '';

  useNextest = true;
  cargoTestFlags = [
    "-p"
    "devenv"
  ];

  postInstall =
    let
      setDefaultLocaleArchive = lib.strings.optionalString (glibcLocalesUtf8 != null) ''
        --set-default LOCALE_ARCHIVE ${glibcLocalesUtf8}/lib/locale/locale-archive
      '';
    in
    ''
      wrapProgram $out/bin/devenv \
        --prefix PATH ":" "$out/bin:${lib.attrsets.getBin cachix}/bin:${lib.attrsets.getBin nixd}/bin" \
        ${setDefaultLocaleArchive}

      wrapProgram $out/bin/devenv-run-tests \
        --prefix PATH ":" "$out/bin:${lib.attrsets.getBin cachix}/bin:${lib.attrsets.getBin nixd}/bin" \
        ${setDefaultLocaleArchive}

      cargo xtask generate-manpages --out-dir man
      installManPage man/*

      compdir=./completions
      export PATH="$out/bin:$PATH"
      for shell in bash fish zsh; do
        cargo xtask generate-shell-completion $shell --out-dir $compdir
      done

      installShellCompletion --cmd devenv \
        --bash $compdir/devenv.bash \
        --fish $compdir/devenv.fish \
        --zsh $compdir/_devenv
    '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "export XDG_DATA_HOME=$PWD; devenv version";
  };

  meta = {
    changelog = "https://github.com/cachix/devenv/releases/tag/v${version}";
    description = "Fast, Declarative, Reproducible, and Composable Developer Environments";
    homepage = "https://devenv.sh";
    license = lib.licenses.asl20;
    mainProgram = "devenv";
    maintainers = [
      lib.maintainers.domenkozar
      lib.maintainers.sandydoo
    ];
  };
})
