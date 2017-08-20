require "language/go"

class DockerSlim < Formula
  desc "Tool for optimizing and securing docker containers"
  homepage "https://github.com/docker-slim/docker-slim"
  url "https://github.com/docker-slim/docker-slim.git",
    :tag => "1.18",
    :revision => "8c2da78b4560905e7e6bd101b8d2d5ffc640233c"
  head "https://github.com/docker-slim/docker-slim.git"

  depends_on "go" => :build
  depends_on "govendor" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    ENV["GOPATH"] = buildpath
    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/docker-slim/docker-slim").install contents
    ENV.append_path "PATH", buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    rev = if build.stable?
      stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
    else
      head.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
    end

    ld_flags =
      "-X github.com/docker-slim/docker-slim/utils.appVersionTag=#{version} " \
      "-X github.com/docker-slim/docker-slim/utils.appVersionRev=#{rev}"

    cd "src/github.com/docker-slim/docker-slim" do
      system "govendor", "sync"
      system "go", "build", "-v", "-ldflags", ld_flags.to_s, "./cmd/docker-slim"

      ENV["GOOS"] = "linux"
      ENV["GOARCH"] = "amd64"
      system "go", "build", "-v", "./cmd/docker-slim-sensor"

      libexec.install("docker-slim", "docker-slim-sensor")
      bin.write_exec_script(libexec/"docker-slim")
      prefix.install_metafiles
    end
  end

  test do
    output = "[build] missing image ID/name"
    assert_match output, shell_output("#{bin}/docker-slim build -p")
  end
end
