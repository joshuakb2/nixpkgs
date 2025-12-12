{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-buildx";
  version = "0.29.1-josh-1";

  src = fetchFromGitHub {
    owner = "joshuakb2";
    repo = "buildx";
    rev = "436a47654320d006c45de471a41eaf43c5314ac0";
    hash = "sha256-DNmliQsFrzkxB6/1xiqmL6bI8oJaIKqrDVM/r81SkRE=";
  };

  doCheck = false;

  vendorHash = null;

  ldflags = [
    "-w"
    "-s"
    "-X github.com/joshuakb2/buildx/version.Package=github.com/joshuakb2/buildx"
    "-X github.com/joshuakb2/buildx/version.Version=v${version}"
  ];

  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/buildx $out/libexec/docker/cli-plugins/docker-buildx

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-buildx $out/bin/docker-buildx
    runHook postInstall
  '';

  meta = with lib; {
    description = "Docker CLI plugin for extended build capabilities with BuildKit";
    mainProgram = "docker-buildx";
    homepage = "https://github.com/docker/buildx";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ivan-babrou
      developer-guy
    ];
  };
}
